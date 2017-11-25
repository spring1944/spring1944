function gadget:GetInfo()
	return {
		name      = "Spring 1944 Armor",
		desc      = "Calculates damage against armor.",
		author    = "Evil4Zerggin",
		date      = "11 July 2008",
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
armor_penetration: penetration of the weapon at point-blank (in mm)
ao_penetration_100m: penetration of the weapon at 100 m (in mm); you may use this instead of armor_penetration
armor_penetration_1000m: penetration of the weapon at 1000 m (in mm); default equal to penetration (i.e. no dropoff). Penetration drops off exponentially
armor_hit_side: forces the weapon to hit a certain side of the armor ("front", "side", "rear", or "top")

the damage actually dealt is proportional to the unmodified damage 
(the ap system multiplies the basic damage depending on penetration vs. armor)

]]

if (not gadgetHandler:IsSyncedCode()) then
	return false
end

----------------------------------------------------------------
--constants
----------------------------------------------------------------

--how quickly penetration and armor effectiveness increase with thickness
--higher = more quickly
--along with cost, controls how hard counters are; higher = harder counters
--recommend somewhere around 4-8?
local ARMOR_POWER = 8.75 --3.7

--effective penetration = HE_MULT * sqrt(damage)

local HE_MULT = 1.75 --1.9/2.2

local DIRECT_HIT_THRESHOLD = 0.98

local function forwardArmorTranslation(x)
	return x ^ ARMOR_POWER
end

local function inverseArmorTranslation(x)
	return x ^ (1 / ARMOR_POWER)
end

----------------------------------------------------------------
--locals
----------------------------------------------------------------

--format: unitDefID = { armor_front, armor_side, armor_rear, armor_top, armorTypeString, armorTypeNumber }
--armor values pre-exponentiated
local unitInfos = {}

--format: weaponDefID = { armor_penetration, armor_dropoff, armor_hit_side }
--armor_penetration is in mm
--armor_dropoff is in inverse elmos (exponential penetration decay)
local weaponInfos = {}

-- counters for piece hits
local turretHits = 0
local baseHits = 0

-- Remember where projectile owners were when they were spawned
local ownerPos = {}

----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitVectors = Spring.GetUnitVectors
local ValidUnitID = Spring.ValidUnitID

local vNormalized

local sqrt = math.sqrt
local exp = math.exp
local log = math.log

