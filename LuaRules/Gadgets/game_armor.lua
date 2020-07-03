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
	armour[piece][side] = {thickness = valueInMm, slope = valueInDegrees}

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

local PIECES = {["base"] = true, ["super"] = true, ["turret"] = true}

--effective penetration = HE_MULT * sqrt(damage)
local HE_MULT = 1.9 --1.45 --1.9 --2.2

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

--armor values pre-exponentiated
local unitInfos = {}

--format: weaponDefID = { armor_penetration, armor_dropoff, armor_hit_side }
--armor_penetration is in mm
--armor_dropoff is in inverse elmos (exponential penetration decay)
local weaponInfos = {}

-- counters for piece hits
local hitCounts = {} -- ["base"] = number, etc
local hits = {} -- unitdefID = {base, turret, super}
local bounces = {} -- unitDefID = {base, turret, super}

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

	for unitDefID,  unitDef in pairs(UnitDefs) do
		local customParams = unitDef.customParams
		if customParams.armour then
			unitInfos[unitDefID] = {
				["armour"] = table.unserialize(customParams.armour),
				lwRatios = {},
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
	GG.lusHelper.unitInfos = unitInfos
	GG.lusHelper.weaponInfos = weaponInfos
	-- Fake UnitCreated events for existing units. (for '/luarules reload')
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	-- TODO: remove the check for .armour once everything uses the table
	if unitInfos[unitDefID] and unitInfos[unitDefID].armour and not unitInfos[unitDefID].lwRatios["base"] then
		local pieceMap = Spring.GetUnitPieceMap(unitID)
		unitInfos[unitDefID]["pieceMap"] = pieceMap
		for piece in pairs(PIECES) do
			local pieceNum = pieceMap[piece]
			if pieceNum then -- Only 1 of turret or super should exist
				local x,y,z = Spring.GetUnitPieceCollisionVolumeData(unitID, pieceNum)
				unitInfos[unitDefID].lwRatios[piece] = math.cos(math.atan(x/z))
			end
		end
	end
end

local function ResolveDamage(targetID, targetDefID, pieceHit, projectileID, weaponDefID, damage, ax, ay, az)
	--Spring.Echo("ResolveDamage", targetID, targetDefID, pieceHit, projectileID, weaponDefID, damage, ax, ay, az)
	local unitInfo = unitInfos[targetDefID]
	local weaponInfo = weaponInfos[weaponDefID]
	local weaponDef = WeaponDefs[weaponDefID]
	
	-- If the hit unit wasn't armoured, we're done
	if not unitInfo or not unitInfo.armour or not weaponInfo or not weaponDef then return damage end	
	
	-- smallarms do 0 damage to heavy armour
	if unitInfo and weaponDef.customParams.damagetype == "smallarm" then 
		-- 50cal damage to armoured vehicles
		if Game.armorTypes[UnitDefs[targetDefID].armorType] == "armouredvehicles" and weaponDef.interceptedByShieldType == 16 then 
			return damage
		end
		return 0
	end
	
	-- If we got this far, we ARE doing armour calculations	
	local armor, slope
	local armor_hit_side = weaponInfo[3]
	
	local frontDir, upDir, rightDir = GetUnitVectors(targetID)
	
	
	if pieceHit == "turret" then
		local pieceNum = unitInfos[targetDefID]["pieceMap"]["turret"]
		local matrix = {Spring.GetUnitPieceMatrix(targetID, pieceNum)}
		--GG.Vector.PrintMatrix(matrix)
		--Spring.Echo("Old vector", unpack(frontDir))
		frontDir = {GG.Vector.MultMatrix3(matrix, unpack(frontDir))}
		--Spring.Echo("New vector", unpack(frontDir))
		rightDir = {GG.Vector.MultMatrix3(matrix, unpack(rightDir))}
	end
	local rearDir = {-frontDir[1], -frontDir[2], -frontDir[3]}
	local leftDir = {-rightDir[1], -rightDir[2], -rightDir[3]}
	
	local d --distance
	local hitVector
	local dotFront, dotUp
	local dx, dy, dz 
	if projectileID and projectileID > 0 then -- a hit by an actual projectile (not explosion or TargetWeight trial)
		-- count how many turret and base hits we get
		if not hits[targetDefID] then hits[targetDefID] = {} end
		hits[targetDefID][pieceHit] = (hits[targetDefID][pieceHit] or 0) + 1
		hitCounts[pieceHit] = (hitCounts[pieceHit] or 0) + 1
		dx, dy, dz = Spring.GetProjectileDirection(projectileID)
		-- for some reason we need to flip the direction of all these for stuff to work :/
		dx = -dx 
		dy = -dy
		dz = -dz
	end
	
	local ux, uy, uz
	if ax then -- position when the projectile was _created_
		ux, uy, uz = Spring.GetUnitPiecePosDir(targetID, pieceHit and unitInfo[pieceHit] or 1)--GetUnitPosition(unitID)
		local sx, sy, sz -- displacement vector
		sx, sy, sz = ax - ux, ay - uy, az - uz
		d = GG.Vector.Magnitude(sx, sy, sz)
		if not dx then -- if we don't have a projectile, estimate based on the displacement vector
			dx, dy, dz = GG.Vector.Normalized(sx, sy, sz)
		end
		dotUp = vDotProduct(dx,dy,dz, upDir[1], upDir[2], upDir[3])
		dotFront = vDotProduct(dx,dy,dz, frontDir[1],frontDir[2],frontDir[3])
	else
		--finagle something for explosions with no projectile
		dotUp = 0
		dotFront = 1
		d = 500
	end
	
	local cosLW = unitInfo.lwRatios[pieceHit]
	--discrete arcs
	--splash hits don't use armor_hit_side
	if not armor_hit_side then
			--and (weaponInfo[1] ~= "explosive" or damage / weaponDef.damages[unitInfo[6]] > DIRECT_HIT_THRESHOLD) then
		if not (dotFront or cosLW) then Spring.Echo("game_armor error 1:", dotFront, cosLW, pieceHit, UnitDefs[targetDefID].name) end
		if dotUp > SQRT_HALF or dotUp < -SQRT_HALF then
			armor_hit_side = "top"
		else
			if dotFront > cosLW then
				armor_hit_side = "front"
			elseif dotFront > -cosLW then
				armor_hit_side = "side"
			else
				armor_hit_side = "rear"
			end
		end
	end
	if not pieceHit or not unitInfo.armour[pieceHit] or not unitInfo.armour[pieceHit][armor_hit_side] then
		Spring.Echo("291 check", armor_hit_side, pieceHit, unitInfo, unitInfo.armour, UnitDefs[targetDefID].name)
	end
	armor = (armor_hit_side and pieceHit and unitInfo.armour[pieceHit][armor_hit_side].thickness) or 0
	slope = (armor_hit_side and pieceHit and unitInfo.armour[pieceHit][armor_hit_side].slope) or 0
	if armor_hit_side == "top" then 
		hitVector = upDir
	elseif armor_hit_side == "rear" then
		hitVector = rearDir
	elseif armor_hit_side == "side" then
		local dotRight = vDotProduct(dx,dy,dz, rightDir[1], rightDir[2], rightDir[3])
		if dotRight > 0 then
			hitVector = rightDir
		else
			hitVector = leftDir
		end
	else -- front
		hitVector = frontDir
	end

	local penetration
		if weaponInfo[1] == "explosive" then
		penetration = HE_MULT * sqrt(damage)
	else
		penetration = weaponInfo[1] * exp(d * weaponInfo[2])
	end
	
	if (not modOptions) or (modOptions and modOptions.sloped_armour == "1") then
		local fx,fy,fz = unpack(hitVector)
		--Spring.Echo("Original vector (" .. fx,fy,fz ..") Mag: " .. GG.Vector.Magnitude(fx,fy,fz))
		fx,fy,fz = GG.Vector.Elevate(hitVector[1],hitVector[2],hitVector[3], upDir[1],upDir[2],upDir[3], math.rad(slope))
		--Spring.Echo("Rotated vector (" .. fx,fy,fz ..") Mag: " .. GG.Vector.Magnitude(fx,fy,fz))

		local armorPre = armor -- just for debug echo
		if dx then -- we can end up here if there was no projectile?
			armor = GG.Vector.EffectiveThickness(armor, dx,dy,dz, fx,fy,fz)
			local dotActual = vDotProduct(dx,dy,dz, fx,fy,fz)
			if false then--(not modOptions) or (modOptions and modOptions.sloped_armour_debug == "1") then
				Spring.Echo(pieceHit .. " (" .. armor_hit_side .. ") actual armour is " .. armorPre .. "mm @ " .. slope .. "°" ..
							". Effective armour is " .. string.format("%3d",armor) .. "mm @ " .. string.format("%3d",math.deg(math.acos(dotActual))) .. "°" ..
							" (Pen: " .. string.format("%3d",penetration) .."mm)")
			end
		
			if OVERMATCH * penetration < armor then -- might bounce, check angle
				if dotActual < BOUNCE_MIN_ANGLE then
					if projectileID then -- go ahead with the bounce if the projectile actually exists and this isn't a TargetWeight check
						local px,py,pz = Spring.GetProjectilePosition(projectileID)
						local vx, vy, vz = Spring.GetProjectileVelocity(projectileID)
						if vx then -- somehow, in very rare circumstances, it can be nil
							local v = BOUNCE_MULT * GG.Vector.Magnitude(vx, vy, vz)
							local params = {pos = {px,py,pz}, 
											speed = {v*(-dx+2*dotActual*fx), v*(-dy+2*dotActual*fy), v*(-dz+2*dotActual*fz)}, 
											--speed = {fx, fy, fz}, -- for testing vectors
											ttl = BOUNCE_TTL,
											gravity = -0.25,
											owner = targetID}
							Spring.SpawnProjectile(weaponDefID, params)
							if not bounces[targetDefID] then bounces[targetDefID] = {} end
							bounces[targetDefID][pieceHit] = (bounces[targetDefID][pieceHit] or 0) + 1
						end
					end
					return 0 -- bounced shots do no damage
				end
			end
		end
	end
	-- apply damage
	armor = forwardArmorTranslation(armor)
	penetration = forwardArmorTranslation(penetration)
	local mult = penetration / (penetration + armor)
	
	return damage * mult
end
GG.ResolveDamage = ResolveDamage

local function ForgetOwner(ownerID, projectileID)
	ownerPos[ownerID][projectileID] = nil
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
	
	-- If we got this far, we might be doing armour calculations	
	local pieceHit = Spring.GetUnitLastAttackedPiece(unitID) or "base"
	local ax, ay, az 
	if ownerPos[attackerID] and ownerPos[attackerID][projectileID] then 
		ax, ay, az = unpack(ownerPos[attackerID][projectileID])
		GG.Delay.DelayCall(ForgetOwner, {attackerID, projectileID}, 1) -- need to clear these as ID's are recycled
	end
	return ResolveDamage(unitID, unitDefID, pieceHit, projectileID, weaponDefID, damage, ax, ay, az)
end

function gadget:ProjectileCreated(projectileID, ownerID, weaponID)
	if weaponInfos[weaponID] and ownerID then
		local pieceMap = Spring.GetUnitPieceMap(ownerID)
		local piece = pieceMap["flare_1"] or pieceMap["flare"] or pieceMap["base"]
		local x,y,z = Spring.GetUnitPiecePosDir(ownerID, piece)
		if not ownerPos[ownerID] then ownerPos[ownerID] = {} end
		ownerPos[ownerID][projectileID] = {x,y,z}
	end
end

function gadget:GameOver()
	--Spring.Echo("GameOver was actually called for once!")
	for piece, count in pairs(hitCounts) do
		Spring.Echo(piece .. " hits: " .. count)
	end
	for unitDefID, hitTable in pairs(hits) do
		Spring.Echo(UnitDefs[unitDefID].name, "was hit")
		for piece, times in pairs(hitTable) do
			if bounces[unitDefID] and bounces[unitDefID][piece] then
				Spring.Echo(piece, times, "(bounced)", bounces[unitDefID][piece])
			else
				Spring.Echo(piece, times)
			end
		end
	end
end

--function gadget:UnitDestroyed()
function gadget:TeamDied()
	Spring.Echo("TeamDied")
	gadget:GameOver()
end