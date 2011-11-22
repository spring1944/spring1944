function gadget:GetInfo()
  return {
    name      = "Smoke shells",
    desc      = "Implements smoke screens from artillery strikes",
    author    = "yuritch",
    date      = "14 September 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 100,
    enabled   = true  --  loaded by default?
  }
end

-- how often to check units
local UPDATE_PERIOD = 32
local UPDATE_OFFSET = 5
local VFX_SMOKE_PERIOD = 16
local VFX_SMOKE_OFFSET = 1

--windspeed is divided by this number before affecting smoke
local WIND_SPEED_DIVISOR = 64

-- effect on accuracy of smoked units
local ACCURACY_MULT = 10

-- localize functions
local GetUnitSensorRadius = Spring.GetUnitSensorRadius
local SetUnitSensorRadius = Spring.SetUnitSensorRadius
local SetUnitCloak = Spring.SetUnitCloak
local GetUnitDefID = Spring.GetUnitDefID
local SpawnCEG = Spring.SpawnCEG
local GetUnitsInSphere = Spring.GetUnitsInSphere
local GetWind = Spring.GetWind
local SetUnitWeaponState = Spring.SetUnitWeaponState

local SMOKE_WEAPON = 2 -- WARNING! Assume all smoke weapons will be in this slot
local CMD_SMOKE = 35520 -- this should be changed

local smokeCmdDesc = {
	id 		 = CMD_SMOKE,
  type   = CMDTYPE.ICON_MODE,
	action = "togglesmoke",
	tooltip = 'Toggle between High Explosive and Smoke rounds',
	params = {0, 'Fire HE', 'Fire Smoke'},
}

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local SmokeSources={}
local SmokedUnits={}

local DURATION_MULT = 1

local modOptions = Spring.GetModOptions()
if modOptions and modOptions.smoke_mult then
	DURATION_MULT = modOptions.smoke_mult
end

function gadget:Initialize()
	for weaponId, weaponDef in pairs (WeaponDefs) do
		if weaponDef.customParams.smokeradius then
			Script.SetWatchWeapon(weaponId, true)
		end
	end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local weapons = UnitDefs[unitDefID].weapons
	if weapons and #weapons > 1 then
		local hasSmoke = WeaponDefs[weapons[SMOKE_WEAPON].weaponDef].customParams.smokeradius
		local noButton = WeaponDefs[weapons[SMOKE_WEAPON].weaponDef].customParams.nosmoketoggle
		if hasSmoke and not noButton then
			smokeCmdDesc.params[1] = 0 -- make sure units are correctly spawned with Fire HE as initial state
			Spring.InsertUnitCmdDesc(unitID, 500, smokeCmdDesc)
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	-- remove units from tracking if they die
	SmokedUnits[unitID] = nil
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_SMOKE then
		local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_SMOKE)
		if not cmdDescID then return false end
		if cmdParams[1] == 1 then
			Spring.CallCOBScript(unitID, "SwitchToSmoke", 0)
		else
			Spring.CallCOBScript(unitID, "SwitchToHE", 0)
		end
		smokeCmdDesc.params[1] = cmdParams[1] -- but seriously changing a global var like this is so unsafe
		Spring.EditUnitCmdDesc(unitID, cmdDescID, { params = smokeCmdDesc.params}) 
		return false
	end
	return true
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	tmpWeaponParms=WeaponDefs[weaponID].customParams
	if not tmpWeaponParms then
		return false
	end
	local SmokeRadius=tonumber(tmpWeaponParms.smokeradius) or 0
	local SmokeDuration=tonumber(tmpWeaponParms.smokeduration) or 0 * DURATION_MULT
	local SmokeCEG=tmpWeaponParms.smokeceg
	if (SmokeRadius>0) and (SmokeDuration>0) then
		local tmpSmoke =
		{
			radius = SmokeRadius,
			remainingTimer = SmokeDuration*32,
			ceg = SmokeCEG,
			x = px,
			y = py,
			z = pz,
		}
		table.insert(SmokeSources, tmpSmoke)
	end
	return false
end

