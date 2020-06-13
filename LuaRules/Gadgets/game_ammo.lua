function gadget:GetInfo()
	return {
		name = "Ammo Limiter",
		desc = "Gives units a personal 'ammo' storage that it draws from to fire",
		author = "quantum, FLOZi (C. Lawrence)",
		date = "Feb 01, 2007",
		license = "GNU GPL v2",
		layer = 0,
		enabled = true -- loaded by default?
	}
end

-- UNSYNCED
if not gadgetHandler:IsSyncedCode() then 
	return
end

-- SYNCED
-- function localisations
-- Synced Read
local AreTeamsAllied = Spring.AreTeamsAllied
local GetGameFrame = Spring.GetGameFrame
local ValidUnitID = Spring.ValidUnitID
local GetUnitAllyTeam = Spring.GetUnitAllyTeam
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitIsStunned = Spring.GetUnitIsStunned
local GetUnitNeutral = Spring.GetUnitNeutral
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitRulesParam = Spring.GetUnitRulesParam
local GetUnitSeparation = Spring.GetUnitSeparation
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitWeaponState = Spring.GetUnitWeaponState

-- Synced Ctrl
local SetUnitExperience = Spring.SetUnitExperience
local SetUnitRulesParam = Spring.SetUnitRulesParam
local SetUnitWeaponState = Spring.SetUnitWeaponState
local UseUnitResource = Spring.UseUnitResource
local GetTeamRulesParam = Spring.GetTeamRulesParam
local SetTeamRulesParam = Spring.SetTeamRulesParam

-- Constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()
local RELOAD_FREQUENCY = 3 -- seconds between each reload when in supply range
local RELOAD_AVERAGE_DURATION = RELOAD_FREQUENCY * 11 -- average ammo is around 11.

--[[ 
NB: the customParams used by this script:

	maxammo - The total ammo capacity of this unit
	supplyrange - How far this supply unit can supply
	weaponcost - The cost to reload the weapons with ammo per tick
	weaponswithammo - Number of weapons that use ammo. Must be the first ones. Default is 2
]]

-- Variables
local ammoSuppliersPerAlly = {}
local teamSupplyRangeModifierParamName = 'supply_range_modifier' -- game wide used custom variable
local vehicles = {}
local newVehicles = {}
local savedFrames = {}
local initFrame

local teams = Spring.GetTeamList()
local teamsCount = #teams
local teamIDToAllyID = {}

-- init global team variables
for i = 1, teamsCount do
	local teamID = teams[i]
	if teamID ~= GAIA_TEAM_ID then
		local _,_,_,_,_,allyID = Spring.GetTeamInfo(teamID)
		teamIDToAllyID[teamID] = allyID
		if (ammoSuppliersPerAlly[allyID] == nil) then
			ammoSuppliersPerAlly[allyID] = {}
		end
		Spring.SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, 0) -- e.g. italian supply range
	end
end

-- speedup lookup tables
local supplyRanges = {}
local supplyRangeModifiers = {}
local weaponsWithAmmo = {}
local weaponsCosts = {}
local maxAmmo = {}
local canFly = {}

-- prepare customParams lookup table
for unitDefID, ud in pairs(UnitDefs) do
	if ud.customParams then
		if ud.customParams.supplyrange then supplyRanges[unitDefID] = tonumber(ud.customParams.supplyrange)  end
		if ud.customParams.supplyrangemodifier then supplyRangeModifiers[unitDefID] = tonumber(ud.customParams.supplyrangemodifier) end
		if ud.customParams.weaponswithammo then weaponsWithAmmo[unitDefID] = tonumber(ud.customParams.weaponswithammo) end
		if ud.customParams.weaponcost then weaponsCosts[unitDefID] = tonumber(ud.customParams.weaponcost) end
		if ud.customParams.maxammo then maxAmmo[unitDefID] = tonumber(ud.customParams.maxammo) end
	end
	canFly[unitDefID] = ud.canFly
