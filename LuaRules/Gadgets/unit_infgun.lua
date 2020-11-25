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
local morphDefs = include("LuaRules/Configs/morph_defs.lua")
local getSideName = VFS.Include("LuaRules/Includes/sides.lua")
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local GiveOrderToUnit = Spring.GiveOrderToUnit

local function SpawnCrewMembers(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    local x,y,z = Spring.GetUnitPosition(unitID)
    for i = 1, ud.transportCapacity do
        local passengerDefName = getSideName(ud.name) .. "crew"
        local passID = Spring.CreateUnit(passengerDefName, x, y, z, 0, teamID)
        if (passID ~= nil) then
            local env = Spring.UnitScript.GetScriptEnv(unitID)
            if env then
                Spring.UnitScript.CallAsUnit(unitID, env.script.TransportPickup, passID)
            end
        end
    end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    local cp = ud.customParams
    if not cp.infgun then
        return
    end
    GG.Delay.DelayCall(SpawnCrewMembers, {unitID, unitDefID, teamID})
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

    return #(Spring.GetUnitIsTransporting(unitID)) == ud.transportCapacity
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
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


