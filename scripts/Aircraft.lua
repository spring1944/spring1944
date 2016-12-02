local info = GG.lusHelper[unitDefID]

local SetUnitRulesParam = Spring.SetUnitRulesParam

if not info.cegPieces then
	include "AircraftLoader.lua"
end

-- Pieces
local base = piece("base")
local bomb = piece("bomb")

-- Logic
local SIG_MOVE = 1
local SIG_FEAR = 2
local SIG_AIM = {}
do
	local sig = SIG_FEAR
	for i = 1,info.numWeapons do
		sig = sig * 2
		SIG_AIM[i] = sig
	end
end

local lastRocket = 0
local fear = 0
local bombsFired = {}

local PI = math.pi
local FEAR_LIMIT = 10
local FEAR_INITIAL_SLEEP = 1000
local FEAR_SLEEP = 1000


local function DamageSmoke(smokePieces)
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	local n = #smokePieces
	_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	while (buildProgress < 1) do
		Sleep(150)
		_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	end
	-- random delay between smoke start
	timeDelay = math.random(1, 5)*33
	Sleep(timeDelay)
	while true do
		curHealth, maxHealth = Spring.GetUnitHealth(unitID)
		healthState = curHealth / maxHealth
		if healthState < 0.66 then
			EmitSfx(smokePieces[math.random(1,n)], SFX.WHITE_SMOKE)
			-- the less HP we have left, the more often the smoke
			timeDelay = 2000 * healthState
			-- no sence to make a delay shorter than a game frame
			if timeDelay < 33 then
				timeDelay = 33
			end
		else
			timeDelay = 2000
		end
		Sleep(timeDelay)
	end
end

function PlaneVoice(phrase)
	local soundFile = info.planeVoice[phrase]
	if soundFile then
		GG.UnitSay(unitID, soundFile)
	end
end

function script.Create()
	if info.smokePieces then
		StartThread(DamageSmoke, info.smokePieces)
	end
	-- hide propeller blades if any
	if info.blades then
		for _, blade in pairs(info.blades) do
			Hide(blade)
		end
	end
end


local function IsMainGun(weaponNum)
	return weaponNum <= info.weaponsWithAmmo
end

local function IsRocket(weaponNum)
	return info.rocketWeapons[weaponNum]
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
	if IsRocket(weaponNum) then
		return lastRocket >= info.numRockets
	end
	if info.bombPieces[weaponNum] then
		return bombsFired[weaponNum] ~= nil
	end
	if IsMainGun(weaponNum) then
		return Spring.GetUnitRulesParam(unitID, "ammo") < 1
	end
	return false
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
		bombsFired[weaponNum] = true
	end
end

function script.FireWeapon(weaponNum)
	if info.paratroopWeaponIDs[weaponNum] then
		if UnitDef.customParams.planevoice then
			PlaneVoice('drop_started')
		end	
	end
end

function script.EndBurst(weaponNum)
	if info.paratroopWeaponIDs[weaponNum] then
		-- return to base immedeately after paradropping
		SetUnitRulesParam(unitID, "fuel", 0)
		if UnitDef.customParams.planevoice then
			PlaneVoice('drop_complete')
		end
	end
end

function script.Killed(recentDamage, maxHealth)
	local pieceMap = Spring.GetUnitPieceMap(unitID)
	Spring.SetUnitRulesParam(unitID, "fear", fear)
	for _,pieceID in pairs(pieceMap) do
		if math.random(5) < 2 then
			Explode(pieceID, SFX.FALL + SFX.SMOKE + SFX.FIRE + SFX.EXPLODE_ON_HIT)
		else
			Explode(pieceID, SFX.SHATTER)
		end
	end

	return 1
end

local function RecoverFear()
	Signal(SIG_FEAR)
	SetSignalMask(SIG_FEAR)
	Sleep(FEAR_SLEEP)
	while fear > 0 do
		--Spring.Echo("Lowered fear", fear)
		fear = fear - 1
		Spring.SetUnitRulesParam(unitID, "fear", fear)
		Sleep(FEAR_SLEEP)
	end
end

function AddFear(amount)
	ud = UnitDefs[unitDefID]
	if ud.name ~= "usc47" then 
		Signal(SIG_FEAR)
		fear = fear + amount
		if fear > FEAR_LIMIT then
		fear = FEAR_LIMIT
		Spring.SetUnitRulesParam(unitID, "fear", fear)
		StartThread(RecoverFear)
		end
	end
end


--for GMToolbox
if UnitDef.isBuilder then
	function script.StartBuilding(buildHeading, pitch)
		Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 1)
	end

	function script.StopBuilding()
		Spring.SetUnitCOBValue(unitID, COB.INBUILDSTANCE, 0)
	end
end