end

local function GetSupplyRangeModifier(teamID)
	return 1 + (GetTeamRulesParam(teamID, teamSupplyRangeModifierParamName) or 0)
end

local function CheckAmmoSupplier(unitID, unitDefID, teamID)
	if teamID == GAIA_TEAM_ID then
		return
	end

	if supplyRanges[unitDefID] then
		local allyID = teamIDToAllyID[teamID]
		ammoSuppliersPerAlly[allyID][unitID] = supplyRanges[unitDefID]
	end
	if supplyRangeModifiers[unitDefID] then
		SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, GetSupplyRangeModifier(teamID) - 1 + supplyRangeModifiers[unitDefID])
	end
end

local function CheckReload(unitID, reloadFrame, weaponIndex)
	local oldReloadFrame
	if vehicles[unitID] and vehicles[unitID].reloadFrame then
		oldReloadFrame = vehicles[unitID].reloadFrame[weaponIndex]
	end
	if oldReloadFrame == reloadFrame or reloadFrame == 0 then
		return false
	end

	vehicles[unitID].reloadFrame[weaponIndex] = reloadFrame
	return true
end


local function ProcessWeapons(unitID, unitDefID)
	local weaponsWithAmmo = weaponsWithAmmo[unitDefID] or 2
	local ammoLevel = GetUnitRulesParam(unitID, "ammo")
	local weaponFired = false
	local reloadFrame = 0

	for weaponIndex = 1, weaponsWithAmmo do
		reloadFrame = GetUnitWeaponState(unitID, weaponIndex, "reloadState")
		weaponFired = weaponFired or CheckReload(unitID, reloadFrame, weaponIndex)
		if weaponFired then break end
	end	
	
	if weaponFired then
		if ammoLevel == 1 then
			savedFrames[unitID] = reloadFrame
			for weaponIndex = 1, weaponsWithAmmo do
				SetUnitWeaponState(unitID, weaponIndex, {reloadTime = 99999, reloadState = reloadFrame + 99999})
			end
		end
		if ammoLevel > 0 then
			vehicles[unitID].ammoLevel = ammoLevel - 1
			SetUnitRulesParam(unitID, "ammo", ammoLevel - 1)
		end
	end
end

local function FindSupplier(unitID, teamID)
	if teamID == GAIA_TEAM_ID then
		return
	end

	local rangeModifier = GetSupplyRangeModifier(teamID)
	
	-- find all suppliers for given allyID
	local allyID = teamIDToAllyID[teamID]
	for supplierID, supplyRange in pairs (ammoSuppliersPerAlly[allyID]) do
		local separation = GetUnitSeparation(unitID, supplierID, true) or math.huge
		if separation <= supplyRange * rangeModifier then
			return supplierID
		end
	end

	-- no supplier found
	return
end


