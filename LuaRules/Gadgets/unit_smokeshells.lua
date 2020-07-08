function gadget:GetInfo()
  return {
    name      = "Smoke shells and generators",
    desc      = "Implements smoke screens from artillery strikes",
    author    = "yuritch",
    date      = "14 September 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 100,
    enabled   = true  --  loaded by default?
  }
end
-- Mindecloakdistance under smoke
-- default sniper has 220, let's make this a bit worse
local Mindecloakdist = 250
local CLOAK_TIMEOUT = 128
-- how often to check units
local UPDATE_PERIOD = 32
local UPDATE_OFFSET = 5
local VFX_SMOKE_PERIOD = 16
local VFX_SMOKE_OFFSET = 1

-- how long a smoke generator takes to recharge
local DEFAULT_SMOKEGEN_COOLDOWN = 15

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
local SetUnitRulesParam = Spring.SetUnitRulesParam
local GetUnitPosition = Spring.GetUnitPosition
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local FindUnitCmdDesc = Spring.FindUnitCmdDesc
local EditUnitCmdDesc = Spring.EditUnitCmdDesc

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local SMOKE_WEAPON = 2 -- WARNING! Assume all smoke weapons will be in this slot
local CMD_SMOKEGEN = GG.CustomCommands.GetCmdID("CMD_SMOKEGEN")

local smokeGenCmdDesc = {
	id 		 = CMD_SMOKEGEN,
	type   = CMDTYPE.ICON,
	name = "Smoke Screen",
	action = "smokegen",
	tooltip = 'Activate Smoke generator',
	hidden = false,
	disabled = false,
}


local SmokeSources={}
local SmokedUnits={}

local SmokeGenCooldowns = {}

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
	
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	-- smoke generator
	local params = UnitDefs[unitDefID].customParams
	if params then
		if params.smokegenerator then
			InsertUnitCmdDesc(unitID, smokeGenCmdDesc)
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	-- remove units from tracking if they die
	SmokedUnits[unitID] = nil
	SmokeGenCooldowns[unitID] = nil
end

function ChangeSmokeGenStatus(unitID, smokeGenEnabled)
	local cmdDescID = FindUnitCmdDesc(unitID, CMD_SMOKEGEN)
	if cmdDescID then
		local disabledSmokeCmd = {}
		for k,v in pairs(smokeGenCmdDesc) do
			disabledSmokeCmd[k] = v
		end
		disabledSmokeCmd.disabled = not smokeGenEnabled
		EditUnitCmdDesc(unitID, cmdDescID, disabledSmokeCmd)
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_SMOKEGEN then
		-- has our generator recharged?
		if (SmokeGenCooldowns[unitID] or 0) == 0 then
			-- start smoke generator!
			local params = UnitDefs[unitDefID].customParams
			local px, py, pz = GetUnitPosition(unitID)
			local tmpSmoke =
			{
				radius = tonumber(params.smokeradius) or 0,
				remainingTimer = tonumber(params.smokeduration) or 0 * DURATION_MULT * 32,
				ceg = params.smokeceg,
				x = px,
				y = py,
				z = pz,
			}
			table.insert(SmokeSources, tmpSmoke)
			SmokeGenCooldowns[unitID] = tonumber(params.smokegencooldown or DEFAULT_SMOKEGEN_COOLDOWN)
			ChangeSmokeGenStatus(unitID, false)
		end
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
	local oldAirLos = GetUnitSensorRadius(unitID, "airLos")
	local oldSeismic = GetUnitSensorRadius(unitID, "seismic")

	-- On first round oldLos = 0, check that to avoid overwriting it in later rounds
	if oldSight > 0 and SmokedUnits[unitID].oldLos == 0 then
		SmokedUnits[unitID].oldLos = oldSight
	end
	if oldRadar > 0 then
		SmokedUnits[unitID].oldRadar = oldRadar
	end
	if oldAirLos and oldAirLos > 0 then
		SmokedUnits[unitID].oldAirLos = oldAirLos
	end
	if oldSeismic and oldSeismic > 0 then
		SmokedUnits[unitID].oldSeismic = oldSeismic
	end

	SetUnitRulesParam(unitID, "smoked", 1)
	-- make the unit blind
	SetUnitSensorRadius(unitID, "los", 180)
	SetUnitSensorRadius(unitID, "radar", 0)
	SetUnitSensorRadius(unitID, "airLos", 0)
	SetUnitSensorRadius(unitID, "seismic", 0)

	-- hide the unit
	local tmpUDID = GetUnitDefID(unitID)
	if tmpUDID then
		if UnitDefs[tmpUDID].canCloak then
			SetUnitCloak(unitID, 2)
			else
			SetUnitCloak(unitID, 2, Mindecloakdist)
			Spring.SetUnitRulesParam(unitID, 'mindecloakdist', Mindecloakdist)
		end
		Spring.SetUnitRulesParam(unitID, 'decloak_activity_frame', Spring.GetGameFrame())
	end
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
				SetUnitWeaponState(unitID, i, {accuracy = tmpAccuracy})
			end
		end
	end
	SmokedUnits[unitID].smokeApplied = true
end

