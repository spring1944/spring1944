function gadget:GetInfo()
  return {
    name      = "AP Damage",
    desc      = "Calculates AP damage.",
    author    = "Evil4Zerggin",
    date      = "26 May 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--[[
DOCUMENTATION

Units:

customParams:
	armor_front: front armor of the unit (in mm)
	armor_side: side armor
	armor_rear: rear armor
	armor_top: top armor

Each of these defaults to the previous if not explicitly given.

Weapon customParams:
ap_penetration: penetration of the weapon (in mm)
ap_dropoff: dropoff in penetration (in mm penetration loss per 1000 m traveled), default 0
ap_hit_side: forces the weapon to hit a certain side of the armor ("front", "side", "rear", or "top")

the damage actually dealt is proportional to the unmodified damage 
(the ap system multiplies the basic damage depending on penetration vs. armor)

Estimate the cost of a unit as proportional to sqrt(hp * dps * exp((armor + penetration) / ARMOR_BANDWIDTH / 2).

]]

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

----------------------------------------------------------------
--constants
----------------------------------------------------------------

local PENETRATION_BIAS = 0 --adds "free" penetration to all weapons

--how quickly penetration and armor effectiveness increase with thickness
--higher = less quickly
--along with cost, controls how hard counters are; higher = softer counters
--recommend somewhere around 15-25
local AP_BANDWIDTH = 20

--universal multiplier to AP damage, mostly for balance purposes
local DAMAGE_MULT = 2

----------------------------------------------------------------
--locals
----------------------------------------------------------------

--format: unitDefID = { armor_front, armor_side, armor_rear, armor_top }
--all pre-exponentiated
local unitInfos = {}

--format: weaponDefID = { ap_penetration, ap_dropoff, ap_hit_side }
--not pre-exponentiated, but bias is built-in
local weaponInfos = {}

----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitVectors = Spring.GetUnitVectors
local ValidUnitID = Spring.ValidUnitID

local vNormalized = GG.Vector.Normalized

local exp = math.exp

local SQRT_HALF = math.sqrt(0.5)

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
	for i = 1, #UnitDefs do
		local unitDef = UnitDefs[i]
		local customParams = unitDef.customParams
		if customParams.armor_front then
			local armor_front = customParams.armor_front
			local armor_side = customParams.armor_side or armor_front
			local armor_rear = customParams.armor_rear or armor_side
			local armor_top = customParams.armor_top or armor_rear
			unitInfos[i] = {
				exp(armor_front / AP_BANDWIDTH),
				exp(armor_side / AP_BANDWIDTH),
				exp(armor_rear / AP_BANDWIDTH),
				exp(armor_top / AP_BANDWIDTH),
			}
		end
	end
	
	for i = 1, #WeaponDefs do
		local weaponDef = WeaponDefs[i]
		local customParams = weaponDef.customParams
		if customParams.ap_penetration then
			local ap_penetration = customParams.ap_penetration
			local ap_dropoff = customParams.ap_dropoff or 0
			local ap_hit_side = customParams.ap_hit_side
			weaponInfos[i] = {
				ap_penetration + PENETRATION_BIAS,
				ap_dropoff * 0.001,
				ap_hit_side,
			}
		end
	end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
	if not weaponDefID or not ValidUnitID(unitID) or not ValidUnitID(attackerID) then return damage end
	
	local unitInfo = unitInfos[unitDefID]
	local weaponInfo = weaponInfos[weaponDefID]
	
	if not unitInfo or not weaponInfo then return damage end

	local armor
	
	local ap_hit_side = weaponInfo[3]
	
	local frontDir, upDir = GetUnitVectors(unitID)
	local ux, uy, uz = GetUnitPosition(unitID)
	local ax, ay, az = GetUnitPosition(attackerID)
	local dx, dy, dz, d
	local dotFront, dotUp
	
	dx, dy, dz = ax - ux, ay - uy, az - uz
	dx, dy, dz, d = vNormalized(dx, dy, dz)
	
	if ax and ux then
		dotUp = dx * upDir[1] + dy * upDir[2] + dz * upDir[3]
		dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
	else
		--finagle something
		dotFront = 1
		dotUp = 0
		d = 500
	end
	
	--discrete arcs
	if ap_hit_side then
		if ap_hit_side == "top" then armor = unitInfo[4]
		elseif ap_hit_side == "rear" then armor = unitInfo[3]
		elseif ap_hit_side == "side" then armor = unitInfo[2]
		else armor = unitInfo[1]
		end
	else
		if dotUp > SQRT_HALF or dotUp < -SQRT_HALF then
			armor = unitInfo[4]
		else
			if dotFront > SQRT_HALF then
				armor = unitInfo[1]
			elseif dotFront > -SQRT_HALF then
				armor = unitInfo[2]
			else
				armor = unitInfo[3]
			end
		end
	end
	
	local penetration = weaponInfo[1] - d * weaponInfo[2]
	penetration = exp(penetration / AP_BANDWIDTH)
	
	local apDamage = damage * penetration / (penetration + armor) * DAMAGE_MULT
	
	return apDamage
	
end
