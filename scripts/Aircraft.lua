local info = GG.lusHelper[unitDefID]

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

local function IsMainGun(weaponNum)
	return weaponNum <= info.weaponsWithAmmo
end

function script.QueryWeapon(weaponNum)
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
	local cegPiece = info.cegPieces[weaponNum]
	if ceg and cegPiece then
		GG.EmitSfxName(unitID, cegPiece, ceg)
	end
	if info.bombWeaponIDs[weaponNum] and cegPiece then Hide(cegPiece) end
end

function script.Killed(recentDamage, maxHealth)
end