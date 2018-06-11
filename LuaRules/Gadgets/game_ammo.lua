function gadget:GetInfo()
	return {
		name    = "Ammo Limiter",
		desc    = "Gives units a personal 'ammo' storage that it draws from to fire",
		author  = "quantum, FLOZi (C. Lawrence)",
		date    = "Feb 01, 2007",
		license = "GNU GPL v2",
		layer   = 0,
		enabled = true -- loaded by default?
	}
end

-- function localisations
-- Synced Read
local AreTeamsAllied	 = Spring.AreTeamsAllied
local GetGameFrame       = Spring.GetGameFrame
local ValidUnitID		 = Spring.ValidUnitID
--local GetUnitAllyTeam    = Spring.GetUnitAllyTeam
local GetUnitDefID       = Spring.GetUnitDefID
local GetUnitIsStunned   = Spring.GetUnitIsStunned
local GetUnitPosition    = Spring.GetUnitPosition
local GetUnitRulesParam  = Spring.GetUnitRulesParam
local GetUnitSeparation  = Spring.GetUnitSeparation
local GetUnitsInCylinder = Spring.GetUnitsInCylinder
local GetUnitTeam        = Spring.GetUnitTeam
local GetUnitWeaponState = Spring.GetUnitWeaponState
-- Synced Ctrl
local SetUnitExperience  = Spring.SetUnitExperience
local SetUnitRulesParam  = Spring.SetUnitRulesParam
local SetUnitWeaponState = Spring.SetUnitWeaponState
local UseUnitResource	 = Spring.UseUnitResource
local GetTeamRulesParam	= Spring.GetTeamRulesParam
local SetTeamRulesParam	= Spring.SetTeamRulesParam

-- Constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()

-- seconds between each reload when in supply range
local RELOAD_FREQUENCY = 3
-- average ammo is around 11.
local RELOAD_AVERAGE_DURATION = RELOAD_FREQUENCY * 11

-- Variables
local ammoRanges		= {} -- supplierID = ammoRange
local ammoRangeCache		= {} -- unitDefID = range

local ammoSuppliers		= {}

local teamSupplyRangeModifierParamName = 'supply_range_modifier'
local supplyModifiersCache = {}

local teams 			= Spring.GetTeamList()
local numTeams			= #teams

if gadgetHandler:IsSyncedCode() then
--	SYNCED
for i = 1, numTeams do
	local teamID = teams[i]
	-- setup per-team ammo supplier arrays
	ammoSuppliers[teamID] = {}
	Spring.SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, 0)
end

local vehicles = {}
local newVehicles = {}
local savedFrames = {}
local initFrame

--[[ 
NB: the customParams used by this script:

	maxammo				The total ammo capacity of this unit
	supplyrange				How far this supply unit can supply
	weaponcost				The cost to reload the weapons with ammo per tick
	weaponswithammo			Number of weapons that use ammo. Must be the first ones. Default is 2
]]

local function GetSupplyRangeModifier(teamID)
	return 1 + (GetTeamRulesParam(teamID, teamSupplyRangeModifierParamName) or 0)
end

local function CheckAmmoSupplier(unitID, unitDefID, teamID, cp)
	if cp.supplyrange then
		ammoRangeCache[unitDefID] = tonumber(cp.supplyrange)	
		ammoSuppliers[teamID][unitID] = ammoRangeCache[unitDefID]
	end
	if cp.supplyrangemodifier then
		local modifier = tonumber(cp.supplyrangemodifier)
		supplyModifiersCache[unitDefID] = modifier
		SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, GetSupplyRangeModifier(teamID) - 1 + supplyModifiersCache[unitDefID])
	end
end

local function CheckReload(unitID, reloadFrame, weaponNum)
	local oldReloadFrame
	if vehicles[unitID] and vehicles[unitID].reloadFrame then
		oldReloadFrame = vehicles[unitID].reloadFrame[weaponNum]
	end
	if oldReloadFrame == reloadFrame or reloadFrame == 0 then
		return false
	end

	vehicles[unitID].reloadFrame[weaponNum] = reloadFrame
	return true
end


