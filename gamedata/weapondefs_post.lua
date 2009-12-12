--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    weapondefs_post.lua
--  brief:   weaponDef post processing
--  author:  Dave Rodgers
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Per-unitDef weaponDefs
--

local GRAVITY = 120

local function isbool(x)   return (type(x) == 'boolean') end
local function istable(x)  return (type(x) == 'table')   end
local function isnumber(x) return (type(x) == 'number')  end
local function isstring(x) return (type(x) == 'string')  end

local function tobool(val)
  local t = type(val)
  if (t == 'nil') then
    return false
  elseif (t == 'boolean') then
    return val
  elseif (t == 'number') then
    return (val ~= 0)
  elseif (t == 'string') then
    return ((val ~= '0') and (val ~= 'false'))
  end
  return false
end

--------------------------------------------------------------------------------

local function BackwardCompability(wdName,wd)
  -- weapon reloadTime and stockpileTime were seperated in 77b1
  if (tobool(wd.stockpile) and (wd.stockpiletime==nil)) then
    wd.stockpiletime = wd.reloadtime
    wd.reloadtime    = 2             -- 2 seconds
  end

  -- auto detect ota weapontypes
  if (wd.weapontype==nil) then
    local rendertype = tonumber(wd.rendertype) or 0
    if (tobool(wd.dropped)) then
      wd.weapontype = "AircraftBomb";
    elseif (tobool(wd.vlaunch)) then
      wd.weapontype = "StarburstLauncher";
    elseif (tobool(wd.beamlaser)) then
      wd.weapontype = "BeamLaser";
    elseif (tobool(wd.isshield)) then
      wd.weapontype = "Shield";
    elseif (tobool(wd.waterweapon)) then
      wd.weapontype = "TorpedoLauncher";
    elseif (wdName:lower():find("disintegrator",1,true)) then
      wd.weaponType = "DGun"
    elseif (tobool(wd.lineofsight)) then
      if (rendertype==7) then
        wd.weapontype = "LightingCannon";

      -- swta fix (outdated?)
      elseif (wd.model and wd.model:lower():find("laser",1,true)) then
        wd.weapontype = "LaserCannon";

      elseif (tobool(wd.beamweapon)) then
        wd.weapontype = "LaserCannon";
      elseif (tobool(wd.smoketrail)) then
        wd.weapontype = "MissileLauncher";
      elseif (rendertype==4 and tonumber(wd.color)==2) then
        wd.weapontype = "EmgCannon";
      elseif (rendertype==5) then
        wd.weapontype = "Flame";
      --elseif(rendertype==1) then
      --  wd.weapontype = "MissileLauncher";
      else
        wd.weapontype = "Cannon";
      end
    else
      wd.weapontype = "Cannon";
    end
  end

  -- 
  if (tobool(wd.ballistic) or tobool(wd.dropped)) then
    wd.gravityaffected = true
		wd.myGravity = GRAVITY / 900 -- in maps it's in elmos/square second, in weapon it's in elmos/square simframe
  end
end

--------------------------------------------------------------------------------

local function ProcessUnitDef(udName, ud)

  local wds = ud.weapondefs
  if (not istable(wds)) then
    return
  end

  -- add this unitDef's weaponDefs
  for wdName, wd in pairs(wds) do
    if (isstring(wdName) and istable(wd)) then
      local fullName = udName .. '_' .. wdName
      WeaponDefs[fullName] = wd
      wd.filename = ud.filename
    end
  end

  -- convert the weapon names
  local weapons = ud.weapons
  if (istable(weapons)) then
    for i = 1, 32 do
      local w = weapons[i]
      if (istable(w)) then
        if (isstring(w.def)) then
          local ldef = string.lower(w.def)
          local fullName = udName .. '_' .. ldef
          local wd = WeaponDefs[fullName]
          if (istable(wd)) then
            w.name = fullName
          end
        end
        w.def = nil
      end
    end
  end

  -- convert the death explosions
  if (isstring(ud.explodeas)) then
    local fullName = udName .. '_' .. ud.explodeas
    if (WeaponDefs[fullName]) then
      ud.explodeas = fullName
    end
  end
  if (isstring(ud.selfdestructas)) then
    local fullName = udName .. '_' .. ud.selfdestructas
    if (WeaponDefs[fullName]) then
      ud.selfdestructas = fullName
    end
  end
end

--------------------------------------------------------------------------------

local function ProcessWeaponDef(wdName, wd)

  -- backward compability
  BackwardCompability(wdName,wd)
end

--------------------------------------------------------------------------------

-- Process the unitDefs
local UnitDefs = DEFS.unitDefs

for udName, ud in pairs(UnitDefs) do
  if (isstring(udName) and istable(ud)) then
    ProcessUnitDef(udName, ud)
  end
end


for wdName, wd in pairs(WeaponDefs) do
  if (isstring(wdName) and istable(wd)) then
    ProcessWeaponDef(wdName, wd)
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end


--------------------------------------------------------------------------------
-- Damage Types
--------------------------------------------------------------------------------


local damageTypes = VFS.Include("gamedata/damagedefs.lua")

