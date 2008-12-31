function gadget:GetInfo()
	return {
		name		= "Ammo Limiter",
		desc		= "Gives each unit a personal 'ammo' storage that it draws from to fire, when empty it fires much more slowly",
		author	= "quantum, FLOZi",
		date		= "Feb 01, 2007",
		license = "CC attribution-noncommerical 3.0 or later",
		layer		= 0,
		enabled	= true	--	loaded by default?
	}
end
	
-- function localisations
-- Synced Read
local GetUnitAllyTeam		 	= Spring.GetUnitAllyTeam
local GetUnitDefID			 	= Spring.GetUnitDefID
local GetUnitPosition			= Spring.GetUnitPosition
local GetUnitRulesParam	 	= Spring.GetUnitRulesParam
local GetUnitSeparation		= Spring.GetUnitSeparation
local GetUnitsInCylinder	= Spring.GetUnitsInCylinder
local GetUnitTeam					= Spring.GetUnitTeam
local GetUnitWeaponState	= Spring.GetUnitWeaponState
-- Synced Ctrl
local SetUnitRulesParam		= Spring.SetUnitRulesParam
local SetUnitWeaponState 	= Spring.SetUnitWeaponState

-- Constants
local GAIA_TEAM_ID				= Spring.GetGaiaTeamID()

-- Variables
local ammoSuppliers = {}
local vehicles			= {}
local savedFrames 	= {}

--[[a note on the customParams (custom FBI tags) used by this script:

maxammo				The total ammo capacity of this unit;
ammosupplier			Is this a ammo supplying unit?
supplyrange				How far this supply unit can supply
weaponcost				The cost to reload the weapons with ammo per tick.
weaponswithammo		Number of weapons that use ammo. Must be the first ones. Default is 2.]]

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local function DefaultRegen(unitDefID)
	local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
	local reload = WeaponDefs[weaponID].reload
	return reload
end


local function CheckReload(unitID, reloadFrame, weaponNum)
	--Spring.Echo("Reload Frame for unit " .. unitID .. " weapon# " .. weaponNum .. " is " .. reloadFrame)
	local oldReloadFrame
	if vehicles[unitID].reloadFrame then
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
	local weaponsWithAmmo = UnitDefs[unitDefID].customParams.weaponswithammo or 2
	local ammoLevel = GetUnitRulesParam(unitID, "ammo")
	local weaponFired = false
	local reloadFrame = 0
	
	for weapNum = 0, weaponsWithAmmo - 1 do
		reloadFrame = GetUnitWeaponState(unitID, weapNum, "reloadState")
		--Spring.Echo(reloadFrame)
		weaponFired = weaponFired or CheckReload(unitID, reloadFrame, weapNum)
	end
	--Spring.Echo ("Ammo level is: " .. ammoLevel)
	if weaponFired then
		if ammoLevel == 1 then
			savedFrames[unitID] = reloadFrame
			for weapNum = 0, weaponsWithAmmo - 1 do
				SetUnitWeaponState(unitID, weapNum, {reloadTime = 99999, reloadState = 99999})
			end
		end
		if ammoLevel > 0 then
			vehicles[unitID].ammoLevel = ammoLevel - 1
			SetUnitRulesParam(unitID, "ammo",	ammoLevel - 1)
		end
	end
end


local function FindSupplier(vehicleID)
	local closestSupplier
	local closestDistance = math.huge
	local allyTeam = GetUnitAllyTeam(vehicleID)
	
	for supplierID in pairs(ammoSuppliers) do
		local supAllyTeam = GetUnitAllyTeam(supplierID)
		local supTeam = GetUnitTeam(supplierID)
		if allyTeam == supAllyTeam or supTeam == GAIA_TEAM_ID then
			local separation	= GetUnitSeparation(vehicleID, supplierID, true)
			if separation < closestDistance then
				closestSupplier = supplierID
				closestDistance = separation
			end
		end
	end
	
	return closestSupplier, closestDistance
end


local function Resupply(unitID)
	local unitDefID = GetUnitDefID(unitID)
	local supplierID, distanceFromSupplier = FindSupplier(unitID)
	if supplierID then
		local teamID = Spring.GetUnitTeam(supplierID)
		local logisticsLevel = Spring.GetTeamResources(teamID, "energy")
		if logisticsLevel < 50 then
			return
		end
	else
		return
	end
	
	local supplierDefID = GetUnitDefID(supplierID)
	local weaponCost = tonumber(UnitDefs[unitDefID].customParams.weaponcost)
	local supplyRange = tonumber(UnitDefs[supplierDefID].customParams.supplyrange)
	if supplyRange < distanceFromSupplier then
		return
	end
	local maxAmmo = tonumber(UnitDefs[unitDefID].customParams.maxammo)
	local weaponsWithAmmo = tonumber(UnitDefs[unitDefID].customParams.weaponswithammo)
	local ammoRegen = DefaultRegen(unitDefID)
	local oldAmmo = GetUnitRulesParam(unitID, "ammo")
	
	if oldAmmo < maxAmmo then
		local newAmmo = oldAmmo + 1
		Spring.UseUnitResource(supplierID, "e", weaponCost)
		vehicles[unitID].ammoLevel = newAmmo
		SetUnitRulesParam(unitID, "ammo",	newAmmo)
	end

	local weaponID = UnitDefs[unitDefID].weapons[1].weaponDef
	local reload = tonumber(WeaponDefs[weaponID].reload)
	
	if oldAmmo < 1 then
		local savedFrame = 0
		local currFrame = Spring.GetGameFrame()
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
			Spring.CallCOBScript(unitID, "RestoreRockets", 0, (difference * 30) - 3000)
		end
		for weapNum = 0, weaponsWithAmmo - 1 do
			SetUnitWeaponState(unitID, weapNum, {reloadTime = reload, reloadState = reloadState})
			vehicles[unitID].reloadFrame[weapNum] = reloadState
		end
	end
end
		

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.maxammo then
		SetUnitRulesParam(unitID, "ammo", ud.customParams.maxammo)
		vehicles[unitID] = {
			ammoLevel = tonumber(ud.customParams.maxammo),
			reloadFrame = {},
		}
		for weaponNum = 0, ud.customParams.weaponswithammo do
			vehicles[unitID].reloadFrame[weaponNum] = 0
		end
	end
	if ud.customParams.ammosupplier == '1' then
		ammoSuppliers[unitID] = true
	end
end


function gadget:UnitDestroyed(unitID)
	vehicles[unitID] = nil
	ammoSuppliers[unitID] = nil
end


function gadget:GameFrame(n)
	if n % (3*30) < 0.1 then
		for unitID in pairs(vehicles) do
			local unitDefID = GetUnitDefID(unitID)
			local ammoLevel = GetUnitRulesParam(unitID, "ammo")
			ProcessWeapons(unitID)
			Resupply(unitID)
		end
	end
end

else
--	UNSYNCED
end
