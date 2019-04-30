function gadget:GetInfo()
    return {
        name = "Crew dead notifier",
        desc = "Notify the transporter script that a transportee has dead",
        author = "Jose Luis Cercos-Pita",
        date = "Apr 30, 2019",
        license = "GNU GPL v2",
        layer = 0,
        enabled = true
    }
end

-- UNSYNCED
if not gadgetHandler:IsSyncedCode() then 
    return
end

-- SYNCED
local GetUnitTransporter = Spring.GetUnitTransporter
local GetUnitPosition = Spring.GetUnitPosition
local ValidUnitID = Spring.ValidUnitID

function gadget:Initialize()
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    local tid = GetUnitTransporter(unitID)
    if tid == nil or not ValidUnitID(tid) then
        return
    end
    local x, y, z = GetUnitPosition(unitID)
    local env = Spring.UnitScript.GetScriptEnv(tid)
    Spring.UnitScript.CallAsUnit(tid, env.script.TransportDrop, unitID, x, y, z)
end
