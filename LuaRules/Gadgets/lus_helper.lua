function gadget:GetInfo()
	return {
		name = "LUS Helper",
		desc = "Parses UnitDef and Model data for LUS",
		author = "FLOZi (C. Lawrence)",
		date = "20/02/2011", -- 25 today ;_;
		license = "GNU GPL v2",
		layer = -1,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then
--SYNCED

-- Localisations
GG.lusHelper = {}
local sqrt = math.sqrt
local random = math.random
-- Synced Read
local GetUnitPieceInfo 		= Spring.GetUnitPieceInfo
local GetUnitPieceMap		= Spring.GetUnitPieceMap
local GetUnitPiecePosDir	= Spring.GetUnitPiecePosDir
local GetUnitPosition		= Spring.GetUnitPosition
local GetUnitWeaponTarget	= Spring.GetUnitWeaponTarget
local GetUnitRulesParam		= Spring.GetUnitRulesParam
local GetCommandQueue		= Spring.GetCommandQueue
-- Synced Ctrl
local PlaySoundFile			= Spring.PlaySoundFile
local SpawnCEG				= Spring.SpawnCEG
local SetUnitWeaponState	= Spring.SetUnitWeaponState
local SetGroundMoveTypeData	= Spring.MoveCtrl.SetGroundMoveTypeData
local GiveOrderToUnit		= Spring.GiveOrderToUnit
local SetUnitRulesParam		= Spring.SetUnitRulesParam
-- LUS
local CallAsUnit 			= Spring.UnitScript.CallAsUnit	

-- Unsynced Ctrl
-- Constants
local RANGE_INACCURACY_PERCENT = 5
-- Variables

-- Useful functions for GG

function GG.RemoveGrassSquare(x, z, r)
	local startX = math.floor(x - r/2)
	local startZ = math.floor(z - r/2)
	for i = 0, r, Game.squareSize * 4 do
		for j = 0, r, Game.squareSize * 4 do
			Spring.RemoveGrass((startX + i)/Game.squareSize, (startZ + j)/Game.squareSize)
		end
	end
end

function GG.RemoveGrassCircle(cx, cz, r)
	local r2 = r * r
	for z = 0, 2 * r, Game.squareSize * 4 do -- top to bottom diameter
		local lineLength = sqrt(r2 - (r - z) ^ 2)
		for x = -lineLength, lineLength, Game.squareSize * 4 do
			Spring.RemoveGrass((cx + x)/Game.squareSize, (cz + z - r)/Game.squareSize)
		end
	end
end

function GG.SpawnDecal(decalType, x, y, z, teamID, delay, duration)
	if delay then
		GG.Delay.DelayCall(SpawnDecal, {decalType, x, y, z, teamID, nil, duration}, delay)
	else
		local decalID = Spring.CreateUnit(decalType, x, y + 1, z, 0, Spring.GetGaiaTeamID(), false, false)
		Spring.SetUnitAlwaysVisible(decalID, teamID == nil and true)
		Spring.SetUnitNoSelect(decalID, true)
		Spring.SetUnitBlocking(decalID, false, false, false, false, false, false, false)
		if duration then
			GG.Delay.DelayCall(Spring.DestroyUnit, {decalID, false, true}, duration)
		end
	end
end

function GG.EmitSfxName(unitID, pieceNum, effectName) -- currently unused
	local px, py, pz, dx, dy, dz = GetUnitPiecePosDir(unitID, pieceNum)
	dx, dy, dz = GG.Vector.Normalized(dx, dy, dz)
	SpawnCEG(effectName, px, py, pz, dx, dy, dz)
end



function GG.LimitRange(unitID, weaponNum, defaultRange)
	local targetType, _, targetID = GetUnitWeaponTarget(unitID, weaponNum)
	if targetType == 1 then -- it's a unit
		local tx, ty, tz = GetUnitPosition(targetID)
		local ux, uy, uz = GetUnitPosition(unitID)
		local distance = sqrt((tx - ux)^2 + (ty - uy)^2 + (tz - uz)^2)
		local distanceMult = 1 + (random(-RANGE_INACCURACY_PERCENT, RANGE_INACCURACY_PERCENT) / 100)
		SetUnitWeaponState(unitID, weaponNum, "range", distanceMult * distance)
	end
	SetUnitWeaponState(unitID, weaponNum, "range", defaultRange)
end


function GG.RecursiveHide(unitID, pieceNum, hide)
	-- Hide this piece
	local func = (hide and Spring.UnitScript.Hide) or Spring.UnitScript.Show
	CallAsUnit(unitID, func, pieceNum)
	-- Recursively hide children
	local pieceMap = GetUnitPieceMap(unitID)
	local children = GetUnitPieceInfo(unitID, pieceNum).children
	if children then
		for _, pieceName in pairs(children) do
			GG.RecursiveHide(unitID, pieceMap[pieceName], hide)
		end
	end
end

function GG.UnitSay(unitID, sound)
	local velx, vely, velz = Spring.GetUnitVelocity(unitID)
	GG.PlaySoundAtUnit(unitID, sound, 1, velx, vely, velz, 'voice')
end

function GG.PlaySoundAtUnit(unitID, sound, volume, sx, sy, sz, channel)
	local x,y,z = GetUnitPosition(unitID)
	volume = volume or 5
	channel = channel or "sfx"
	PlaySoundFile(sound, volume, x, y, z, sx, sy, sz, channel)
end

local unsyncedBuffer = {}
function GG.PlaySoundForTeam(teamID, sound, volume)
	table.insert(unsyncedBuffer, {teamID, sound, volume})
end

function gadget:GameFrame(n)
	for _, callInfo in pairs(unsyncedBuffer) do
		SendToUnsynced("SOUND", callInfo[1], callInfo[2], callInfo[3])
	end
	unsyncedBuffer = {}
end

function GG.GetUnitDistanceToPoint(unitID, tx, ty, tz, bool3D)
	local x,y,z = GetUnitPosition(unitID)
	local dy = (bool3D and ty and (ty - y)^2) or 0
	local distanceSquared = (tx - x)^2 + (tz - z)^2 + dy
	return sqrt(distanceSquared)
end

-- Include table utilities
VFS.Include("LuaRules/Includes/utilities.lua", nil, VFS.ZIP)

local udCache = {}

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	-- Pass unitID to constructor
	env = Spring.UnitScript.GetScriptEnv(builderID)
	if env and env.build then
		Spring.UnitScript.CallAsUnit(builderID, env.build, unitID, unitDefID)
	end
	local info = GG.lusHelper[unitDefID]
	local cp = UnitDefs[unitDefID].customParams
	if not udCache[unitDefID] then
		udCache[unitDefID] = true
		-- Parse Model Data
		local pieceMap = GetUnitPieceMap(unitID)
		local numRockets = 0
		local numBarrels = 0
		for pieceName, pieceNum in pairs(pieceMap) do
			--[[local weapNumPos = pieceName:find("_") or 0
			local weapNumEndPos = pieceName:find("_", weapNumPos+1) or 0
			local weaponNum = tonumber(pieceName:sub(weapNumPos+1,weapNumEndPos-1))]]
			if pieceName:find("rocket") then
				numRockets = numRockets + 1
			-- Find barrel pieces
			elseif pieceName:find("barrel") then
				--barrelIDs[weaponNum] = true
				numBarrels = numBarrels + 1
			end
		end
		info.numBarrels = numBarrels
		info.numRockets = numRockets
	end
	
	-- Remove aircraft land and repairlevel buttons
	if UnitDefs[unitDefID].canFly then
		GiveOrderToUnit(unitID, CMD.IDLEMODE, {0}, {})
		local toRemove = {CMD.IDLEMODE, CMD.AUTOREPAIRLEVEL}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	end
end

-- Weapon and Armor related stuff which is needed for TargetWeight on LUS side
-- this should not really be there as it is in game_armor already, proper code re-use to be done later

local sqrt = math.sqrt
local exp = math.exp
local log = math.log

local GetUnitDefID = Spring.GetUnitDefID
local min = math.min
local vMagnitude = GG.Vector.Magnitude
local vNormalized = GG.Vector.Normalized
local SQRT_HALF = sqrt(0.5)

--format: unitDefID = { armor_front, armor_side, armor_rear, armor_top, armorTypeString, armorTypeNumber }
--armor values pre-exponentiated
local unitInfos = {}

--format: weaponDefID = { armor_penetration, armor_dropoff, armor_hit_side }
--armor_penetration is in mm
--armor_dropoff is in inverse elmos (exponential penetration decay)
local weaponInfos = {}

local ARMOR_POWER = 8.75 --3.7

--effective penetration = HE_MULT * sqrt(damage)

local HE_MULT = 3.15 --1.9/2.2

local DIRECT_HIT_THRESHOLD = 0.98

local function forwardArmorTranslation(x)
	return x ^ ARMOR_POWER
end

function WeaponDataPreload()
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
		local penetration
		local dropoff
		local range = weaponDef.range
		local damages = weaponDef.damages
		local armorHitSide = customParams.armor_hit_side
		if (customParams.damagetype ~= "grenade") then
			if (customParams.damagetype == "shapedcharge") then 
				local armor_penetration = customParams.armor_penetration
				penetration = tonumber(armor_penetration)
				dropoff = 0
			elseif (customParams.damagetype == "explosive") then
				penetration = 0
				dropoff = 0
			else
				if (tonumber(customParams.armor_penetration) or 0) > (penetration or 0) then
					local armor_penetration = customParams.armor_penetration
					local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration
					penetration = tonumber(armor_penetration)
					dropoff = log(armor_penetration_1000m / armor_penetration) / 1000
				elseif (tonumber(customParams.armor_penetration_100m) or 0) > (penetration or 0) then
					local armor_penetration_100m = customParams.armor_penetration_100m
					local armor_penetration_1000m = customParams.armor_penetration_1000m or armor_penetration_100m
					penetration = (armor_penetration_100m / armor_penetration_1000m) ^ (1/9) * armor_penetration_100m
					dropoff = log(armor_penetration_1000m / armor_penetration_100m) / 900
				end
			end
		end
		if penetration then
			weaponInfos[i] = {penetration, dropoff, range, damages, armorHitSide}
		end
	end

	GG.lusHelper.weaponInfos = weaponInfos
	GG.lusHelper.unitInfos = unitInfos
end

local function standardTargetWeight(unitID, unitDefID, weaponNum, targetUnitID)
	local resultWeight = 1
	-- get our position, get target position. Find out distance and target side we're going to hit
	local targetDefID = GetUnitDefID(targetUnitID)
	if targetDefID then
		local myWeapons = UnitDefs[unitDefID].weapons
		local thisWeapon = myWeapons[weaponNum]
		local targetInfo = GG.lusHelper.unitInfos[targetDefID]
		local weaponID = thisWeapon.weaponDef
		local weaponInfo = GG.lusHelper.weaponInfos[weaponID]
		if weaponInfo and targetInfo then
			local ux, uy, uz = GetUnitPosition(targetUnitID)
			local wx, wy, wz = GetUnitPosition(unitID)
			local distance = vMagnitude(ux - wx, uy - wy, uz - wz)
			local targetHealth, maxTargetHealth = Spring.GetUnitHealth(targetUnitID)
			local front, side, rear, top, armorTypeName, armorType = unpack(targetInfo)
			local penetration, dropoff, range, damages, armorHitSide = unpack(weaponInfo)
			local isHE = (penetration == 0)
			distance = min(distance, range)
			local baseDamage = damages[armorType]
			local damage = baseDamage
			if isHE then
				penetration = HE_MULT * sqrt(baseDamage)
			elseif dropoff ~= 0 then
				penetration = penetration * exp(dropoff * distance)
			end
			penetration = forwardArmorTranslation(penetration)
			--baseDamage = (baseDamage / health) * 100
			--local numerator = baseDamage * penetration
			
			-- TBD: find out hit direction and then get the one damage we really need out of this
			local dx, dy, dz, d = vNormalized(wx - ux, wy - uy, wz - uz)
			local frontDir, upDir = Spring.GetUnitVectors(unitID)
			local dotUp = dx * upDir[1] + dy * upDir[2] + dz * upDir[3]
			local dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]

			local armor = 0
			
			if armorHitSide 
					and (not isHE or damage / damages[armorType] > GG.lusHelper.DIRECT_HIT_THRESHOLD) then
				if armorHitSide == "top" then armor = top
				elseif armorHitSide == "rear" then armor = rear
				elseif armorHitSide == "side" then armor = side
				else armor = front
				end
			else
				if dotUp > SQRT_HALF or dotUp < -SQRT_HALF then
					armor = top
				else
					if dotFront > SQRT_HALF then
						armor = front
					elseif dotFront > -SQRT_HALF then
						armor = side
					else
						armor = rear
					end
				end
			end
			
			local mult = penetration / (penetration + armor)
			
			if isHE and armorTypeName == "armouredvehicles" then
				mult = mult + 1
			end
			
			-- if we can't 1-shot a target then go for max damage%
			-- if we can 1-shot then go for the one with max HP remaining. Adding 1 to result so these are always higher weight than the ones above
			local effectiveDamage = damage * mult
			if targetHealth > effectiveDamage then
				resultWeight = effectiveDamage / targetHealth
			else
				resultWeight = 1 + targetHealth / effectiveDamage
			end
		else
			-- target is not armored?
		end
	end
	-- Looks like TargerWeight is less = better on the engine side.
	if resultWeight ~= 0 then
		resultWeight = 1 / resultWeight
	else
		-- very low priority
		resultWeight = 1000
	end
	return resultWeight