local function Resupply(unitID, unitDefID)
	local teamID = GetUnitTeam(unitID)
	if teamID == GAIA_TEAM_ID then
		return
	end
	local allyID = GetUnitAllyTeam(unitID)
	
	-- First check own team
	local supplierID = FindSupplier(unitID, teamID)
	
	if supplierID then
		local oldAmmo = tonumber(GetUnitRulesParam(unitID, "ammo"))
		local unitWeaponsWithAmmo = weaponsWithAmmo[unitDefID]
		local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
		local weaponCost = weaponsCosts[unitDefID] or 0
		local maxAmmo = maxAmmo[unitDefID] or 0	
		
		if logisticsLevel < weaponCost then
			SetUnitRulesParam(unitID, "insupply", 2)
			return
		else
			SetUnitRulesParam(unitID, "insupply", 1)
			if oldAmmo < maxAmmo and weaponCost >= 0 then
				-- scale the number of loaded rounds per tick so that total reload time 
				-- never takes much more than RELOAD_AVERAGE_DURATION
				local maxAmmoPerTick = math.round(maxAmmo * RELOAD_FREQUENCY / RELOAD_AVERAGE_DURATION)

				-- ammoPerTick must be between 1 and amount player has logistics for
				local ammoPerTick = math.max(1, maxAmmoPerTick)
				ammoPerTick = math.min(ammoPerTick, math.floor(logisticsLevel / weaponCost))

				UseUnitResource(unitID, "e", weaponCost * ammoPerTick)

				local newAmmo = oldAmmo + ammoPerTick
				vehicles[unitID].ammoLevel = newAmmo
				SetUnitRulesParam(unitID, "ammo", newAmmo)
			end
	
	
			local hasWeapon = UnitDefs[unitDefID].weapons[1]
			local reload = 0
			
			if hasWeapon then
				reload = tonumber(WeaponDefs[hasWeapon.weaponDef].reload)
			else
				reload = GetUnitRulesParam(unitID, "defRegen")
			end
				
			if oldAmmo < 1 then
				local savedFrame = 0
				local unitName = UnitDefs[unitDefID].name
				local currFrame = GetGameFrame()
				
				if savedFrames[unitID] then
					savedFrame = savedFrames[unitID]
				end	
				reloadState = savedFrame
				
				if unitName == "rusbm13n" or unitName == "gernebelwerfer_stationary" then
					local difference = savedFrame - currFrame
					if difference < 0 then
						difference = 0
						reloadState = currFrame + 90 -- add three seconds
					end
					local env = Spring.UnitScript.GetScriptEnv(unitID)
					if env then
						Spring.UnitScript.CallAsUnit(unitID, env.RestoreRockets, (difference * 30) - 3000)
					else
						Spring.CallCOBScript(unitID, "RestoreRockets", 0, (difference * 30) - 3000)
					end	
				end
				
				-- if a unit is LUS-ified, don't muck with
				-- reloads, just rely on the unit script
				local env = Spring.UnitScript.GetScriptEnv(unitID)
				if not env then
					for weaponIndex = 1, unitWeaponsWithAmmo do
						SetUnitWeaponState(unitID, weaponIndex, {reloadTime = reload, reloadState = reloadState})
						vehicles[unitID].reloadFrame[weaponIndex] = reloadState
					end
				end
			end
		end
	else
		SetUnitRulesParam(unitID, "insupply", 0)
		return
	end

end

function gadget:Initialize()
	initFrame = GetGameFrame()
end


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	if maxAmmo[unitDefID] then
		if canFly[unitDefID] then
			SetUnitRulesParam(unitID, "ammo", maxAmmo[unitDefID])
		else
			SetUnitRulesParam(unitID, "ammo", 0)
		end

		-- This is used to delay SetUnitWeaponState call depending on ammo,
		-- so other gadgets (notably the unit_morph gagdet) have a chance to
		-- customize the unit's ammo before the unit's weapons are disabled.
		newVehicles[unitID] = true
	end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
	-- If supplier, add to the table
	CheckAmmoSupplier(unitID, unitDefID, teamID)
end

local function CleanUp(unitID, unitDefID, teamID)
	if supplyRanges[unitDefID] and teamID ~= GAIA_TEAM_ID then
		local allyID = teamIDToAllyID[teamID]
		ammoSuppliersPerAlly[allyID][unitID] = nil
	end
	if supplyRangeModifiers[unitDefID] then
		SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, GetSupplyRangeModifier(teamID) - 1 - supplyRangeModifiers[unitDefID])
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	newVehicles[unitID] = nil
	vehicles[unitID] = nil
	savedFrames[unitID] = nil
	CleanUp(unitID, unitDefID, teamID)
end

-- If unit is loaded into a transport, do a last call to ProcessWeapons
-- before Spring clobbers the reloadState of the weapon.
function gadget:UnitLoaded(unitID, unitDefID)
	if maxAmmo[unitDefID] then
		return ProcessWeapons(unitID, unitDefID)
	end