local function ProcessWeapons(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local weaponsWithAmmo = tonumber(UnitDefs[unitDefID].customParams.weaponswithammo) or 2
	local ammoLevel = GetUnitRulesParam(unitID, "ammo")
	local weaponFired = false
	local weapNum = 1
	local reloadFrame = 0

	while not weaponFired and weapNum <= weaponsWithAmmo do
		reloadFrame = GetUnitWeaponState(unitID, weapNum, "reloadState")
		weaponFired = weaponFired or CheckReload(unitID, reloadFrame, weapNum)
		weapNum = weapNum + 1
	end
	if weaponFired then
		--[[local howitzer = WeaponDefs[UnitDefs[unitDefID].weapons[1].weaponDef].customParams.howitzer
		if howitzer then
			SetUnitExperience(unitID, 0)
		end]]
		if ammoLevel == 1 then
			savedFrames[unitID] = reloadFrame
			for weapNum = 1, weaponsWithAmmo do
				SetUnitWeaponState(unitID, weapNum, {reloadTime = 99999, reloadState = reloadFrame + 99999})
			end
		end
		if ammoLevel > 0 then
			vehicles[unitID].ammoLevel = ammoLevel - 1
			SetUnitRulesParam(unitID, "ammo", ammoLevel - 1)
		end
	end
end

local function FindSupplier(unitID, teamID)
	local rangeModifier = GetSupplyRangeModifier(teamID)
	for supplierID, ammoRange in pairs(ammoSuppliers[teamID]) do
		local separation = GetUnitSeparation(unitID, supplierID, true) or math.huge
		if separation <= ammoRange * rangeModifier then
			return supplierID
		end
	end
	-- no supplier found
	return
end


local function Resupply(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local teamID = GetUnitTeam(unitID)
	-- First check own team
	local supplierID = FindSupplier(unitID, teamID)
	-- Then check all allied teams if no supplier found
	local i = 1
	while not supplierID and i <= numTeams do
		local supTeam = teams[i]
		if supTeam ~= teamID and (AreTeamsAllied(supTeam, teamID) or supTeam == GAIA_TEAM_ID) then
			supplierID = FindSupplier(unitID, supTeam)
		end
		i = i + 1
	end
	if supplierID then
		local oldAmmo = GetUnitRulesParam(unitID, "ammo")
		local weaponsWithAmmo = tonumber(UnitDefs[unitDefID].customParams.weaponswithammo)
		local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
		local weaponCost = tonumber(UnitDefs[unitDefID].customParams.weaponcost)
		local maxAmmo = tonumber(UnitDefs[unitDefID].customParams.maxammo)		
		
		if logisticsLevel < weaponCost then
			SetUnitRulesParam(unitID, "insupply", 2)
			return
		else
			SetUnitRulesParam(unitID, "insupply", 1)
			if oldAmmo < maxAmmo and weaponCost >= 0 then
                -- scale the number of loaded rounds per tick so that total reload time 
                -- never takes much more than RELOAD_AVERAGE_DURATION
                -- (math.floor + 0.5 trick is because Lua lacks math.round, and we need integers)
                local roundsPerTick = math.floor(maxAmmo * RELOAD_FREQUENCY / RELOAD_AVERAGE_DURATION + 0.5)
                -- roundsPerTick * ammocost cannot be higher than logisticsLevel we have
                roundsPerTick = math.min(math.floor(logisticsLevel / weaponCost), roundsPerTick)

                if roundsPerTick == 0 then
                    roundsPerTick = 1
                end

				UseUnitResource(unitID, "e", weaponCost * roundsPerTick)

				local newAmmo = oldAmmo + roundsPerTick
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
				local currFrame = GetGameFrame()
				if savedFrames[unitID] then
					savedFrame = savedFrames[unitID]
				end
				reloadState = savedFrame
				if UnitDefs[unitDefID].name == "rusbm13n" or UnitDefs[unitDefID].name == "gernebelwerfer_stationary" then
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
				local env = Spring.UnitScript.GetScriptEnv(unitID)
				-- if a unit is LUS-ified, don't muck with
				-- reloads, just rely on the unit script
				if not env then
					for weapNum = 1, weaponsWithAmmo do
						SetUnitWeaponState(unitID, weapNum, {reloadTime = reload, reloadState = reloadState})
						vehicles[unitID].reloadFrame[weapNum] = reloadState
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
	local ud = UnitDefs[unitDefID]
	if ud.customParams.maxammo then
		if ud.canFly then
			SetUnitRulesParam(unitID, "ammo", ud.customParams.maxammo)
		else
			SetUnitRulesParam(unitID, "ammo", 0)
		end

		--This is used to delay SetUnitWeaponState call depending on ammo,
		--so other gadgets (notably the unit_morph gagdet) have a chance to
		--customize the unit's ammo before the unit's weapons are disabled.
		newVehicles[unitID] = true
	end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
	if ammoRangeCache[unitDefID] or supplyModifiersCache[unitDefID] then
		if ammoRangeCache[unitDefID] then
			ammoSuppliers[teamID][unitID] = ammoRangeCache[unitDefID]
		end
		if supplyModifiersCache[unitDefID] then
			SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, GetSupplyRangeModifier(teamID) - 1 + supplyModifiersCache[unitDefID])
		end
	else
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		-- Build table of suppliers
		if cp then -- can be a supplier
			CheckAmmoSupplier(unitID, unitDefID, teamID, cp)
		end
	end
end

local function CleanUp(unitID, unitDefID, teamID)
	if ammoRangeCache[unitDefID] then
		ammoSuppliers[teamID][unitID] = nil
	end
	if supplyModifiersCache[unitDefID] then
		SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, GetSupplyRangeModifier(teamID) - 1 - supplyModifiersCache[unitDefID])
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	newVehicles[unitID] = nil
	vehicles[unitID] = nil
	CleanUp(unitID, unitDefID, teamID)
