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
local GetUnitPosition 	    = Spring.GetUnitPosition
local GetUnitTeam		    = Spring.GetUnitTeam
local GetUnitNearestEnemy   = Spring.GetUnitNearestEnemy
local GetUnitDefID          = Spring.GetUnitDefID
local ValidUnitID		    = Spring.ValidUnitID
-- Synced Ctrl
local CreateUnit 		    = Spring.CreateUnit
-- Unsynced Read
local GetUnitCommands	    = Spring.GetUnitCommands
-- Unsynced Ctrl
local GiveOrderToUnit	    = Spring.GiveOrderToUnit
-- constants
local INTERVAL = 5 -- 5 seconds
local PROBABILITY = 0 -- 100% chance of spawn
local SPAWN_LIMIT = 15 -- Number of partisans a single supply dump can support at once
local ENEMY_TOO_CLOSE_RADIUS = 275 -- same as the supply radius
-- variables
local spawners = {}
local couples = {}
local spawnQueue = {}
local unitNamesToSpawn = {}

if (gadgetHandler:IsSyncedCode()) then

	function AddToSpawnQueue(spawnerID, unitName)
		spawnQueue[spawnerID] = unitName
	end

	function gadget:UnitCreated(unitID, unitDefID, teamID)
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.spawnsunit then
			unitNamesToSpawn[unitID] = cp.spawnsunit
			spawners[unitID] = 0
		end
	end

	function gadget:UnitDestroyed(unitID, unitDefID, teamID)
		-- in case spawner is killed, clear it's pending spawn
		if spawnQueue[unitID] then
			spawnQueue[unitID] = nil
		end
		local ud = UnitDefs[unitDefID]
		if spawners[unitID] then
			spawners[unitID] = nil
			unitNamesToSpawn[unitID] = nil
		end
		if couples[unitID] then
			local spawnerID = couples[unitID]
			if ValidUnitID(spawnerID) then -- spawner is still alive, probably (unitID reuse >_>)
				local numSpawned = spawners[spawnerID]
				if numSpawned then -- check numSpawned isn't nil to make doubley sure
					spawners[spawnerID] = numSpawned - 1
				end
			end
			couples[unitID] = nil
		end
		-- is this unit a spawner? We should remove all references to it from spawned units so that ID reuse does not cause any odd stuff
		for spawnedID, spawnerID in pairs(couples) do
			if spawnerID == unitID then
				couples[spawnedID] = nil
			end
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
                local nearbyEnemy = GetUnitNearestEnemy(spawnerID, ENEMY_TOO_CLOSE_RADIUS, false)
                if nearbyEnemy then
                    local ud = UnitDefs[GetUnitDefID(nearbyEnemy)]
                    if ud and ud.customParams and ud.customParams.flag then
                        nearbyEnemy = nil
                    end
                end

				if (not spawnQueue[spawnerID]) and (numSpawned < SPAWN_LIMIT) and (nearbyEnemy == nil) then
					local chance = math.random()
					if chance >= PROBABILITY then
						AddToSpawnQueue(spawnerID, unitNamesToSpawn[spawnerID])
					end
				end
			end
		end
	end


else -- UNSYNCED

end