end

-- If unit is unloaded, reset the vehicles[unitID].reloadFrame table,
-- otherwise next call to ProcessWeapons thinks every weapon has fired.
function gadget:UnitUnloaded(unitID, unitDefID)
	if weaponsWithAmmo[unitDefID] then
		local unitWeaponsWithAmmo = weaponsWithAmmo[unitDefID] or 2

		for weaponIndex = 1, unitWeaponsWithAmmo do
			local reloadFrame = GetUnitWeaponState(unitID, weaponIndex, "reloadState")
			vehicles[unitID].reloadFrame[weaponIndex] = reloadFrame
		end

		savedFrames[unitID] = nil
	end
end

function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
	CleanUp(unitID, unitDefID, oldTeam)
	gadget:UnitFinished(unitID, unitDefID, newTeam)
end

function gadget:TeamDied(teamID)
	SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, 0)
end

function gadget:GameFrame(n)
	if (n == initFrame+4) then
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local unitTeam = GetUnitTeam(unitID)
			local unitDefID = GetUnitDefID(unitID)
			local ud = UnitDefs[unitDefID]
			local maxAmmo = maxAmmo[unitDefID]
			CheckAmmoSupplier(unitID, unitDefID, unitTeam)
			if maxAmmo then
				SetUnitRulesParam(unitID, "ammo", maxAmmo)
				vehicles[unitID] = {
					ammoLevel = maxAmmo,
					reloadFrame = {},
					unitDefID = unitDefID,
				}
				if weaponsWithAmmo[unitDefID] == nil then 
					Spring.Log("game_ammo", 
								"error",
								ud.name .. " has no WEAPONSWITHAMMO"
					) 
				end
				for weaponIndex = 0, weaponsWithAmmo[unitDefID] do
					vehicles[unitID].reloadFrame[weaponIndex] = 0
				end
			end
		end
		newVehicles = {}
	end
	if n > (initFrame+4) then
		if next(newVehicles) then
			for unitID,_ in pairs(newVehicles) do
				local unitDefID = GetUnitDefID(unitID)
				if unitDefID then
					local ud = UnitDefs[unitDefID]
					local ammo = GetUnitRulesParam(unitID, "ammo")
					vehicles[unitID] = {
						ammoLevel = ammo,
						reloadFrame = {},
						unitDefID = unitDefID,
					}
					
					if weaponsWithAmmo[unitDefID] == nil then 
						Spring.Log("game_ammo", 
									"error", 
									ud.name .. " has no WEAPONSWITHAMMO"
						) 
					end
					
					-- if a unit is LUS-ified, don't muck with
					-- reloads, just rely on the unit script
					local env = Spring.UnitScript.GetScriptEnv(unitID)
					if not env then
						for weaponIndex = 1, weaponsWithAmmo[unitDefID] do
							vehicles[unitID].reloadFrame[weaponIndex] = 0
							if ammo == 0 then
								SetUnitWeaponState(unitID, weaponIndex, {reloadTime = 99999, reloadState = n + 99999})
							end
						end
					end
				end
			end
			newVehicles = {}
		end
		
		if n % (RELOAD_FREQUENCY*30) < 0.1 then
			for unitID, vehicleData in pairs(vehicles) do
				-- skip units which are being transported
				-- also skip incomplete units (use the first return value), and neutral units (turrets on unfinished composite ships)
				local stunned = GetUnitIsStunned(unitID) or GetUnitNeutral(unitID)
				if (not stunned) then				
					
					-- if a unit is LUS-ified, don't muck with
					-- reloads, just rely on the unit script
					local env = Spring.UnitScript.GetScriptEnv(unitID)
					if not env then
						ProcessWeapons(unitID, vehicleData.unitDefID)
					end
					
					if not canFly[vehicleData.unitDefID] then
						Resupply(unitID, vehicleData.unitDefID)
					end
				end
			end
		end
	end
end