end

GG.lusHelper.standardTargetWeight = standardTargetWeight
-- end of weapon and armor stuff

-- Movement speed changes
function GG.ApplySpeedChanges(unitID)
	-- no need to attempt this
	if GetUnitRulesParam(unitID, 'movectrl') == 1 then
		return
	end

	local unitDefID = GetUnitDefID(unitID)
	local UnitDef = UnitDefs[unitDefID]
	local origSpeed = UnitDef.speed
	local origReverseSpeed = Spring.GetUnitMoveTypeData(unitID).maxReverseSpeed

	local newSpeed = origSpeed
	local newReverseSpeed = origReverseSpeed
	local currentSpeed = GetUnitRulesParam(unitID, "current_speed") or origSpeed
	
	local fearMult = GetUnitRulesParam(unitID, "fear_movement") or 1.0
	local deployedMult = GetUnitRulesParam(unitID, "deployed_movement") or 1.0
	local amphibMult = GetUnitRulesParam(unitID, "amphib_movement") or 1.0

	local immobilized = false
	local immobilizedMult = 1.0
	if (GetUnitRulesParam(unitID, "immobilized") or 0) > 0 then
		immobilized = true
		immobilizedMult = 0
	end

	newSpeed = newSpeed * fearMult * deployedMult * amphibMult * immobilizedMult
	newReverseSpeed = newReverseSpeed * fearMult * deployedMult * amphibMult * immobilizedMult

	--Spring.Echo('fearMult ' .. fearMult .. ' deployedMult ' .. deployedMult .. ' amphibMult ' .. amphibMult .. ' newSpeed ' .. newSpeed .. ' origSpeed ' .. origSpeed)

	-- only deployed mult overrides turn rates so far
	if deployedMult == 1.0 and not immobilized then
		SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed, maxReverseSpeed = newReverseSpeed, turnRate = UnitDef.turnRate, accRate = UnitDef.maxAcc})
	else
		SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed, maxReverseSpeed = origReverseSpeed, turnRate = 0.001, accRate = 0})
	end

	if currentSpeed ~= newSpeed then
		local cmds = GetCommandQueue(unitID, 2)
		--if #cmds >= 2 then
		if #cmds >= 1 then
			if cmds[1].id == CMD.MOVE or cmds[1].id == CMD.FIGHT or cmds[1].id == CMD.ATTACK then
				if cmds[2] and cmds[2].id == CMD.SET_WANTED_MAX_SPEED then
					GiveOrderToUnit(unitID,CMD.REMOVE,{cmds[2].tag},{})
				end
				local params = {1, CMD.SET_WANTED_MAX_SPEED or cmds[1].id, 0, newSpeed}
				SetGroundMoveTypeData(unitID, {maxSpeed = newSpeed, maxReverseSpeed = newReverseSpeed})
				GiveOrderToUnit(unitID, CMD.INSERT, params, {"alt"})
			end
		end
		SetUnitRulesParam(unitID, "current_speed", newSpeed)
	end