end

--If unit is loaded into a transport, do a last call to ProcessWeapons
--before Spring clobbers the reloadState of the weapon.
function gadget:UnitLoaded(unitID, unitDefID)
	if UnitDefs[unitDefID].customParams.maxammo then
		return ProcessWeapons(unitID)
	end
end

--If unit is unloaded, reset the vehicles[unitID].reloadFrame table,
--otherwise next call to ProcessWeapons thinks every weapon has fired.
function gadget:UnitUnloaded(unitID, unitDefID)
	local ud = UnitDefs[unitDefID]

	if ud.customParams.maxammo then
		local weaponsWithAmmo = ud.customParams.weaponswithammo or 2

		for weapNum = 1, weaponsWithAmmo do
			local reloadFrame = GetUnitWeaponState(unitID, weapNum, "reloadState")
			vehicles[unitID].reloadFrame[weapNum] = reloadFrame
		end

		savedFrames[unitID] = nil
	end
end


function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
	CleanUp(unitID, unitDefID, oldTeam)
	--gadget:UnitDestroyed(unitID, unitDefID, oldTeam)
	gadget:UnitFinished(unitID, unitDefID, newTeam)
end


function gadget:TeamDied(teamID)
	ammoSuppliers[teamID] = {}
	SetTeamRulesParam(teamID, teamSupplyRangeModifierParamName, 0)
end


function gadget:GameFrame(n)
	if (n == initFrame+4) then
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local unitTeam = GetUnitTeam(unitID)
			local unitDefID = GetUnitDefID(unitID)
			local ud = UnitDefs[unitDefID]
			if ud.customParams then
				CheckAmmoSupplier(unitID, unitDefID, unitTeam, ud.customParams)
			end
			if ud.customParams.maxammo then
				SetUnitRulesParam(unitID, "ammo", ud.customParams.maxammo)
				vehicles[unitID] = {
					ammoLevel = tonumber(ud.customParams.maxammo),
					reloadFrame = {},
				}
				if not ud.customParams.weaponswithammo then Spring.Log("game_ammo", "error",ud.name .. " has no WEAPONSWITHAMMO") end
				for weaponNum = 0, ud.customParams.weaponswithammo do
					vehicles[unitID].reloadFrame[weaponNum] = 0
				end
			end
		end
		newVehicles = {}
	end
	if n > (initFrame+4) then
		if next(newVehicles) then
			for unitID in pairs(newVehicles) do
				local unitDefID = GetUnitDefID(unitID)
				if unitDefID then
					local ud = UnitDefs[unitDefID]
					local ammo = GetUnitRulesParam(unitID, "ammo")
					vehicles[unitID] = {
						ammoLevel = ammo,
						reloadFrame = {},
					}
					if not ud.customParams.weaponswithammo then Spring.Log("game_ammo", "error",ud.name .. " has no WEAPONSWITHAMMO") end

					local env = Spring.UnitScript.GetScriptEnv(unitID)
					-- if a unit is LUS-ified, don't muck with
					-- reloads, just rely on the unit script
					if not env then
						for weaponNum = 1, ud.customParams.weaponswithammo do
							vehicles[unitID].reloadFrame[weaponNum] = 0
							if ammo == 0 then
								SetUnitWeaponState(unitID, weaponNum, {reloadTime = 99999, reloadState = n + 99999})
							end
						end
					end
				end
			end
			newVehicles = {}
		end
		
		if n % (RELOAD_FREQUENCY*30) < 0.1 then
			for unitID in pairs(vehicles) do
				--skip units which are being transported
				-- also skip incomplete units (use the first return value)
				local stunned = GetUnitIsStunned(unitID)
				if (not stunned) then
					local env = Spring.UnitScript.GetScriptEnv(unitID)
					-- if a unit is LUS-ified, don't muck with
					-- reloads, just rely on the unit script
					if not env then
						ProcessWeapons(unitID)
					end
					local ud = UnitDefs[GetUnitDefID(unitID)]
					if not ud.canFly then
						Resupply(unitID)
					end
				end
			end
		end
	end
end

else
--	UNSYNCED
end
