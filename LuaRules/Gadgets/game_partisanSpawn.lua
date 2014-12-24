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
local PROBABILITY = 0 -- 100% chance of spawn
local SPAWN_LIMIT = 15 -- Number of partisans a single supply dump can support at once
-- variables
local spawners = {}
local couples = {}
local spawnQueue = {}

if (gadgetHandler:IsSyncedCode()) then

	function AddToSpawnQueue(spawnerID, unitName)
		spawnQueue[spawnerID] = unitName
	end

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		if ud.name:lower() == "ruspresource" then
			spawners[unitID] = 0
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, teamID)
		-- in case spawner is killed, clear it's pending spawn
		if spawnQueue[unitID] then
			spawnQueue[unitID] = nil
		end
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

	function SpawnUnit(unitName, spawnerID)
		local x,y,z = GetUnitPosition(spawnerID)
		local teamID = GetUnitTeam(spawnerID)
		local newUnit = CreateUnit(unitName, x + math.random(50),y,z + math.random(50), 1, teamID, false)
		if newUnit then -- unit was successfully created
			numSpawned = spawners[spawnerID] or 0
			spawners[spawnerID] = numSpawned + 1
			couples[newUnit] = spawnerID
			local cmds = GetUnitCommands(spawnerID, -1)
			for i = 1, #cmds do
				local cmd = cmds[i]
				GiveOrderToUnit(newUnit, cmd.id, cmd.params, cmd.options.coded)
			end
			Spring.SendMessageToTeam(teamID, "Partisan spawned!")
		end
	end
	
	function gadget:GameFrame(n)
		-- spawn one unit
		local foundSpawnerID = nil
		for spawnerID, unitName in pairs(spawnQueue) do
			SpawnUnit(unitName, spawnerID)
			foundSpawnerID = spawnerID
			-- but only one
			break
		end
		if foundSpawnerID then
			spawnQueue[foundSpawnerID] = nil
		end

		if n % (INTERVAL * 30) < 0.1 then
			for spawnerID, numSpawned in pairs(spawners) do
				if (not spawnQueue[spawnerID]) and (numSpawned < SPAWN_LIMIT) then
					local chance = math.random()
					if chance >= PROBABILITY then
						AddToSpawnQueue(spawnerID, "ruspartisanrifle")
						--[[
						local x,y,z = GetUnitPosition(spawnerID)
						local teamID = GetUnitTeam(spawnerID)
						local newUnit = CreateUnit("ruspartisanrifle", x + math.random(50),y,z + math.random(50), 1, teamID, false)
						if newUnit then -- unit was successfully created
							spawners[spawnerID] = numSpawned + 1
							couples[newUnit] = spawnerID
							local cmds = GetUnitCommands(spawnerID, -1)
							for i = 1, #cmds do
								local cmd = cmds[i]
								GiveOrderToUnit(newUnit, cmd.id, cmd.params, cmd.options.coded)
							end
							Spring.SendMessageToTeam(teamID, "Partisan spawned!")
						end
						]]--
					end
				end
			end
		end

	end


else -- UNSYNCED

end
