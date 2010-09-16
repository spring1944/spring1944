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
local ValidUnitID		= Spring.ValidUnitID
-- Synced Ctrl
local CreateUnit 		= Spring.CreateUnit
-- Unsynced Read
local GetUnitCommands	= Spring.GetUnitCommands
-- Unsynced Ctrl
local GiveOrderToUnit	= Spring.GiveOrderToUnit
-- constants
local INTERVAL = 20 -- 20 seconds
local PROBABILITY = 0.40 -- 60% chance of spawn
local SPAWN_LIMIT = 10 -- Number of partisans a single supply dump can support at once
-- variables
local spawners = {}
local couples = {}

if (gadgetHandler:IsSyncedCode()) then

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		if ud.name:lower() == "ruspresource" then
			spawners[unitID] = 0
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		if ud.name:lower() == "ruspresource" then
			spawners[unitID] = nil
		end
		if ud.name:lower() == "ruspartisanrifle" then
			local spawnerID = couples[unitID]
			if ValidUnitID(spawnerID) then -- spawner is still alive, probably (unitID reuse >_>)
				local numSpawned = spawners[spawnerID]
				if numSpawned then -- check numSpawned isn't nil to make doubley sure
					spawners[spawnerID] = numSpawned - 1
				end
			end
			couples[unitID] = nil
		end
	end

	function gadget:GameFrame(n)
		if n % (INTERVAL * 30) < 0.1 then
			for spawnerID, numSpawned in pairs(spawners) do
				if numSpawned < SPAWN_LIMIT then
					local chance = math.random()
					if chance >= PROBABILITY then
						local x,y,z = GetUnitPosition(spawnerID)
						local teamID = GetUnitTeam(spawnerID)
						local newUnit = CreateUnit("ruspartisanrifle", x + math.random(50),y,z + math.random(50), 1, teamID, false)
						if newUnit then -- unit was successfully created
							spawners[spawnerID] = numSpawned + 1
							couples[newUnit] = spawnerID
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
		end

	end


else -- UNSYNCED

end