end

function gadget:GamePreload()
	-- Parse UnitDef Data
	for unitDefID, unitDef in pairs(UnitDefs) do
		local info = {}
		local cp = unitDef.customParams
		local weapons = unitDef.weapons
		
		-- Parse UnitDef Weapon Data
		local missileWeaponIDs = {}
		local paratroopWeaponIDs = {}
		local burstLengths = {}
		local burstRates = {}
		local reloadTimes = {}
		local minRanges = {}
		local explodeRanges = {}
		local flareOnShots = {}
		local weaponAnimations = {}
		local weaponCEGs = {}
		local seismicPings = {}
		for i = 1, #weapons do
			local weaponInfo = weapons[i]
			local weaponDef = WeaponDefs[weaponInfo.weaponDef]
			if not weaponDef.type:find("Shield") then
				reloadTimes[i] = weaponDef.reload
				burstLengths[i] = weaponDef.salvoSize
				burstRates[i] = weaponDef.salvoDelay
				minRanges[i] = tonumber(weaponDef.customParams.minrange) -- intentionally nil otherwise
				if weaponDef.selfExplode then
					explodeRanges[i] = weaponDef.range
				end
				if weaponDef.type == "MissileLauncher" then
					missileWeaponIDs[i] = true
				end
				weaponAnimations[i] = weaponDef.customParams.scriptanimation
				flareOnShots[i] = tobool(weaponDef.customParams.flareonshot)
				weaponCEGs[i] = weaponDef.customParams.cegflare
				seismicPings[i] = weaponDef.customParams.seismicping
				if weaponDef.customParams.paratrooper then
					paratroopWeaponIDs[i] = true
				end
			end
		end
		-- WeaponDef Level Info
		info.missileWeaponIDs = missileWeaponIDs
		info.flareOnShots = flareOnShots
		info.reloadTimes = reloadTimes
		info.burstLengths = burstLengths
		info.burstRates = burstRates
		info.minRanges = minRanges
		info.explodeRanges = explodeRanges
		info.weaponAnimations = weaponAnimations
		info.weaponCEGs = weaponCEGs
		info.seismicPings = seismicPings
		info.paratroopWeaponIDs = paratroopWeaponIDs
		-- UnitDef Level Info
		local corpse = FeatureDefNames[unitDef.wreckName:lower()]
		info.numCorpses = 0
		if corpse then
			corpse = corpse.id
			while FeatureDefs[corpse] do
				info.numCorpses = info.numCorpses + 1
				local corpseDef = FeatureDefs[corpse]
				corpse = corpseDef.deathFeatureID
			end
		end
		
		info.facing = cp.facing or 0 -- default to front
		info.turretTurnSpeed = math.rad(tonumber(cp.turretturnspeed) or 24)
		info.elevationSpeed = math.rad(tonumber(cp.elevationspeed) or 30)
		info.barrelRecoilSpeed = (tonumber(cp.barrelrecoilspeed) or 10)
		info.barrelRecoilDist = (tonumber(cp.barrelrecoildist) or 5)
		info.aaWeapon = (tonumber(cp.aaweapon) or nil)
		-- info.wheelSpeed = math.rad(tonumber(cp.wheelspeed) or 100)
		-- info.wheelAccel = math.rad(tonumber(cp.wheelaccel) or info.wheelSpeed * 2)
		-- General
		info.numWeapons = #weapons
		info.weaponsWithAmmo = tonumber(cp.weaponswithammo) or 0
		info.usesAmmo = (tonumber(cp.maxammo) or 0) > 0
		info.mainAnimation = cp.scriptanimation
		info.deathAnim = table.unserialize(cp.deathanim) or {}
		info.axes = {["x"] = 1, ["y"] = 2, ["z"] = 3}
		info.fearLimit = (tonumber(cp.fearlimit) or nil)

		info.planeVoice = table.unserialize(cp.planevoice) or {}
		

		-- deploy anims
		if cp.customanims then
			info.customAnimsName = cp.customanims
		end
		if cp.nomoveandfire then
			info.nomoveandfire = cp.nomoveandfire
		end
		-- Children
		info.children = table.unserialize(cp.children)
		-- And finally, stick it in GG for the script to access
		GG.lusHelper[unitDefID] = info
	end
	WeaponDataPreload()
end

function gadget:Initialize()
	gadget:GamePreload()
	for _,unitID in ipairs(Spring.GetAllUnits()) do
		local teamID = Spring.GetUnitTeam(unitID)
		local unitDefID = GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID, teamID)
	end
end


else

-- UNSYNCED

local PlaySoundFile	= Spring.PlaySoundFile
local MY_TEAM_ID = Spring.GetMyTeamID()

function PlayTeamSound(eventID, teamID, sound, volume)
	if teamID == MY_TEAM_ID then
		PlaySoundFile(sound, volume, "ui")
	end
end

function gadget:Initialize()
	gadgetHandler:AddSyncAction("SOUND", PlayTeamSound)
end

end
