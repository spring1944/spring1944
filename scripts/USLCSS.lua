-- Pieces
local base = piece("base")
local prop = piece("prop")

info = GG.lusHelper[unitDefID]

local deg, rad, floor = math.deg, math.rad, math.floor

local MG_TURRET_TURN = rad(60)
local MG_TURRET_PITCH = rad(60)
local ROCKET_TURRET_TURN = rad(5)
local ROCKET_TURRET_PITCH = rad(5)

local SIG_MOVE = 1
local SIG_AIM1 = SIG_MOVE * 2
local SIG_AIM2 = SIG_AIM1 * 2
local SIG_AIM3 = SIG_AIM2 * 2

local rocket1 = 1
local rocket2 = 1
local rocketCount1 = 12
local rocketCount2 = 12

local usesAmmo = info.usesAmmo

local function GetAmmo()
	local ammo = 0
	if usesAmmo then
		ammo = Spring.GetUnitRulesParam(unitID, 'ammo')
	end
	return ammo
end

local bAimAA = false

local rocketFlares1 = {}
local rocketFlares2 = {}

for i = 1, 12 do
	rocketFlares1[i] = piece("rocket_1"..string.format("%02d", i))
	rocketFlares2[i] = piece("rocket_2"..string.format("%02d", i))
end

local rack1 = piece("rack1")
local rack2 = piece("rack2")

local sleeve1 = piece("sleeve1")
local sleeve2 = piece("sleeve2")

local sub11 = piece("sub11")
local sub12 = piece("sub12")
local sub21 = piece("sub21")
local sub22 = piece("sub22")

local mg_turret = piece("mg_turret")
local gun = piece("gun")
local flare = piece("flare")

local RESTORE_PERIOD = 5000

local bMoving = false

function DamageSmoke()
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	while (buildProgress < 1) do
		Sleep(150)
		_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	end
	-- random delay between smoke start
	timeDelay = math.random(1, 5)*30
	Sleep(timeDelay)
	while (1 == 1) do
		curHealth, maxHealth = Spring.GetUnitHealth(unitID)
		healthState = curHealth / maxHealth
		if healthState < 0.66 then
			EmitSfx(base, SFX.BLACK_SMOKE)
			-- the less HP we have left, the more often the smoke
			timeDelay = 500 * healthState
			-- no sence to make a delay shorter than a game frame
			if timeDelay < 30 then
				timeDelay = 30
			end
		else
			timeDelay = 500
		end
		Sleep(timeDelay)
	end
end

function FlagFlap()
	local _,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	while (buildProgress < 1) do
		Sleep(150)
		_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	end

	local FLAG_FLAP_ANGLE = rad(15)
	local FLAG_FLAP_SPEED = rad(30)
	local FLAG_SLEEP = 500

	local flag1 = piece("flag1")
	local flag2 = piece("flag2")
	local flag3 = piece("flag3")

	while true do
		Turn(flag1, y_axis, FLAG_FLAP_ANGLE, FLAG_FLAP_SPEED)
		Turn(flag2, y_axis, (0 - FLAG_FLAP_ANGLE), FLAG_FLAP_SPEED)
		Turn(flag3, y_axis, FLAG_FLAP_ANGLE, FLAG_FLAP_SPEED)

		Sleep(FLAG_SLEEP)

		Turn(flag1, y_axis, (0 - FLAG_FLAP_ANGLE), FLAG_FLAP_SPEED)
		Turn(flag2, y_axis, FLAG_FLAP_ANGLE, FLAG_FLAP_SPEED)
		Turn(flag3, y_axis, (0 - FLAG_FLAP_ANGLE), FLAG_FLAP_SPEED)

		Sleep(FLAG_SLEEP)
	end
end

function Wakes()
	local wake = piece("wake")
	
	while (1 == 1) do
		if bMoving then
			EmitSfx(wake, SFX.WAKE)
		end
		Sleep(150)
	end
end

function InitTurrets()
	Turn(mg_turret, y_axis, rad(180))
end

function RestoreTurrets()
	SetSignalMask(SIG_AIM1 + SIG_AIM2 + SIG_AIM3)
	Sleep(RESTORE_PERIOD)
	Turn(mg_turret, y_axis, rad(180), MG_TURRET_TURN)
	Turn(gun, x_axis, 0, MG_TURRET_PITCH)
	
	Turn(rack1, y_axis, 0, ROCKET_TURRET_TURN)
	Turn(sleeve1, x_axis, 0, ROCKET_TURRET_PITCH)
	Turn(sub11, x_axis, 0, ROCKET_TURRET_PITCH)
	Turn(sub12, x_axis, 0, ROCKET_TURRET_PITCH)

	Turn(rack2, y_axis, 0, ROCKET_TURRET_TURN)
	Turn(sleeve2, x_axis, 0, ROCKET_TURRET_PITCH)
	Turn(sub21, x_axis, 0, ROCKET_TURRET_PITCH)
	Turn(sub22, x_axis, 0, ROCKET_TURRET_PITCH)

	for i = 1, 12 do
		Turn(rocketFlares1[i], x_axis, 0, ROCKET_TURRET_PITCH)
		Turn(rocketFlares2[i], x_axis, 0, ROCKET_TURRET_PITCH)
	end

	rocketCount1 = 12
	rocketCount2 = 12
	rocket1 = 1
	rocket2 = 1
end

function script.Create()
	StartThread(FlagFlap)
	StartThread(DamageSmoke)
	StartThread(Wakes)
	InitTurrets()
end

