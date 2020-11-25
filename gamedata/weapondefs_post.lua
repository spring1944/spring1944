VFS.Include("LuaRules/Includes/utilities.lua", nil, VFS.ZIP)
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
local FUNCTIONS_TO_REMOVE = {"new", "append", "clone"}

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
			wd.weapontype = "AircraftBomb"
		elseif (tobool(wd.vlaunch)) then
			wd.weapontype = "StarburstLauncher"
		elseif (tobool(wd.beamlaser)) then
			wd.weapontype = "BeamLaser"
		elseif (tobool(wd.waterweapon)) then
			wd.weapontype = "TorpedoLauncher"
		elseif (wdName:lower():find("disintegrator",1,true)) then
			wd.weaponType = "DGun"
		elseif (tobool(wd.lineofsight)) then
			if (rendertype==7) then
				wd.weapontype = "LightingCannon"

			-- swta fix (outdated?)
			elseif (wd.model and wd.model:lower():find("laser",1,true)) then
				wd.weapontype = "LaserCannon"

			elseif (tobool(wd.beamweapon)) then
				wd.weapontype = "LaserCannon"
			elseif (tobool(wd.smoketrail)) then
				wd.weapontype = "MissileLauncher"
			elseif (rendertype==4 and tonumber(wd.color)==2) then
				wd.weapontype = "EmgCannon"
			elseif (rendertype==5) then
				wd.weapontype = "Flame"
			--elseif(rendertype==1) then
			--  wd.weapontype = "MissileLauncher";
			else
				wd.weapontype = "Cannon"
			end
		else
			wd.weapontype = "Cannon"
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
modOptions = modOptions or {}

local UnitDefs = DEFS.unitDefs
local cegCache = {}
local categoryCache = {}
local weapCostCache = {}
local damageTypes = VFS.Include("gamedata/damagedefs.lua")

--------------------------------------------------------------------------------

local function CopyCategories(ud)
	local weapons = ud.weapons
	local weaponsWithAmmo = (ud.customparams and ud.customparams.weaponswithammo and tonumber(ud.customparams.weaponswithammo)) or 0

	local removeCategories
	if ud.customparams and ud.customparams.weapontoggle == "priorityAPHE" then
		removeCategories = 2
	elseif ud.customparams and ud.customparams.weapontoggle == "priorityAPHEATHE" then
		removeCategories = 3
	end

	local categoriesToRemove
	for weaponID, weapon in pairs(weapons) do --weaponID = 1, #weapons do -- TODO: move this loop into a function
		local targetCat = categoryCache[string.lower(weapon.name or 'NIL WEAPON NAME')]
		if targetCat then
			local only = targetCat.only
			local bad = targetCat.bad
			-- remove categories from HE weapons if they already exist in AP
			if removeCategories then
				if weaponID == 1 then
					categoriesToRemove = only
				elseif weaponID >= removeCategories and weaponID <= weaponsWithAmmo then
					for cat in categoriesToRemove:gmatch("%S+") do
						if cat then
							cat = "%f[%a]" .. cat .. "%f[%A]"
							if only then
								only = only:gsub(cat, "")
							end
							if bad then
								bad = bad:gsub(cat, "")
							end
						end
					end
				end
			end

			--Spring.Echo("Replacing " .. ud.name .. " weapon " .. weaponID .. " (" .. weapon.name .. ") OnlyTargetCategory with:", targetCat.only, "BadTargetCategory with:", targetCat.bad)
			if only and not ud.weapons[weaponID].onlytargetcategory then -- don't overwrite if they exist
				ud.weapons[weaponID].onlytargetcategory = only
			end
			if bad and not ud.weapons[weaponID].badtargetcategory then -- don't overwrite
				ud.weapons[weaponID].badtargetcategory = bad
			elseif bad then -- append
				ud.weapons[weaponID].badtargetcategory = (ud.weapons[weaponID].badtargetcategory or "") .. " " .. bad
			end
		else
			Spring.Log('weapondefs_post', 'error', ud.name .. ' weapon number ' .. weaponID .. ' name ' .. weapon.name .. ' does not exist in the category cache -- it is probably invalid')
		end
	end
end

--------------------------------------------------------------------------------

local WeaponDefNames = {}
for weapName, weaponDef in pairs(WeaponDefs) do
	WeaponDefNames[weapName] = weaponDef
	if not categoryCache[weapName] then categoryCache[weapName] = {} end
	local cp = weaponDef.customparams
	if cp then
		if cp.cegflare then
			cegCache[weapName] = cp.cegflare
		end
		if cp.onlytargetcategory then
			categoryCache[weapName].only = cp.onlytargetcategory
		end
		if cp.badtargetcategory then
			categoryCache[weapName].bad = cp.badtargetcategory
		end
		if cp.weaponcost then
			weapCostCache[weapName] = cp.weaponcost
		end
		for k, v in pairs (cp) do
			if type(v) == "table" or type(v) == "boolean" then
				weaponDef.customparams[k] = table.serialize(v)
			end
		end
	end
	local soundTags = {"soundstart", "soundhit", "soundhitdry", "soundhitwet", "model"} -- TODO: model is a bit hacky here
	for _, tag in pairs(soundTags) do
		if weaponDef[tag] then
			weaponDef[tag] = "weapons/" .. weaponDef[tag]
		end
	end
	--------------------------------------------------------------------------------
	-- Damage Types
	--------------------------------------------------------------------------------
	if weaponDef.damage then
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
				Spring.Log('weapondefs post', 'error', "Invalid damagetype " .. damageType .. " for weapon " .. weaponDef.name)
			end
		end
	end

	for _, f in pairs(FUNCTIONS_TO_REMOVE) do
		weaponDef[f] = nil
	end
