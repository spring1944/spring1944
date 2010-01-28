function gadget:GetInfo()
	return {
		name      = "Partisan Spawner",
		desc      = "Spawns partisans around RUSPResource",
		author    = "FLOZi",
		date      = "28/01/2010",
		license   = "GPL v2",
		layer     = -5,
		enabled   = true --  loaded by default?
	}
end
-- function localisations
-- Synced Read
local GetUnitPosition 	= Spring.GetUnitPosition
local GetUnitTeam		= Spring.GetUnitTeam
-- Synced Ctrl
local CreateUnit 		= Spring.CreateUnit
-- Unsynced Read
local GetUnitCommands	= Spring.GetUnitCommands
-- Unsynced Ctrl
local GiveOrderToUnit	= Spring.GiveOrderToUnit
-- constants
local INTERVAL = 60 -- 1 minute
local PROBABILITY = 0.5 -- 50% chance of spawn
-- variables
local spawners = {}

if (gadgetHandler:IsSyncedCode()) then

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		-- special case for Soviet commander
		if ud.name:lower() == "ruspresource" then
			spawners[unitID] = true
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		-- special case for Soviet commander
		if ud.name:lower() == "ruspresource" then
			spawners[unitID] = false
		end
	end
	
	function gadget:GameFrame(n)
		if n % (INTERVAL * 30) < 0.1 then
			for spawnerID in pairs(spawners) do
				local chance = math.random()
				if chance >= PROBABILITY then
					local x,y,z = GetUnitPosition(spawnerID)
					local teamID = GetUnitTeam(spawnerID)
					local newUnit = CreateUnit("ruspartisanrifle", x + math.random(50),y,z + math.random(50), 1, teamID, false)
					local cmds = GetUnitCommands(spawnerID)
					for i = 1, cmds.n do
						local cmd = cmds[i]
						GiveOrderToUnit(newUnit, cmd.id, cmd.params, cmd.options.coded)
					end
					Spring.SendMessageToTeam(teamID, "Partisan spawned!")
				end
			end
		end
	
	end


else -- UNSYNCED

end
