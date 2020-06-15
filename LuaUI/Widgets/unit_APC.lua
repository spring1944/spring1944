function widget:GetInfo()
	return {
		name = "1944 APC Handler",
		desc = "APC AI",
		author = "Craig Lawrence",
		date = "14-06-2020", -- lockdown baby
		license = "Public Domain",
		layer = 1,
		enabled = true
	}
end

local RANGE = 850

local APCDefCache = {}
local APCUnitCache = {}

local APCCmdCache = {}

local APCTroops = {}
local APCTroopCounts = {}
local troopAPCs = {}

function widget:Initialize()
	for unitDefID, unitDef in pairs(UnitDefs) do
		local customParams = unitDef.customParams
		if unitDef.transportCapacity > 0 and not unitDef.modCategories.ship then
			APCDefCache[unitDefID] = unitDef.transportCapacity
			--Spring.Echo("Found APC", unitDef.name)
		end
	end

	local sortedUnits = Spring.GetTeamUnitsSorted(Spring.GetLocalTeamID())
	for APCDefID in pairs(APCDefCache) do
		if sortedUnits[APCDefID] then
			for _, unitID in pairs(sortedUnits[APCDefID]) do
				widget:UnitCreated(unitID, APCDefID)
				local troops = Spring.GetUnitIsTransporting(unitID)
				for _, troopID in pairs(troops) do
					widget:UnitLoaded(troopID, _, _, unitID)
				end
			end
		end
	end
end

function widget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if APCDefCache[unitDefID] then
		APCUnitCache[unitID] = true
	end
end

local function Continue(unitID, fightFirst)
	local cmds = APCCmdCache[unitID]
	local cmdQ = Spring.GetUnitCommands(unitID, -1)
	if (#cmdQ == 0 and cmds and #cmds > 0) or fightFirst then
		--Spring.Echo("Go on your way...")
		Spring.GiveOrderArrayToUnitArray({unitID}, APCCmdCache[unitID], false)
		APCCmdCache[unitID] = nil
	end
	if fightFirst then
		local ux, uy, uz = Spring.GetUnitPosition(unitID)
		Spring.GiveOrderToUnit(unitID, CMD.FIGHT, {ux, uy, uz}, {"alt", "shift"})
	end
end

function widget:GameFrame(n)
	if n % 16 == 0 then
		for unitID in pairs(APCUnitCache) do
			--Spring.Echo("Tracking APC", unitID)
			local enemyID = Spring.GetUnitNearestEnemy(unitID, RANGE)
			local troops = Spring.GetUnitIsTransporting(unitID)
			if enemyID and #troops > 0 then -- enemy in range, demount and fight
				--Spring.Echo("Enemy in sight!")
				if not APCCmdCache[unitID] then
					local cmdQ = Spring.GetUnitCommands(unitID, -1)
					local cmdCache = {}
					for i, cmd in ipairs(cmdQ) do
						table.insert(cmdCache, {cmd.id, cmd.params, {"shift"}})
					end
					APCCmdCache[unitID] = cmdCache
				end
				local ux, uy, uz = Spring.GetUnitPosition(unitID)
				local tx, ty, tz = Spring.GetUnitPosition(enemyID)
				APCUnitCache[unitID] = {tx, ty, tz}
				Spring.GiveOrderToUnit(unitID, CMD.UNLOAD_UNIT, {ux, uy, uz}, {})
				--[[Spring.GiveOrderToUnitArray(troops, CMD.FIGHT, {tx, ty, tz}, {"shift"})
				for _, troopID in pairs(troops) do
					Spring.GiveOrderToUnit(unitID, CMD.GUARD, {troopID}, {"shift"})
				end]]
			elseif not enemyID and #troops == 0 then -- no enemy in range and no troops loaded
				APCUnitCache[unitID] = true
				if APCTroops[unitID] then
					-- clear guard commands
					Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, {})
					for _, troopID in pairs(APCTroops[unitID]) do
						if Spring.ValidUnitID(troopID) and not Spring.GetUnitIsDead(troopID) then
							Spring.GiveOrderToUnit(troopID, CMD.LOAD_ONTO, {unitID}, {})
						end
					end
				end
			elseif not enemyID then
				Continue(unitID)
			end
		end
	end
end

function widget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	if APCUnitCache[transportID] then
		APCTroops[transportID] = Spring.GetUnitIsTransporting(transportID)
		APCTroopCounts[transportID] = #APCTroops[transportID]
		troopAPCs[unitID] = transportID
	end
end

function widget:UnitUnloaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	if troopAPCs[unitID] then
		local target = APCUnitCache[transportID]
		if type(target) == type(troopAPCs) then
			Spring.GiveOrderToUnit(unitID, CMD.FIGHT, target, {})
			Spring.GiveOrderToUnit(transportID, CMD.GUARD, unitID, {"shift"})
		end
	end
end

function widget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if APCDefCache[unitDefID] then
		if not type(APCUnitCache[unitID]) == type(troopAPCs) then -- we don't see an enemy
			-- bail out
			local ux, uy, uz = Spring.GetUnitPosition(unitID)
			Spring.GiveOrderToUnit(unitID, CMD.UNLOAD_UNIT, {ux, uy, uz}, {})
		end
	end
end

function widget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	if APCUnitCache[unitID] then -- was an apc
		APCUnitCache[unitID] = nil
		APCCmdCache[unitID] = nil
		local troops = APCTroops[unitID]
		if troops then -- had troops assigned
			for _, troopID in pairs(troops) do
				troopAPCs[troopID] = nil -- clear the troop's APC
			end
		end
	elseif troopAPCs[unitID] then -- was a troop with an APC
		local transportID = troopAPCs[unitID]
		APCTroopCounts[transportID] = APCTroopCounts[transportID] - 1
		if APCTroopCounts[transportID] == 0 then
			--Spring.Echo("All my dudes are dead :(")
			Continue(transportID, true)
		end
		troopAPCs[unitID] = nil
	end
end