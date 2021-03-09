function gadget:GetInfo()
    return {
        name = "1944 APC Handler",
        desc = "APC AI",
        author = "Jose Luis Cercos-Pita",
        date = "21-01-2020",
        license = "GNU GPL v2",
        layer = 1,
        enabled = true
    }
end

if gadgetHandler:IsSyncedCode() then

local GetUnitCommands    = Spring.GetUnitCommands
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitPosition    = Spring.GetUnitPosition
local GetUnitCommands    = Spring.GetUnitCommands
local GetUnitDefID       = Spring.GetUnitDefID
local GetGroundHeight    = Spring.GetGroundHeight
local GiveOrderToUnit    = Spring.GiveOrderToUnit
local GetUnitTeam        = Spring.GetUnitTeam

local RANGE = 800
local FUDGE = 1.05
local CMD_APC = GG.CustomCommands.GetCmdID("CMD_APC")
local TOOLTIPS = {
    "Set automatic transport state\n[Don't autotransport units]",
    "Set automatic transport state\n[Autotransport all units]",
    "Set automatic transport state\n[Autotransport guns]",
}

local function GetCMDParams(transportMass)
    if transportMass >= 100 then
        return {'0', "No APC", "All APC", "Guns APC"}
    else
        return {'0', "No APC", "All APC"}
    end
end

local apcCmdDesc = {
    id = CMD_APC,
    type = CMDTYPE.ICON_MODE,
    name = "APC",
    cursor = 'APC', 
    action = 'apc', 
    tooltip = TOOLTIPS[1],
    params = GetCMDParams(100),
}



local APCUnitDefs = {}
local APCUnits, APCLastUnit = {}, 0
local APCTransportedCmds = {}
local Unloaded = {}

local function findAPC(unitID)
    for i, u in ipairs(APCUnits) do
        if u.unitID == unitID then
            return i
        end
    end
    return nil
end

local function Continue(unitID)
    if not Spring.ValidUnitID(unitID) or Spring.GetUnitIsDead(unitID) then
        APCTransportedCmds[unitID] = nil
        return
    end
    local cmds = APCTransportedCmds[unitID]
    if not cmds or #cmds == 0 then
        APCTransportedCmds[unitID] = nil
        return
    end

    local opts = {}
    for _, cmd in ipairs(cmds) do
        GiveOrderToUnit(unitID, cmd.id, cmd.params, opts)
        opts = {"shift"}
    end

    APCTransportedCmds[unitID] = nil
end

local function ParseAllUnits()
    local teams = Spring.GetTeamList()
    for _, team in ipairs(teams) do
        local sortedUnits = Spring.GetTeamUnitsSorted(team)
        for APCDefID in pairs(APCUnitDefs) do
            if sortedUnits[APCDefID] then
                for _, unitID in pairs(sortedUnits[APCDefID]) do
                    gadget:UnitCreated(unitID, APCDefID)
                    local troops = Spring.GetUnitIsTransporting(unitID)
                    for _, troopID in pairs(troops) do
                        gadget:UnitLoaded(troopID, _, _, unitID)
                    end
                end
            end
        end
    end
end

function gadget:Initialize()
    for unitDefID, unitDef in pairs(UnitDefs) do
        local customParams = unitDef.customParams
        if unitDef.transportCapacity > 0 and not unitDef.modCategories.ship and not customParams.infgun then
            APCUnitDefs[unitDefID] = {
                transportCapacity = unitDef.transportCapacity,
                transportMass = unitDef.transportMass or 100000,
            }
            Spring.Echo("Found APC", unitDef.name)
        end
    end

    ParseAllUnits()
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
    if APCUnitDefs[unitDefID] then
        apcCmdDesc.params = GetCMDParams(APCUnitDefs[unitDefID].transportMass)
        Spring.InsertUnitCmdDesc(unitID, 500, apcCmdDesc)
        APCUnits[#APCUnits + 1] = {
            unitID = unitID,
            unitDefID = unitDefID,
            State = 0,  -- This is changed with the CMD_APC, in gadget:CommandFallback()
            NStates = #apcCmdDesc.params,
        }
    end
end