for _, weaponDef in pairs(WeaponDefs) do
  if not weaponDef.isshield then
    local damage = weaponDef.damage
    local defaultDamage = damage["default"]
    
    if defaultDamage and tonumber(defaultDamage) > 0 then
      local damageType = "default"
      if weaponDef.customparams and weaponDef.customparams.damagetype then
        damageType = weaponDef.customparams.damagetype
      end
      local mults = damageTypes[damageType]
      if mults then
        for armorType, mult in pairs(mults) do
          --you can change the default damage; all damage multipliers are based on original default however
          --you will need to explicitly define damage multipliers of 1 in this case
          --other explicit damages override calculated ones
          if not damage[armorType] or armorType == "default" then
            damage[armorType] = defaultDamage * mult
          end
        end
      else
        Spring.Echo("weapondefs_post.lua: Invalid damagetype " .. damageType .. " for weapon " .. weaponDef.name)
      end
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Range Multiplier
--

if (modOptions) then
  if (tonumber(modOptions.weapon_range_mult) or 1 ~= 1) then
    local totalWeapons
    totalWeapons = 0
    local rangeCoeff = modOptions.weapon_range_mult
    local velocityCoeff = rangeCoeff^(2/3)
    local flightTimeCoeff = rangeCoeff^(1/3)
    local accuracyMult = 1 / math.sqrt(rangeCoeff)
    local wobbleMult = 1 / flightTimeCoeff
    
    local mults = {
      range = rangeCoeff,
      dyndamagerange = rangeCoeff,
      weaponvelocity = velocityCoeff,
      weaponacceleration = velocityCoeff,
      flighttime = flightTimeCoeff,
      wobble = wobbleMult,
      accuracy = accuracyMult,
      sprayangle = accuracyMult,
      targetmoveerror = accuracyMult,
    }
    
    
    Spring.Echo("Starting weapon range multiplying, coefficient: "..rangeCoeff)
    for name, weaponDef in pairs(WeaponDefs) do
		if (weaponDef.dynDamageRange == nil) or (weaponDef.dynDamageRange > 220) then
			for tag, mult in pairs(mults) do
				if weaponDef[tag] then
				weaponDef[tag] = weaponDef[tag] * mult
				end
			end
		end
      
      local customParams = weaponDef.customparams
      
      if customParams then
        local armor_penetration_100m = customParams.armor_penetration_100m
        local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration_100m
        if armor_penetration_100m then
          local armor_penetration = (armor_penetration_100m / armor_penetration_1000m) ^ (1/9) * armor_penetration_100m
          local decay = math.log(armor_penetration_1000m / armor_penetration_100m) / 900 / rangeCoeff
          customParams.armor_penetration_100m = armor_penetration * math.exp(100 * decay)
          customParams.armor_penetration_1000m = armor_penetration * math.exp(1000 * decay)
        end
      end
      
      totalWeapons = totalWeapons + 1
    end
    Spring.Echo("Done with the ranges, "..totalWeapons.." weapons processed.")
    
    
  end
    
  if (modOptions.weapon_reload_mult) then
    local totalWeapons
    totalWeapons = 0
    local reloadCoeff
    reloadCoeff = modOptions.weapon_reload_mult
    Spring.Echo("Starting weapon reload multiplying, coefficient: "..reloadCoeff)
    for name in pairs(WeaponDefs) do
      local curReload = WeaponDefs[name].reloadtime
      local rendertype = WeaponDefs[name].rendertype
      local explosiongenerator = WeaponDefs[name].explosiongenerator
      if (curReload) then
        WeaponDefs[name].reloadtime = curReload * reloadCoeff
        if (WeaponDefs[name].sprayangle) then
          WeaponDefs[name].sprayangle  = (WeaponDefs[name].sprayangle/reloadCoeff)
        end
        if (WeaponDefs[name].accuracy) then
          WeaponDefs[name].accuracy = (WeaponDefs[name].accuracy/reloadCoeff)
        end
        totalWeapons = totalWeapons + 1
      end
    end
  end

  if (modOptions.weapon_edgeeffectiveness_mult) then
    local edgeeffectCoeff
    edgeeffectCoeff = modOptions.weapon_edgeeffectiveness_mult
    for name in pairs(WeaponDefs) do
      local curEdgeeffect = WeaponDefs[name].edgeeffectiveness
      if (curEdgeeffect) then
        WeaponDefs[name].edgeeffectiveness = curEdgeeffect * edgeeffectCoeff
      end
    end
  end
    
  if (modOptions.weapon_aoe_mult) then
    local aoeCoeff
    aoeCoeff = modOptions.weapon_aoe_mult
    for name in pairs(WeaponDefs) do
      if (WeaponDefs[name].lineofsight ~= 1) then
        local curAoe = WeaponDefs[name].areaofeffect
        if (curAoe) then
          WeaponDefs[name].areaofeffect = curAoe * aoeCoeff
        end
      end
    end
  end
    
  if (modOptions.weapon_bulletdamage_mult) then
    local bulletCoeff
    bulletCoeff = modOptions.weapon_bulletdamage_mult
    for name in pairs(WeaponDefs) do
      if (WeaponDefs[name].customParams.damagetype == 'smallarms') then
        for armorType,armorDamage in pairs (WeaponDefs[name].damage) do
          WeaponDefs[name].damage[armorType] = armorDamage * bulletCoeff
        end
      end
    end
  end
end

-- set weapon velocities to arc at 45 degrees at max range
for name in pairs(WeaponDefs) do
	if WeaponDefs[name].customParams then
		if WeaponDefs[name].customParams.howitzer then
			WeaponDefs[name].weaponvelocity = math.sqrt(WeaponDefs[name].range * GRAVITY) --Game.gravity)
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------