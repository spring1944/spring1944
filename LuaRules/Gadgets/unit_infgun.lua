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

local getSideName = VFS.Include("LuaRules/Includes/sides.lua")

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

else -- UNSYNCED

end