end

for unitName, ud in pairs(UnitDefs) do
	local weapons = ud.weapons
	if weapons then
		if not ud.sfxtypes then -- for now, don't override unitdefs
			ud.sfxtypes = { explosiongenerators = {} }
			-- TODO: think of something good to add as SFX.CEG (probably exhaust for most?)
			table.insert(ud.sfxtypes.explosiongenerators, 1, "custom:nothing")
			local weaponsWithAmmo = 0
			for weaponID = 1, #weapons do -- SFX.CEG + weaponID
				local weapName = string.lower(weapons[weaponID].name or 'NIL WEAPON NAME')
				if not WeaponDefNames[weapName] then
					Spring.Log('weapondefs_post', 'error', "non-existent weapon name (" .. ud.name .. ", " .. weapName .. ": weapon number: " .. weaponID ..")")
				else
					local cegFlare = cegCache[weapName]
					local weaponCost = (weapCostCache[weapName] or -2) * (WeaponDefNames[weapName].burst or 1)
					if cegFlare then
						table.insert(ud.sfxtypes.explosiongenerators, weaponID + 1, "custom:" .. cegFlare)
					end
					if weaponCost > -2 then -- some have a special case of -1
						weaponsWithAmmo = weaponsWithAmmo + 1
						local curCost = ud.customparams.weaponcost or weaponCost
						if curCost ~= weaponCost then
							Spring.Log('weapondefs_post', 'warning', "mismatch in weapon costs (" .. unitName .. ", " .. weapName .. " [" .. curCost .. " (current) vs. " .. weaponCost .. "(new)])")
						end
						ud.customparams.weaponcost = math.max(curCost, weaponCost)
					end
				end
			end
			ud.customparams.weaponswithammo = weaponsWithAmmo
		end
		CopyCategories(ud)
	end
end

-- FIXME: This is a bit icky; weapondefs_post sets unitdef customparam for weaponcost,
-- but arty tractors need to have this set by _post too - AFTER they have been set by the above loop
local morphDefs = VFS.Include("luarules/configs/morph_defs.lua")

for name, ud in pairs(UnitDefs) do
	local cp = ud.customparams
	-- Adding ammo to trucks
	if morphDefs[name] and not cp.weaponswithammo then
		local intoName = (morphDefs[name][1] or morphDefs[name]).into
		local intoCustomParams = UnitDefs[intoName].customparams
		if intoCustomParams and intoCustomParams.weaponswithammo then
			cp.weaponswithammo = 0
			cp.maxammo = intoCustomParams.maxammo
			cp.lowammolevel = intoCustomParams.lowammolevel
			cp.weaponcost = intoCustomParams.weaponcost
		end
	end
end

-- Add information about ammunition carrying capacity and usage to the description of units.
for name, ud in pairs(UnitDefs) do
	-- ammo users, add ammo-related description
	if (ud.customparams) then
		if (ud.customparams.weaponcost) and (ud.customparams.maxammo) then
			local newDescrLine = "max. ammo: "..ud.customparams.maxammo..", log. per shot: "..ud.customparams.weaponcost..", total: "..(ud.customparams.weaponcost*ud.customparams.maxammo)
			if not (ud.description) then
				ud.description = newDescrLine
			end
			ud.description = ud.description.." ("..newDescrLine..")"

		end
		if ud.customparams.armor_front and (tonumber(ud.maxvelocity) or 0) > 0 and not ud.customparams.infgun then
			ud.usepiececollisionvolumes = true
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Range Multiplier
--

	local baseMult = 0.6
		local totalWeapons
		totalWeapons = 0
		local rangeCoeff = baseMult * (modOptions.weapon_range_mult or 1)
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


		for name, weaponDef in pairs(WeaponDefs) do
			local customParams = weaponDef.customparams
			if customParams then --all weapons have the damageType customParam
		if not customParams.no_range_adjust then
			for tag, mult in pairs(mults) do
				if weaponDef[tag] then
					weaponDef[tag] = weaponDef[tag] * mult
				end
			end
		end


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
		--Spring.Echo("Done with the ranges, "..totalWeapons.." weapons processed.")

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
	 		if WeaponDefs[name].customparams then
				if (WeaponDefs[name].customparams.damagetype == 'smallarm') then
					for armorType,armorDamage in pairs (WeaponDefs[name].damage) do
						WeaponDefs[name].damage[armorType] = armorDamage * bulletCoeff
					end
				end
			end
		end
	end
end

-- set weapon velocities to arc at 45 degrees at max range
for weapName, weapDef in pairs(WeaponDefs) do
	if weapDef.gravityaffected then
		weapDef.mygravity = GRAVITY / 900 -- in maps it's in elmos/square second, in weapon it's in elmos/square simframe
	end
	if WeaponDefs[weapName].customparams then --for whatever reason, customparams needs to be lowercase here.
		if WeaponDefs[weapName].customparams.howitzer or WeaponDefs[weapName].customparams.damagetype == "grenade" then
			WeaponDefs[weapName].weaponvelocity = math.sqrt(WeaponDefs[weapName].range * GRAVITY) --Game.gravity)
		end
		-- add PARA onlytargetcategory to all weapons which use 'smallarm' damagetype customparam
		if WeaponDefs[weapName].customparams.damagetype == "smallarm" then
			for unitname, ud in pairs(UnitDefs) do
				if ud.weapons then
					for i in pairs(ud.weapons) do
						local unitWeapon = ud.weapons[i].name or "NIL WEAPON NAME"
						if string.lower(unitWeapon) == weapName then
							local targets = ud.weapons[i].onlytargetcategory
							if targets then
								ud.weapons[i].onlytargetcategory = targets .. " PARA"
							end
						end
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