function gadget:GameFrame(n)
    -- Parse the unloaded units
    for u, _ in pairs(Unloaded) do
        Continue(u)
        Unloaded[u] = nil
    end


    if #APCUnits == 0 then
        return
    end
    APCLastUnit = APCLastUnit % #APCUnits + 1
    if not APCUnits[APCLastUnit] then
        return
    end

    local state = APCUnits[APCLastUnit].State
    if state == 0 then
        -- The unit is not autotransporting
        return;
    end
    local maxTransportMass = APCUnitDefs[APCUnits[APCLastUnit].unitDefID].transportMass
    local minTransportMass = state == 2 and 100 or 0
    local unitID = APCUnits[APCLastUnit].unitID
    if (GetUnitCommands(unitID, 0) or 0) > 0 then
        -- The APC is still busy
        return;
    end

    local x, y, z = GetUnitPosition(unitID)
    local team = GetUnitTeam(unitID)
    local visitors = GetUnitsInCylinder(x, z, RANGE, team)
    if not visitors or #visitors == 0 then
        -- No units close to the APC, so there is nothing to load
        return;
    end

    local opts = {}
    local dst_n, dst_x, dst_z = 0, 0, 0
    for _, visitor in ipairs(visitors) do
        -- Check that we effectively can load the unit
        -- NOTE: Probably we should also check for available space
        local visitorUnitDef = UnitDefs[GetUnitDefID(visitor)]
        local validMass = visitorUnitDef.mass <= maxTransportMass and
                          visitorUnitDef.mass >= minTransportMass
        if Spring.ValidUnitID(visitor) and not Spring.GetUnitIsDead(visitor)
           and not APCTransportedCmds[visitor] and validMass then
            local cmds = Spring.GetUnitCommands(visitor, -1)
            if cmds then
                -- Look for the last fight/move command, before some other
                -- commands which shall not be aided by the transport, like
                -- guard
                local last_move_cmd = 0
                for i, cmd in ipairs(cmds) do
                    if cmd.id == CMD.FIGHT or cmd.id == CMD.MOVE then
                        last_move_cmd = i
                    else
                        break
                    end
                end

                if last_move_cmd > 0 then
                    local cmd_params = cmds[last_move_cmd].params
                    dst_n = dst_n + 1
                    dst_x = dst_x + cmd_params[1]
                    dst_z = dst_z + cmd_params[3]

                    -- Store the commands to restore them when the unit is unloaded
                    cached_cmds = {}
                    for i = last_move_cmd, #cmds do
                        cached_cmds[#cached_cmds + 1] = {id = cmds[i].id,
                                                         params = cmds[i].params}
                    end
                    APCTransportedCmds[visitor] = cached_cmds

                    -- Ask the unit to get loaded
                    GiveOrderToUnit(visitor, CMD.MOVE, {x, y, z}, {})
                    GiveOrderToUnit(unitID, CMD.LOAD_UNITS, {visitor}, opts)
                    opts = {"shift"}
                end
            end
        end
    end

    if dst_n > 0 then
        -- Ask the transport to unload the units in the average destination
        dst_x = dst_x / dst_n
        dst_z = dst_z / dst_n
        local dst_y = GetGroundHeight(dst_x, dst_z)
        GiveOrderToUnit(unitID, CMD.UNLOAD_UNITS, {dst_x, dst_y, dst_z, 100}, {"shift"})
        -- And finally ask it to come back afterwards
        GiveOrderToUnit(unitID, CMD.MOVE, {x, y, z}, {"shift"})        
    end
end

function gadget:UnitUnloaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
    -- Store the unit to be parsed in the next frame
    Unloaded[unitID] = true
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if APCTransportedCmds[unitID] then
        -- A transported unit was killed, forget about it
        APCTransportedCmds[unitID] = nil
    end

    if not APCUnitDefs[unitDefID] then
        return
    end

    local i = findAPC(unitID)
    if not i then
        Spring.Log("1944 APC Handler", "Error", "Cannot destroy APC of type " .. UnitDefs[unitDefID].name .. ", with ID " .. tostring(unitID))
        return false
    end
    table.remove(APCUnits, i)
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    if cmdID ~= CMD_APC then
        return true
    end
    if cmdID == CMD_APC and not APCUnitDefs[unitDefID] then
        return false
    end
    local i = findAPC(unitID)
    if not i then
        Spring.Log("1944 APC Handler", "Error", "Cannot find APC of type " .. UnitDefs[unitDefID].name .. ", with ID " .. tostring(unitID))
        return false
    end

    local status = cmdParams[1]
    local params = GetCMDParams(APCUnitDefs[unitDefID].transportMass)
    params[1] = status

    local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_APC) 
    if (cmdDescID == nil) then
        Spring.Log("1944 APC Handler", "Error", "APC of type " .. UnitDefs[unitDefID].name .. ", with ID " .. tostring(unitID) .. ", has not CMD_APC")
        return false
    end

    APCUnits[i].State = tonumber(status)
    local tooltip = TOOLTIPS[APCUnits[i].State + 1]

    Spring.EditUnitCmdDesc(unitID, cmdDescID, { 
        params  = params, 
        tooltip = tooltip 
    }) 

    return true
end

else -- UNSYNCED

end