function ApplySmoke(unitID)
	local oldSight = GetUnitSensorRadius(unitID, "los")
	local oldRadar = GetUnitSensorRadius(unitID, "radar")
	if oldSight > 0 then
		SmokedUnits[unitID].oldLos = oldSight
	end
	if oldRadar > 0 then
		SmokedUnits[unitID].oldRadar = oldRadar
	end
	
	-- make the unit blind
	SetUnitSensorRadius(unitID, "los", 0)
	SetUnitSensorRadius(unitID, "radar", 0)
	-- hide the unit
	SetUnitCloak(unitID, 2)
	--SetUnitCloak(unitID, true) this is redundant, I'm pretty sure.
	Spring.SetUnitStealth(unitID, true)
	-- affect the weapons
	local tmpUDID = GetUnitDefID(unitID)
	if tmpUDID then
		local tmpWeapons = UnitDefs[tmpUDID].weapons
		for i, tmpWeapon in pairs(tmpWeapons) do
			if (tmpWeapon) and (type(tmpWeapon) == "table") then
				local tmpAccuracy = WeaponDefs[tmpWeapon.weaponDef].accuracy
				tmpAccuracy = tmpAccuracy * ACCURACY_MULT
				SetUnitWeaponState(unitID, i - 1, {accuracy = tmpAccuracy})
			end
		end
	end
end

function RemoveSmoke(unitID)
	-- find out the 'default' los value for that unittype
	local defaultLos = SmokedUnits[unitID].oldLos
	local defaultRadar = SmokedUnits[unitID].oldRadar
	-- set the unit's los to that value
	SetUnitSensorRadius(unitID, "los", defaultLos)
	SetUnitSensorRadius(unitID, "radar", defaultRadar)
	-- unhide the unit
	SetUnitCloak(unitID, 1)
	-- and make it cloak/stealth by its own if it can
	local tmpUDID = GetUnitDefID(unitID)
	if tmpUDID then
		if UnitDefs[tmpUDID].canCloak then
			SetUnitCloak(unitID, true)
		else
			SetUnitCloak(unitID, false)
		end
		if UnitDefs[tmpUDID].steath then
			Spring.SetUnitStealth(unitID, true)
		else
			Spring.SetUnitStealth(unitID, false)
		end
		
		-- also restore it's weapon accuracy
		local tmpWeapons = UnitDefs[tmpUDID].weapons
		for i, tmpWeapon in pairs(tmpWeapons) do
			if (tmpWeapon) and (type(tmpWeapon) == "table") then
				local tmpAccuracy = WeaponDefs[tmpWeapon.weaponDef].accuracy
				SetUnitWeaponState(unitID, i - 1, {accuracy = tmpAccuracy})
			end
		end
	end
end

function gadget:GameFrame(n)
	-- implement smoke decay - each frame
	for i, tmpSource in pairs(SmokeSources) do
		if tmpSource then
			tmpSource.remainingTimer = tmpSource.remainingTimer - 1
			if tmpSource.remainingTimer <= 0 then
				table.remove(SmokeSources, i)
			else
				-- wind blowing the smoke away
				local dx, dy, dz = GetWind()
				tmpSource.x = tmpSource.x + dx/WIND_SPEED_DIVISOR
				tmpSource.y = tmpSource.y + dy/WIND_SPEED_DIVISOR
				tmpSource.z = tmpSource.z + dz/WIND_SPEED_DIVISOR
			end
		end
	end
	-- emit vfx
	if n % VFX_SMOKE_PERIOD == VFX_SMOKE_OFFSET then
		for _, tmpSource in pairs(SmokeSources) do
			if tmpSource then
				SpawnCEG(tmpSource.ceg, tmpSource.x, tmpSource.y, tmpSource.z)
			end
		end
	end
	-- check units in smoke - NOT each frame
	if n % UPDATE_PERIOD == UPDATE_OFFSET then
		-- mark smoked units as not smoked first (to keep track of units leaving smoked area)
		for i, tmpUnit in pairs(SmokedUnits) do
			if tmpUnit.isSmoked then
				SmokedUnits[i].isSmoked = false
			end
		end
		-- loop through all the smokes, search for units
		if #SmokeSources > 0 then
			for _, tmpSmoke in pairs(SmokeSources) do
				if tmpSmoke then
					local unitsInSmoke = GetUnitsInSphere(tmpSmoke.x, tmpSmoke.y, tmpSmoke.z, tmpSmoke.radius)
					if (unitsInSmoke) and (#unitsInSmoke > 0) then
						for _, unitID in ipairs(unitsInSmoke) do
							-- mark units for smoke effect
							if (SmokedUnits[unitID]) then
								SmokedUnits[unitID].isSmoked = true
							else
								SmokedUnits[unitID] = {isSmoked = true, oldLos = 0, oldRadar = 0,}
							end
						end
					end
				end
			end
		end
		-- now loop trough units again, and apply/unapply smoke effects based on marks
		for UnitID, tmpUnit in pairs(SmokedUnits) do
			if not tmpUnit.isSmoked then
				-- remove effect from unit
				RemoveSmoke(UnitID)
				-- remove unit from tracking
				SmokedUnits[UnitID] = nil
			else
				-- apply effect to unit
				ApplySmoke(UnitID)
			end
		end
	end
end