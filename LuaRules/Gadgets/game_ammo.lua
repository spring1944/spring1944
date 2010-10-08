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

-- Constants
local GAIA_TEAM_ID = Spring.GetGaiaTeamID()

-- Variables
local ammoRanges		= {}

local ammoSuppliers		= {}
local aIndices			= {}
local aLengths			= {}

local teams 			= Spring.GetTeamList()
local numTeams			= #teams

for i = 1, numTeams do
	-- setup per-team ammo supplier arrays
	ammoSuppliers[teams[i]] = {}
	aIndices[teams[i]] = {}
	aLengths[teams[i]] = 0
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

if gadgetHandler:IsSyncedCode() then
--	SYNCED


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
	local weaponsWithAmmo = tonumber(UnitDefs[unitDefID].customParams.weaponswithammo) or 2
	local ammoLevel = GetUnitRulesParam(unitID, "ammo")
	local weaponFired = false
	local reloadFrame = 0
	local weapNum = 0

	--for weapNum = 0, weaponsWithAmmo - 1 do
	while not weaponFired and weapNum < weaponsWithAmmo do
		reloadFrame = GetUnitWeaponState(unitID, weapNum, "reloadState")
		--Spring.Echo(reloadFrame)
		weaponFired = weaponFired or CheckReload(unitID, reloadFrame, weapNum)
		weapNum = weapNum + 1
	end
	--Spring.Echo ("Ammo level is: " .. ammoLevel)
	if weaponFired then
		--Spring.Echo ("Weapon fired, ammo level is: " .. ammoLevel)
		--[[local howitzer = WeaponDefs[UnitDefs[unitDefID].weapons[1].weaponDef].customParams.howitzer
		if howitzer then
			SetUnitExperience(unitID, 0)
		end]]
		if ammoLevel == 1 then
			savedFrames[unitID] = reloadFrame
			for weapNum = 0, weaponsWithAmmo - 1 do
				SetUnitWeaponState(unitID, weapNum, {reloadTime = 99999, reloadState = reloadFrame + 99999})
			end
		end
		if ammoLevel > 0 then
			vehicles[unitID].ammoLevel = ammoLevel - 1
			SetUnitRulesParam(unitID, "ammo",	ammoLevel - 1)
		end
	end
end


local function FindSupplier(unitID, teamID)
	for i = 1, aLengths[teamID] do
		local supplierID = ammoSuppliers[teamID][i]
		local separation = GetUnitSeparation(unitID, supplierID, true)
		if separation <= ammoRanges[supplierID] then
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
			return
		else
		
			if oldAmmo < maxAmmo and weaponCost >= 0 then
				local newAmmo = oldAmmo + 1
				Spring.UseUnitResource(supplierID, "e", weaponCost)
				vehicles[unitID].ammoLevel = newAmmo
				SetUnitRulesParam(unitID, "ammo",	newAmmo)
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
					Spring.CallCOBScript(unitID, "RestoreRockets", 0, (difference * 30) - 3000)
				end
				for weapNum = 0, weaponsWithAmmo - 1 do
					SetUnitWeaponState(unitID, weapNum, {reloadTime = reload, reloadState = reloadState})
					vehicles[unitID].reloadFrame[weapNum] = reloadState
				end
			end
		end
	else
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
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	-- Build table of suppliers
	if cp and cp.supplyrange then
		ammoRanges[unitID] = tonumber(cp.supplyrange)
		
		aLengths[teamID] = aLengths[teamID] + 1
		ammoSuppliers[teamID][aLengths[teamID]] = unitID
		aIndices[teamID][unitID] = aLengths[teamID]
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	newVehicles[unitID] = nil
	vehicles[unitID] = nil
	
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	-- Check if the unit was a supplier and was fully built
	if cp and cp.supplyrange and aIndices[teamID][unitID] then
		-- set index of current end unit as index of unit to be deleted
		aIndices[teamID][ammoSuppliers[teamID][aLengths[teamID]]] = aIndices[teamID][unitID]
		-- copy unit info from old index (end of table) to new index (of unit to be deleted)
		ammoSuppliers[teamID][aIndices[teamID][unitID]] = ammoSuppliers[teamID][aLengths[teamID]]
		-- delete unit info of destroyed unit
		ammoSuppliers[teamID][aLengths[teamID]] = nil
		-- delete index of destroyed unit
		aIndices[teamID][unitID] = nil
		-- subtract from length
		aLengths[teamID] = aLengths[teamID] - 1
		-- clean up range cache
		ammoRanges[unitID] = nil
	end
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

		for weapNum = 0, weaponsWithAmmo - 1 do
			local reloadFrame = GetUnitWeaponState(unitID, weapNum, "reloadState")
			vehicles[unitID].reloadFrame[weapNum] = reloadFrame
		end

		savedFrames[unitID] = nil
	end
end


function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
	gadget:UnitFinished(unitID, unitDefID, newTeam)
end


function gadget:TeamDied(teamID)
	ammoSuppliers[teamID] = nil
	aIndices[teamID] = nil
	aLengths[teamID] = nil
end


function gadget:GameFrame(n)
	if (n == initFrame+4) then
		for _, unitID in ipairs(Spring.GetAllUnits()) do
			local unitTeam = GetUnitTeam(unitID)
			local unitDefID = GetUnitDefID(unitID)
			local ud = UnitDefs[unitDefID]
			if ud.customParams.ammosupplier == '1' then
				ammoSuppliers[unitID] = true
			end
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
					for weaponNum = 0, ud.customParams.weaponswithammo - 1 do
						vehicles[unitID].reloadFrame[weaponNum] = 0
						if ammo == 0 then
							SetUnitWeaponState(unitID, weaponNum, {reloadTime = 99999, reloadState = n + 99999})
						end
					end
				end
			end
			newVehicles = {}
		end
		if n % (3*30) < 0.1 then
			for unitID in pairs(vehicles) do
				--skip units which are being transported
				local _, stunned = GetUnitIsStunned(unitID)
				if (not stunned) then
					ProcessWeapons(unitID)
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
