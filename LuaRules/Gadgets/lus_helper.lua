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
-- Synced Ctrl
local PlaySoundFile			= Spring.PlaySoundFile
local SpawnCEG				= Spring.SpawnCEG
local SetUnitWeaponState	= Spring.SetUnitWeaponState
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
			--Spring.Echo(startX + i, startZ + j)
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
		--Spring.Echo(targetID)
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
			--Spring.Echo("pieceName:", pieceName, pieceMap[pieceName])
			GG.RecursiveHide(unitID, pieceMap[pieceName], hide)
		end
	end
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

local function GetAimingPieces(unitID, pieceName, pieceMap)
	local headingPiece
	local pitchPiece
	local currentPiece = pieceName
	local i = 0
	while pieceMap[currentPiece] do
		if i > 20 then
			break
		end
		i = i + 1
		
		if currentPiece:find("turret") then
			headingPiece = pieceMap[currentPiece]
		end
		if currentPiece:find("sleeve") then
			pitchPiece = pieceMap[currentPiece]
		end
		if headingPiece and pitchPiece then
            break
        end
		
		local pieceInfo = GetUnitPieceInfo(unitID, pieceMap[currentPiece])
		currentPiece = pieceInfo.parent
	end
	return headingPiece, pitchPiece
end

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
	local info = GG.lusHelper[unitDefID]
	local cp = UnitDefs[unitDefID].customParams
	if not udCache[unitDefID] then
		udCache[unitDefID] = true
		-- Parse Model Data
		local pieceMap = GetUnitPieceMap(unitID)
		local launcherIDs = {}
		local turretIDs = {}
		local mantletIDs = {}
		local barrelIDs = {}
		local numRockets = 0
		local numBarrels = 0
		local numWheels = 0
		local wheelSpeeds = {}
		local tracks = {}
		local smokePieces = {}
		local cegPieces = {}
		local aimPieces = {}
		local reversedWeapons = {}
		for pieceName, pieceNum in pairs(pieceMap) do
			--[[local weapNumPos = pieceName:find("_") or 0
			local weapNumEndPos = pieceName:find("_", weapNumPos+1) or 0
			local weaponNum = tonumber(pieceName:sub(weapNumPos+1,weapNumEndPos-1))]]
			-- Find launcher pieces
			if pieceName:find("rocket") then
				numRockets = numRockets + 1
			-- Find mantlet pieces
			--[[elseif pieceName:find("mantlet_") then
				mantletIDs[weaponNum] = true]]
			-- Find barrel pieces
			elseif pieceName:find("barrel") then
				--barrelIDs[weaponNum] = true
				numBarrels = numBarrels + 1
			-- Find the number of wheels
			elseif pieceName:find("wheel") then
				numWheels = numWheels + 1
				local wheelInfo = Spring.GetUnitPieceInfo(unitID, pieceNum)
				local wheelHeight = math.abs(wheelInfo.max[2] - wheelInfo.min[2])
				wheelSpeeds[pieceNum] = (UnitDefs[unitDefID].speed / wheelHeight)
			elseif pieceName:find("tracks") then
				tracks[#tracks + 1] = pieceNum
			elseif pieceName:find("base") or pieceName:find("mantlet") or pieceName:find("turret") or pieceName:find("exhaust") then
				smokePieces[#smokePieces + 1] = pieceNum
			end
		end
		
		if cp.cegpiece then
			for weaponNum, pieceName in pairs(table.unserialize(cp.cegpiece)) do
				if pieceMap[pieceName] and info.reloadTimes[weaponNum] then -- don't use garbage from inherited cegPiece
					cegPieces[weaponNum] = pieceMap[pieceName]
					local headingPiece, pitchPiece = GetAimingPieces(unitID, pieceName, pieceMap)
					aimPieces[weaponNum] = {headingPiece, pitchPiece}
					
					local _, _, _, dx, dy, dz = GetUnitPiecePosDir(unitID, pieceMap[pieceName])
					local frontDir = Spring.GetUnitVectors(unitID)
					local dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
					if dotFront < 0 then
						reversedWeapons[weaponNum] = true
					end
				end
			end
        else
            local lastflare = pieceMap["flare"] and "flare"
            for weaponNum, _ in pairs(info.reloadTimes) do
                lastflare = pieceMap["flare_" .. weaponNum] and ("flare_" .. weaponNum) or lastflare
                Spring.Echo(UnitDefs[unitDefID].name, weaponNum, lastflare)
                cegPieces[weaponNum] = pieceMap[lastflare]
                local headingPiece, pitchPiece = GetAimingPieces(unitID, lastflare, pieceMap)
                aimPieces[weaponNum] = {headingPiece, pitchPiece}
                
                local _, _, _, dx, dy, dz = GetUnitPiecePosDir(unitID, pieceMap[lastflare])
                local frontDir = Spring.GetUnitVectors(unitID)
                local dotFront = dx * frontDir[1] + dy * frontDir[2] + dz * frontDir[3]
                if dotFront < 0 then
                    reversedWeapons[weaponNum] = true
                end
            end
		end
		
		info.numBarrels = numBarrels
		info.numRockets = numRockets
		info.numWheels = numWheels
		info.wheelSpeeds = wheelSpeeds
		info.tracks = tracks
		info.smokePieces = smokePieces
		info.cegPieces = cegPieces
		info.aimPieces = aimPieces
		info.reversedWeapons = reversedWeapons
	end
	
	-- Remove aircraft land and repairlevel buttons
	if UnitDefs[unitDefID].canFly then
		Spring.GiveOrderToUnit(unitID, CMD.IDLEMODE, {0}, {})
		local toRemove = {CMD.IDLEMODE, CMD.AUTOREPAIRLEVEL}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	elseif cp.mother then
		local toRemove = {CMD.LOAD_UNITS, CMD.UNLOAD_UNITS}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	elseif cp.child then
		local toRemove = {CMD.MOVE_STATE}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	end
end

function gadget:GamePreload()
	-- Parse UnitDef Data
	-- for featureName, _ in pairs(FeatureDefNames) do
		-- Spring.Echo(featureName)
	-- end
	for unitDefID, unitDef in pairs(UnitDefs) do
		local info = {}
		local cp = unitDef.customParams
		local weapons = unitDef.weapons
		
		-- Parse UnitDef Weapon Data
		local missileWeaponIDs = {}
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
		info.turretTurnSpeed = math.rad(tonumber(cp.turretturnspeed) or 75)
		info.elevationSpeed = math.rad(tonumber(cp.elevationspeed) or 60)
		info.barrelRecoilSpeed = (tonumber(cp.barrelrecoilspeed) or 10)
		info.barrelRecoilDist = (tonumber(cp.barrelrecoildist) or 5)
		info.aaWeapon = (tonumber(cp.aaweapon) or nil)
		-- info.wheelSpeed = math.rad(tonumber(cp.wheelspeed) or 100)
		-- info.wheelAccel = math.rad(tonumber(cp.wheelaccel) or info.wheelSpeed * 2)
		-- General
		info.numWeapons = #weapons
		info.weaponsWithAmmo = tonumber(cp.weaponswithammo) or 0
		info.mainAnimation = cp.scriptanimation
		info.deathAnim = table.unserialize(cp.deathanim) or {}
		info.axes = {["x"] = 1, ["y"] = 2, ["z"] = 3}
		info.fearLimit = (tonumber(cp.fearlimit) or nil)
		-- Children
		info.children = table.unserialize(cp.children)
		-- And finally, stick it in GG for the script to access
		GG.lusHelper[unitDefID] = info
	end
	
end

function gadget:Initialize()
	gadget:GamePreload()
	for _,unitID in ipairs(Spring.GetAllUnits()) do
		local teamID = Spring.GetUnitTeam(unitID)
		local unitDefID = Spring.GetUnitDefID(unitID)
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
