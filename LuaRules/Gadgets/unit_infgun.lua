function gadget:GetInfo()
    return {
        name      = "Guns helper",
        desc      = "Handles guns and their crew members",
        author    = "Jose Luis Cercos-Pita",
        date      = "24/11/2020",
        license   = "GNU GPL v2",
        layer     = 0,
        enabled   = true
    }
end


if (gadgetHandler:IsSyncedCode()) then -- SYNCED

local CMD_MORPH = GG.CustomCommands.GetCmdID("CMD_MORPH")
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local DEFAULT_SIDE = "gbr"
local CAPTURE_RADIUS = 250
local morphDefs = include("LuaRules/Configs/morph_defs.lua")
local getSideName = VFS.Include("LuaRules/Includes/sides.lua")
local GetUnitDefID          = Spring.GetUnitDefID
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local GiveOrderToUnit       = Spring.GiveOrderToUnit
local GetUnitPosition       = Spring.GetUnitPosition
local GetUnitsInSphere      = Spring.GetUnitsInSphere
local GetUnitTeam           = Spring.GetUnitTeam
local TransferUnit          = Spring.TransferUnit
local GetUnitMass           = Spring.GetUnitMass

local infguns = {}
local infguns_indexes = {}
local last_parsed_gun = 0

local function SpawnCrewMembers(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    local x,y,z = Spring.GetUnitPosition(unitID)
    for i = 1, ud.transportCapacity do
        local side = getSideName(ud.name)
        if side == 'UNKNOWN' then
            side = DEFAULT_SIDE
        end
        local passengerDefName = side .. "crew"
        local passID = Spring.CreateUnit(passengerDefName, x, y, z, 0, teamID)
        if (passID ~= nil) then
            local env = Spring.UnitScript.GetScriptEnv(unitID)
            if env then
                Spring.UnitScript.CallAsUnit(unitID, env.script.TransportPickup, passID)
            end
        end
    end

    infguns[#infguns + 1] = unitID
    infguns_indexes[unitID] = #infguns
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    local cp = ud.customParams
    if not cp.infgun then
        return
    end

    GG.Delay.DelayCall(SpawnCrewMembers, {unitID, unitDefID, teamID})
end

function gadget:GameFrame(frame)
    if #infguns == 0 then
        last_parsed_gun = 0
        return
    end
    -- Traverse the next infantry gun, one per frame
    last_parsed_gun = (last_parsed_gun % #infguns) + 1
    local unitID = infguns[last_parsed_gun]
    local transported = GetUnitIsTransporting(unitID)
    if transported and #transported > 0 then
        -- The unit still has crew, let it alone
        return
    end

    -- The gun is abandoned
    local x, y, z = GetUnitPosition(unitID)
    local team = GetUnitTeam(unitID)
    local visitors = GetUnitsInSphere(x, y, z, CAPTURE_RADIUS)
    if not visitors then
        if team ~= GAIA_TEAM_ID then
            TransferUnit(unitID, GAIA_TEAM_ID)
        end
        return
    end
    -- There are visitors around. We are looking for units capable to claim the
    -- gun, i.e. infantry. However, if several teams are disputing the gun, we
    -- are just simply don't doing nothing.
    local new_team = GAIA_TEAM_ID
    for _, u in ipairs(visitors) do
        if u ~= unitID then
            local t = GetUnitTeam(u)
            if t ~= GAIA_TEAM_ID and GetUnitMass(u) then
                if new_team ~= GAIA_TEAM_ID and new_team ~= t then
                    -- Several teams disputing the gun, don't do nothing
                    new_team = nil
                    break
                end

                new_team = t
            end
        end
    end

    if new_team ~= nil and new_team ~= team then
        TransferUnit(unitID, new_team)
    end
end

-- Just allow to morph when the gun is still operative
function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    local ud = UnitDefs[unitDefID]
    local cp = ud.customParams
    if not cp.infgun then
        return true
    end

    if cmdID == CMD.SELFD then
        -- Never tolerate guns self-destroying
        return false
    end

    if not morphDefs[ud.name] then
        return true
    end
    local isMorph, isStop = GG['morphHandler'].IsAMorphCommand(cmdID)
    if not isMorph or isStop then
        return true
    end

    return #(GetUnitIsTransporting(unitID)) == ud.transportCapacity
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    if infguns_indexes[unitID] then
        local i = infguns_indexes[unitID]
        table.remove(infguns, i)
        infguns_indexes[unitID] = nil
        return
    end

    for u, morphData in pairs(GG['morphHandler'].GetMorphingUnits()) do
        local ud = UnitDefs[GetUnitDefID(u)]
        local cp = ud.customParams

        if cp.infgun and #(GetUnitIsTransporting(u)) ~= ud.transportCapacity then
            GG['morphHandler'].StopMorph(u, morphData)
        end
    end
end

else -- UNSYNCED

end