local SQRT_HALF = sqrt(0.5)

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
	vNormalized = GG.Vector.Normalized
	local armorTypes = Game.armorTypes

	for i,  unitDef in pairs(UnitDefs) do
		local customParams = unitDef.customParams
		if customParams.armor_front then
			local armor_front = customParams.armor_front
			local armor_side = customParams.armor_side or armor_front
			local armor_rear = customParams.armor_rear or armor_side
			local armor_top = customParams.armor_top or armor_rear
			
			unitInfos[i] = {
				forwardArmorTranslation(armor_front),
				forwardArmorTranslation(armor_side),
				forwardArmorTranslation(armor_rear),
				forwardArmorTranslation(armor_top),
				armorTypes[unitDef.armorType],
				unitDef.armorType,
			}
		end
	end
	
	for i, weaponDef in pairs(WeaponDefs) do
		local customParams = weaponDef.customParams
		if customParams.armor_penetration then
			local armor_penetration = customParams.armor_penetration
			local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration
			local armor_hit_side = customParams.armor_hit_side
			weaponInfos[i] = {
				armor_penetration,
				log(armor_penetration_1000m / armor_penetration) / 1000,
				armor_hit_side,
			}
		elseif customParams.armor_penetration_100m then
			local armor_penetration_100m = customParams.armor_penetration_100m
			local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration_100m
			local armor_hit_side = customParams.armor_hit_side
			local armor_penetration = (armor_penetration_100m / armor_penetration_1000m) ^ (1/9) * armor_penetration_100m
			weaponInfos[i] = {
				armor_penetration,
				log(armor_penetration_1000m / armor_penetration_100m) / 900,
				armor_hit_side,
			}
		elseif customParams.damagetype == "explosive" then
			local armor_hit_side = customParams.armor_hit_side
			weaponInfos[i] = {
				"explosive",
				0,
				armor_hit_side,
			}
		end
		if weaponInfos[i] then
			Script.SetWatchWeapon(i, true)
		end
	end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
 -- Limit impulse from crush damage; reduce crush damage
	if weaponDefID == -7 then 
			return damage * 0.1, 0.01 
	end
	-- check if damage was done by a weapon (not falling or debris)
	if not weaponDefID or weaponDefID < 0 or not ValidUnitID(unitID) then return damage end
	-- prevent flag damage
	if unitDefID == UnitDefNames["flag"].id then return 0 end
	-- prevent self damage
	if unitID == attackerID then return 0 end
	--  binocs and tracers do 0 damage to all units
	--if weaponDefID == WeaponDefNames["binocs"].id or WeaponDefs[weaponDefID].name:lower():find("tracer", 1, true) then return 0 end
	
	--binocs and tracers do zero damage already, so we don't need to be doing a string search...
	if damage <= 1 then return 0 end
	
	local unitInfo = unitInfos[unitDefID]
	local weaponInfo = weaponInfos[weaponDefID]
	local weaponDef = WeaponDefs[weaponDefID]
	
	-- smallarms do 0 damage to heavy armour
	if unitInfo and weaponDef.customParams.damagetype == "smallarm" then 
		-- 50cal damage to armoured vehicles
		if Game.armorTypes[UnitDefs[unitDefID].armorType] == "armouredvehicles" and weaponDef.interceptedByShieldType == 16 then 
			return damage
		end
		return 0
	end
		
	if not unitInfo or not weaponInfo or not weaponDef then return damage end
	--- count how many turret and base hits we get
	local pieceHit = Spring.GetUnitLastAttackedPiece(unitID)
	if pieceHit == "turret" then turretHits = turretHits + 1 else baseHits = baseHits + 1 end
	
	local armor
	
	local armor_hit_side = weaponInfo[3]
	
	local frontDir, upDir = GetUnitVectors(unitID)
	
	
	local d
	local dotFront, dotUp
	if ownerPos[attackerID] then
		local ux, uy, uz = GetUnitPosition(unitID)
		local ax, ay, az = unpack(ownerPos[attackerID])
		local dx, dy, dz = Spring.GetProjectileVelocity(projectileID)
		dx, dy, dz = ax - ux, ay - uy, az - uz
		dx, dy, dz, d = vNormalized(dx, dy, dz)
		dotUp = dx * upDir[1] + dy * upDir[2] + dz * upDir[3]
		dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
	else
		--finagle something for explosions with no projectile
		dotUp = 0
		dotFront = 1
		d = 500
	end
	
	--discrete arcs
	--splash hits don't use armor_hit_side
	if armor_hit_side 
			and (weaponInfo[1] ~= "explosive" or damage / weaponDef.damages[unitInfo[6]] > DIRECT_HIT_THRESHOLD) then
		if armor_hit_side == "top" then armor = unitInfo[4]
		elseif armor_hit_side == "rear" then armor = unitInfo[3]
		elseif armor_hit_side == "side" then armor = unitInfo[2]
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
	
	local penetration
	
	if weaponInfo[1] == "explosive" then
		penetration = forwardArmorTranslation(HE_MULT * sqrt(damage))
	else
		penetration = forwardArmorTranslation(weaponInfo[1] * exp(d * weaponInfo[2]))
	end
	
	local mult = penetration / (penetration + armor)
	
	return damage * mult
end

function gadget:ProjectileCreated(projID, ownerID, weaponID)
	if weaponInfos[weaponID] and ownerID then
		ownerPos[ownerID] = {GetUnitPosition(ownerID)}
	end
end

local function ForgetOwner(ownerID)
	ownerPos[ownerID] = nil
end

function gadget:Explosion(weaponID, px, py, pz, ownerID)
	if weaponInfos[weaponID] and ownerID then
		GG.Delay.DelayCall(ForgetOwner, {ownerID}, 1)
	end
end

function gadget:GameOver()
	Spring.Log('armour gadget', 'info', "Base Hits: " .. baseHits)
	Spring.Log('armour gadget', 'info', "Turret Hits: " .. turretHits)
end