function AimRack(rackNumber, heading, pitch)
	local rack = piece("rack"..rackNumber)
	local sleeve = piece("sleeve"..rackNumber)
	Turn(rack, y_axis, heading, ROCKET_TURRET_TURN)
	Turn(sleeve, x_axis, 0 - pitch, ROCKET_TURRET_PITCH)
	local sub1, sub2 = piece("sub"..rackNumber.."1"), piece("sub"..rackNumber.."2")
	Turn(sub1, x_axis, pitch, ROCKET_TURRET_PITCH)
	Turn(sub2, x_axis, 0 - pitch, ROCKET_TURRET_PITCH)
	for i = 1, 12 do
		Turn(piece("rocket_"..rackNumber..string.format("%02d", i)), x_axis, 0 - pitch, ROCKET_TURRET_PITCH)
	end
	WaitForTurn(rack, y_axis)
	WaitForTurn(sleeve, x_axis)
	return
end

function RocketDisplayControl(rackNumber)
	local counter, rocketList
	if rackNumber == 1 then
		counter = rocketCount1
		rocketList = rocketFlares1
	else
		counter = rocketCount2
		rocketList = rocketFlares2
	end

	for i = 0, 11 do
		local tmpRocket = rocketList[12 - i]
		if counter > i then
			Show(tmpRocket)
		else
			Hide(tmpRocket)
		end
	end

	counter = 12 - counter - 1
	local moveDist = -1 * floor(counter / 6) * 2.54 * 0.12
	local movePiece = piece("rocket_base_"..rackNumber)
	Move(movePiece, y_axis, moveDist)
	return
end

function script.BlockShot(weaponNum)
	if usesAmmo then
		local ammo = GetAmmo()
		if ammo <= 0 then
			return true
		end
	end

	return false
end

function script.AimFromWeapon1()
	return rack1
end

function script.QueryWeapon1()
	return rocketFlares1[rocket1]
end

function script.AimWeapon1(heading, pitch)
	if rocketCount1 <= 0 then
		return false
	end
	Signal(SIG_AIM1)
	SetSignalMask(SIG_AIM1)
	AimRack(1, heading, pitch)
	return true
end

function script.FireWeapon1()
	-- only check weapon1 since 2 is the same and it's supposed to use ammo once, not twice
	if usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		Spring.SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
	return
end

function script.Shot1()
	rocketCount1 = rocketCount1 - 1
	rocket1 = rocket1 + 1
	if rocket1 > 12 then
		rocket1 = 1
	end
	RocketDisplayControl(1)
	StartThread(RestoreTurrets)
	EmitSfx(flare, SFX.CEG + 1)
end

function script.AimFromWeapon2()
	return rack2
end

function script.QueryWeapon2()
	return rocketFlares2[rocket2]
end

function script.AimWeapon2(heading, pitch)
	if rocketCount2 <= 0 then
		return false
	end
	Signal(SIG_AIM2)
	SetSignalMask(SIG_AIM2)
	AimRack(2, heading, pitch)
	return true
end

function script.FireWeapon2()
	return
end

function script.Shot2()
	rocketCount2 = rocketCount2 - 1
	rocket2 = rocket2 + 1
	if rocket2 > 12 then
		rocket2 = 1
	end
	RocketDisplayControl(2)
	StartThread(RestoreTurrets)
	EmitSfx(flare, SFX.CEG + 2)
end

function script.QueryWeapon3()
	return flare
end

function script.AimFromWeapon3()
	return mg_turret
end

function script.AimWeapon3(heading, pitch)
	bAimAA = true
	Signal(SIG_AIM3)
	SetSignalMask(SIG_AIM3)
	Turn(mg_turret, y_axis, heading, MG_TURRET_TURN)
	Turn(gun, x_axis, 0 - pitch, MG_TURRET_PITCH)
	WaitForTurn(mg_turret, y_axis)
	WaitForTurn(gun, x_axis)
	StartThread(RestoreTurrets)
	bAimAA = false
	return true
end

function script.FireWeapon3()
	return
end

function script.Shot3()
	EmitSfx(flare, SFX.CEG + 3)
end

function script.QueryWeapon4()
	return flare
end

function script.AimFromWeapon4()
	return mg_turret
end

function script.AimWeapon4(heading, pitch)
	if bAimAA then
		return false
	end
	Signal(SIG_AIM3)
	SetSignalMask(SIG_AIM3)
	Turn(mg_turret, y_axis, heading, MG_TURRET_TURN)
	Turn(gun, x_axis, 0 - pitch, MG_TURRET_PITCH)
	WaitForTurn(mg_turret, y_axis)
	WaitForTurn(gun, x_axis)
	StartThread(RestoreTurrets)
	return true
end

function script.FireWeapon4()
	return
end

function script.Shot4()
	EmitSfx(flare, SFX.CEG + 4)
end

function script.StartMoving()
	bMoving = true
	Spin(prop, z_axis, rad(600))
end

function script.StopMoving()
	bMoving = false
	Spin(prop, z_axis, 0)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth
	
	if severity < 1 then
		local dA = info.deathAnim
		corpseType = 1
		for axis, data in pairs(dA) do
			Turn(base, info.axes[axis] or z_axis, -math.rad(data.angle or 30), math.rad(data.speed or 10))
		end
		for axis, data in pairs(dA) do
			WaitForTurn(base, info.axes[axis] or z_axis)
		end

		return 1
	else
		Explode(base, SFX.SHATTER)
		Explode(gun, SFX.FALL)
		Explode(rack1, SFX.FALL)
		Explode(rack2, SFX.FALL)
		return 2
	end
end
