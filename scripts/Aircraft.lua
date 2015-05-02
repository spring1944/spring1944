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
local lastRocket = info.numRockets


local function IsMainGun(weaponNum)
	return weaponNum <= info.weaponsWithAmmo
end

local function IsRocket(weaponNum)
	return info.numRockets > 0 and IsMainGun(weaponNum)
end

function script.QueryWeapon(weaponNum)
	if IsRocket(weaponNum) then
		return piece("rocket" .. lastRocket)
	end
	local cegPiece = info.cegPieces[weaponNum]
	if cegPiece then 
		return cegPiece
	end
	-- Shields etc.
	return base
end

function script.AimFromWeapon(weaponNum)
	return base
end

function script.BlockShot(weaponNum, targetUnitID, userTarget)
	return (IsMainGun(weaponNum) and Spring.GetUnitRulesParam(unitID, "ammo") < 1) or false
end

function script.AimWeapon(weaponNum, heading, pitch)
	Signal(SIG_AIM[weaponNum])
	
	return true
end

function script.Shot(weaponNum)
	local ceg = info.weaponCEGs[weaponNum]
	local cegPiece
	if IsRocket(weaponNum) then
		lastRocket = lastRocket % info.numRockets + 1
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
end