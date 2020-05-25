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
local OVERMATCH = 1.5 -- how much armour needs to be exceeded by to always pen
local BOUNCE_MIN_ANGLE = math.cos(math.rad(60)) -- 60 degrees or more
local BOUNCE_MULT = 0.2 -- how much velocity to keep after a richochet
local BOUNCE_TTL = 45 -- 1.5 seconds

--effective penetration = HE_MULT * sqrt(damage)
local HE_MULT = 1.45 --1.9/2.2

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

local vNormalized, vDotProduct

local sqrt = math.sqrt
local exp = math.exp
local log = math.log

local SQRT_HALF = sqrt(0.5)

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
	vNormalized = GG.Vector.Normalized
	vDotProduct = GG.Vector.DotProduct3
	local armorTypes = Game.armorTypes

	for i,  unitDef in pairs(UnitDefs) do
		local customParams = unitDef.customParams
		if customParams.armor_front then
			local armor_front = customParams.armor_front
			local armor_side = customParams.armor_side or armor_front
			local armor_rear = customParams.armor_rear or armor_side
			local armor_top = customParams.armor_top or armor_rear
			local slope_front = math.rad(customParams.slope_front or 0)
			local slope_side = math.rad(customParams.slope_side or 0)
			local slope_rear = math.rad(customParams.slope_rear or 0)
			
			unitInfos[i] = {
				armor_front, --forwardArmorTranslation(armor_front),
				armor_side, --forwardArmorTranslation(armor_side),
				armor_rear, --forwardArmorTranslation(armor_rear),
				armor_top, --forwardArmorTranslation(armor_top),
				armorTypes[unitDef.armorType],
				unitDef.armorType,
				slope_front,
				slope_side,
				slope_rear,
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
	elseif not projectileID then
		return damage
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
	
	local armor, slope
	
	local armor_hit_side = weaponInfo[3]
	
	local frontDir, upDir, rightDir = GetUnitVectors(unitID)
	local rearDir = {-frontDir[1], frontDir[2], -frontDir[3]}
	local leftDir = {-rightDir[1], rightDir[2], -rightDir[3]}
	
	local d --distance
	local hitVector, rotateFunc
	local rotateDir = 1
	local dotFront, dotUp
	local dx, dy, dz = Spring.GetProjectileDirection(projectileID)
	-- for some reason we need to flip the direction of all these for stuff to work :/
	if not dx then
		Spring.Echo("dx was nil?" dx, dy, dz, projectileID, weaponDef.name, UnitDefs[unitDefID].name)
		return 0
	end
	dx = -dx 
	dy = -dy
	dz = -dz
	
	if ownerPos[attackerID] then -- position when the projectile was _created_
		local ux, uy, uz = GetUnitPosition(unitID)
		local ax, ay, az = unpack(ownerPos[attackerID])
		local sx, sy, sz -- displacement vector
		sx, sy, sz = ax - ux, ay - uy, az - uz
		d = GG.Vector.Magnitude(sx, sy, sz)
		dotUp = vDotProduct(dx,dy,dz, upDir[1], upDir[2], upDir[3])
		dotFront = vDotProduct(dx,dy,dz, frontDir[1],frontDir[2],frontDir[3])
	else
		--finagle something for explosions with no projectile
		dotUp = 0
		dotFront = 1
		d = 500
	end
	
	--discrete arcs
	--splash hits don't use armor_hit_side
	if not armor_hit_side then
			--and (weaponInfo[1] ~= "explosive" or damage / weaponDef.damages[unitInfo[6]] > DIRECT_HIT_THRESHOLD) then
		if dotUp > SQRT_HALF or dotUp < -SQRT_HALF then
			armor_hit_side = "top"
		else
			if dotFront > SQRT_HALF then
				armor_hit_side = "front"
			elseif dotFront > -SQRT_HALF then
				armor_hit_side = "side"
			else
				armor_hit_side = "rear"
			end
		end
	end
	if armor_hit_side == "top" then 
		armor = unitInfo[4] -- top
		slope = 0
		hitVector = upDir
	elseif armor_hit_side == "rear" then
		armor = unitInfo[3]
		slope = unitInfo[9]
		hitVector = rearDir
		rotateFunc = GG.Vector.RotateX
	elseif armor_hit_side == "side" then
		armor = unitInfo[2]
		slope = unitInfo[8]
		rotateFunc = GG.Vector.RotateZ
		local dotRight = vDotProduct(dx,dy,dz, rightDir[1], rightDir[2], rightDir[3])
		if dotRight > 0 then
			hitVector = rightDir
			rotateDir = -1
		else
			hitVector = leftDir
		end
	else -- front
		armor = unitInfo[1]
		slope = unitInfo[7]
		hitVector = frontDir
		rotateFunc = GG.Vector.RotateX
		rotateDir = -1
	end

	local penetration
		if weaponInfo[1] == "explosive" then
		penetration = HE_MULT * sqrt(damage)
	else
		penetration = weaponInfo[1] * exp(d * weaponInfo[2])
	end
	
	if (not modOptions) or (modOptions and modOptions.sloped_armour == "1") then
		local fx,fy,fz = unpack(hitVector)
		if rotateFunc then
			fx,fy,fz = rotateFunc(hitVector[1], hitVector[2], hitVector[3], rotateDir * slope)
			fy = (slope > 0) and math.abs(fy) or -math.abs(fy)
		end

		local armorPre = armor -- just for debug echo
		armor = GG.Vector.EffectiveThickness(armor, dx,dy,dz, fx,fy,fz)
		local dotActual = vDotProduct(dx,dy,dz, fx,fy,fz)
		if (not modOptions) or (modOptions and modOptions.sloped_armour_debug == "1") then
			Spring.Echo(armor_hit_side .. " actual armour is " .. armorPre .. " @ " .. math.deg(slope) .. ". Effective armour is " .. armor .. " @ " .. math.deg(math.acos(dotActual)) .. " (Pen: " .. penetration .."mm)")
		end
		
		if OVERMATCH * penetration < armor then -- might bounce, check angle
			if dotActual < BOUNCE_MIN_ANGLE then
				local px,py,pz = Spring.GetProjectilePosition(projectileID)
				local vx, vy, vz = Spring.GetProjectileVelocity(projectileID)
				local v = BOUNCE_MULT * GG.Vector.Magnitude(vx, vy, vz)
				local params = {pos = {px,py,pz}, 
								speed = {v*(-dx+2*dotActual*fx), v*(-dy+2*dotActual*fy), v*(-dz+2*dotActual*fz)}, 
								ttl = BOUNCE_TTL,
								gravity = -0.25,
								owner = unitID}
				Spring.SpawnProjectile(weaponDefID, params)
			end
		end
	end
	-- apply damage
	armor = forwardArmorTranslation(armor)
	penetration = forwardArmorTranslation(penetration)
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
	--Spring.Log('armour gadget', 'info', "Base Hits: " .. baseHits)
	--Spring.Log('armour gadget', 'info', "Turret Hits: " .. turretHits)
	Spring.Echo("Base Hits: " .. baseHits)
	Spring.Echo("Turret Hits: " .. turretHits)
end
