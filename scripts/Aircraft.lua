local info = GG.lusHelper[unitDefID]

if not info.cegPieces then
	include "AircraftLoader.lua"
end

-- Pieces
local base = piece("base")
local bomb = piece("bomb")

-- Logic
local SIG_MOVE = 1
local SIG_AIM = {}
do
	local sig = SIG_MOVE
	for i = 1,info.numWeapons do
		sig = sig * 2
		SIG_AIM[i] = sig
	end
end
local lastRocket = 0

local PI = math.pi


local function IsMainGun(weaponNum)
	return weaponNum <= info.weaponsWithAmmo
end

local function IsRocket(weaponNum)
	return info.numRockets > 0 and IsMainGun(weaponNum)
end

function script.QueryWeapon(weaponNum)
	if IsRocket(weaponNum) then
		return piece("rocket" .. math.max(lastRocket, 1))
	end
	local cegPiece = info.cegPieces[weaponNum]
	if cegPiece then 
		return cegPiece
	end
	-- Shields etc.
	return base
end

function script.AimFromWeapon(weaponNum)
	local aimPieces = info.aimPieces[weaponNum]
	if aimPieces then
		return aimPieces[1]
	end
	return base
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	return (IsMainGun(weaponNum) and Spring.GetUnitRulesParam(unitID, "ammo") < 1) or false
end

function script.AimWeapon(weaponNum, heading, pitch)
	Signal(SIG_AIM[weaponNum])
	local aimPieces = info.aimPieces[weaponNum]
	if not aimPieces then
		return true
	end
	SetSignalMask(SIG_AIM[weaponNum])
	
	if info.reversedWeapons[weaponNum] then
		heading = heading + PI
		pitch = -pitch
	end
	
	local headingPiece, pitchPiece = aimPieces[1], aimPieces[2]
	Turn(headingPiece, y_axis, heading, info.turretTurnSpeed)
	
	if pitchPiece then
		Turn(pitchPiece, x_axis, -pitch, info.elevationSpeed)
		WaitForTurn(pitchPiece, x_axis)
	end
	
	WaitForTurn(headingPiece, y_axis)
	
	return true
end

function script.Shot(weaponNum)
	local ceg = info.weaponCEGs[weaponNum]
	local cegPiece
	if IsRocket(weaponNum) then
		lastRocket = lastRocket + 1
		Hide(piece("rocket" .. lastRocket))
		cegPiece = piece("exhaust" .. lastRocket)
	else
		cegPiece = info.cegPieces[weaponNum]
	end
	if ceg and cegPiece then
		GG.EmitSfxName(unitID, cegPiece, ceg)
	end
	if info.bombPieces[weaponNum] then
		Hide(info.bombPieces[weaponNum])
	end
end

function script.Killed(recentDamage, maxHealth)
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	for _,pieceID in pairs(pieceMap) do
		if math.random(5) < 2 then
			Explode(pieceID, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		else
			Explode(pieceID, SFX.SHATTER)
		end
	end
	
	return 1
end