function RemoveSmoke(unitID)
	-- find out the 'default' los value for that unittype
	local defaultLos = SmokedUnits[unitID].oldLos
	local defaultRadar = SmokedUnits[unitID].oldRadar
	local defaultAirLos = SmokedUnits[unitID].oldAirLos
	local defaultSeismic = SmokedUnits[unitID].oldSeismic
	local defaultMincloak = SmokedUnits[unitID].oldMincloak

	SetUnitRulesParam(unitID, "smoked", 0)
	-- Set sensor values back to unit defaults
	-- airLos seems to also set los in current engine (104.0.1). That's why airLos has to be set first.
	SetUnitSensorRadius(unitID, "airLos", defaultAirLos)
	SetUnitSensorRadius(unitID, "los", defaultLos)
	SetUnitSensorRadius(unitID, "radar", defaultRadar)
	SetUnitSensorRadius(unitID, "seismic", defaultSeismic)

	-- unhide the unit
	--SetUnitCloak(unitID, 1)
	-- and make it cloak/stealth by its own if it can
	local tmpUDID = GetUnitDefID(unitID)
	if tmpUDID then
		if UnitDefs[tmpUDID].canCloak then
			SetUnitCloak(unitID, true)
		else
			SetUnitCloak(unitID, false)
		end
		if UnitDefs[tmpUDID].stealth then
			Spring.SetUnitStealth(unitID, true)
		else
			Spring.SetUnitStealth(unitID, false)
		end
		
		-- also restore it's weapon accuracy
		local tmpWeapons = UnitDefs[tmpUDID].weapons
		for i, tmpWeapon in pairs(tmpWeapons) do
			if (tmpWeapon) and (type(tmpWeapon) == "table") then
				local tmpAccuracy = WeaponDefs[tmpWeapon.weaponDef].accuracy
				SetUnitWeaponState(unitID, i, {accuracy = tmpAccuracy})
			end
		end
	end
	SmokedUnits[unitID].smokeApplied = false
end

local lastCloaked = {}
local lastDecloaked = {}
-- AllowUnitCloak(unitID, enemyID) -> return cloakStatus
-- enemyID is nil if there is no unit within minCloakDistance
-- called every SlowUpdate to check if you want to stay cloaked
function gadget:AllowUnitCloak(unitID, enemyID)
	--Spring.Echo("AllowUnitCloak", enemyID)
	if SmokedUnits[unitID] then
		local checkID = Spring.GetUnitNearestEnemy(unitID, 5000, false)
		local separation = checkID and Spring.GetUnitSeparation(unitID, checkID) or "no enemy"
		local name = UnitDefs[Spring.GetUnitDefID(unitID)].name
		--Spring.Echo("SmokedUnit", name, unitID, enemyID, checkID, separation, SmokedUnits[unitID].underSmoke, Spring.GetUnitRulesParam(unitID, 'mindecloakdist'))
	end
	local n = Spring.GetGameFrame()
	local canCloak = (enemyID == nil) and (((lastDecloaked[unitID] or 0) + CLOAK_TIMEOUT) < n)
	if canCloak then 
		lastCloaked[unitID] = n 
	end
	--Spring.Echo(unitID, enemyID, "I last cloaked in frame", lastCloaked[unitID], lastDecloaked[unitID], canCloak)
	return canCloak
end

-- AllowUnitDecloak(unitID, objectID, weaponID) -> return allowToDecloak
-- called when building or firing
-- also every SlowUpdate if already cloaked?
function gadget:AllowUnitDecloak(unitID, objectID, weaponID)
	--Spring.Echo("AllowUnitDecloak", unitID, objectID, weaponID)
	lastDecloaked[unitID] = Spring.GetGameFrame()
	return true
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
				tmpSource.z = tmpSource.z + dz/WIND_SPEED_DIVISOR
			end
		end
	end
	-- emit vfx
	if n % VFX_SMOKE_PERIOD == VFX_SMOKE_OFFSET then
		for _, tmpSource in pairs(SmokeSources) do
			if tmpSource then
				SpawnCEG(tmpSource.ceg, tmpSource.x, tmpSource.y+10, tmpSource.z)
			end
		end
	end
	-- check units in smoke - NOT each frame
	if n % UPDATE_PERIOD == UPDATE_OFFSET then
		-- mark smoked units as not smoked first (to keep track of units leaving smoked area)
		for i, tmpUnit in pairs(SmokedUnits) do
			if tmpUnit.underSmoke then
				SmokedUnits[i].underSmoke = false
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
								SmokedUnits[unitID].underSmoke = true
							else
								SmokedUnits[unitID] = {underSmoke = true, oldLos = 0, oldRadar = 0,
                                    oldAirLos = 0, oldSeismic = 0}
							end
						end
					end
				end
			end
		end
		-- now loop trough units again, and apply/unapply smoke effects based on marks
		for UnitID, tmpUnit in pairs(SmokedUnits) do
			if not tmpUnit.underSmoke then
				-- remove effect from unit
				RemoveSmoke(UnitID)
				-- remove unit from tracking
				SmokedUnits[UnitID] = nil
				Spring.SetUnitRulesParam(UnitID, 'decloak_activity_frame', n)
			elseif ((Spring.GetUnitRulesParam(UnitID, 'decloak_activity_frame') or 0) + CLOAK_TIMEOUT) < n then
				if not SmokedUnits[UnitID].smokeApplied then
					-- apply effect to unit
					GG.cloakedUnits[UnitID] = Spring.GetUnitDefID(UnitID)
					ApplySmoke(UnitID)
				end
			end
		end
		-- process smoke generator cooldown
		for id, duration in pairs(SmokeGenCooldowns) do
			if (SmokeGenCooldowns[id] or 0) > 0 then
				SmokeGenCooldowns[id] = SmokeGenCooldowns[id] - 1
				-- enable/disable command
				local smokegenReady = true
				if SmokeGenCooldowns[id] > 0 then
					smokegenReady = false
				end
				ChangeSmokeGenStatus(id, smokegenReady)
			end
		end
	end
end
