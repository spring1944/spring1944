VFS.Include('scripts/UnitScriptConstants.lua')

local deg, rad = math.deg, math.rad

local MoveRate=false, iFear
local RecoverRate		=	1000
local RecoverConstant	=	1

local PROP_SPEED	=	rad(800)
local PROP_ACCEL	=	rad(200)

-- pieces definition
base, fuselage, wing1, gear1, wheel1, wing2, gear2, wheel2 = piece('base', 'fuselage', 'wing1', 'gear1', 'wheel1', 'wing2', 'gear2', 'wheel2')
propeller, blades, door1a, door1b, door2a, door2b = piece('propeller', 'blades', 'door1a', 'door1b', 'door2a', 'door2b')
mg1, mg2, cannon1, cannon2, turret, machinegun, mgflare = piece('mg1', 'mg2', 'cannon1', 'cannon2', 'turret', 'machinegun', 'mgflare')
bomb1, bomb2, bombemit1, bombemit2 = piece('bomb1', 'bomb2', 'bombemit1', 'bombemit2')
rocket1, rocket2, rocket3, rocket4, rocketexhaust1, rocketexhaust2, rocketexhaust3, rocketexhaust4 = piece('rocket1', 'rocket2', 'rocket3', 'rocket4', 'rocketexhaust1', 'rocketexhaust2', 'rocketexhaust3', 'rocketexhaust4')

--[[
Weapons:
	1 = bombs
	2,3 = cannons
	4,5 = nose MG
	6 = tail AA MG
	7 = small tracer
	8 = med tracer
	9 = large tracer
]]--

SMOKEPUFF_GPL_FX	=	1024+0
MG_SHELLCASINGS		=	1024+1
MG_MUZZLEFLASH		=	1024+2
XSMALL_MUZZLEFLASH	=	1024+3
XLARGE_MUZZLEFLASH	=	1024+4

SIG_BANK			=	2
SIG_AIM				=	4
SIG_FEARRECOVERY	=	8

BugOutLevel			=	90 --% of health when the pilot drops bombs for more speed

--tracers
SMALL_TRACER		=	2048+6
MEDIUM_TRACER		= 	2048+7
LARGE_TRACER		= 	2048+8

local sound_files	=	{'sounds/rus_air_il2_select', 'sounds/rus_air_underaafire', 'sounds/rus_air_return'}

function script.PlaneVoice(phraseNum)
	local my_id = GetUnitValue(GET_CONSTANTS.my_id)
	local x, y, z = Spring.GetUnitPosition(my_id)
	Spring.PlaySoundFile(sound_files[phraseNum], 1, x, y, z)
end

function startengine()
	Spin(propeller, z_axis, rad(800), rad(200))
	Sleep(400)
	Spin(propeller, z_axis, rad(5000), rad(-5000))
	Sleep(200)
	Spin(propeller, z_axis, rad(5000), rad(5000))
	Hide(blades)
	SetUnitValue(1024, 1)
end

function stopengine()
	Show(blades)
	Spin(propeller, z_axis, rad(800), rad(-400))
	Sleep(400)
	Spin(propeller, z_axis, rad(50))
	SetUnitValue(1024, 0)
end

function bankright()
	Signal(SIG_BANK)
	SetSignalMask(SIG_BANK)
	Turn(fuselage, z_axis, rad(-30), rad(30))
	Sleep(100)
	Turn(fuselage, z_axis, 0, rad(30))
end

function bankleft()
	Signal(SIG_BANK)
	SetSignalMask(SIG_BANK)
	Turn(fuselage, z_axis, rad(30), rad(30))
	Sleep(100)
	Turn(fuselage, z_axis, 0, rad(30))
end

function gearsup()
		Turn(door1a, z_axis, 0, rad(50))
		Turn(door1b, z_axis, 0, rad(50))
		Turn(door2a, z_axis, 0, rad(50))
		Turn(door2b, z_axis, 0, rad(50))
		Turn(gear1, z_axis, 0, rad(30))
		Turn(gear2, z_axis, 0, rad(30))
end

function gearsdown()
		Turn(door1a, z_axis, rad(90), rad(50))
		Turn(door1b, z_axis, rad(-90), rad(50))
		Turn(door2a, z_axis, rad(90), rad(50))
		Turn(door2b, z_axis, rad(-90), rad(50))
		Turn(gear1, z_axis, rad(-100), rad(30))
		Turn(gear2, z_axis, rad(-100), rad(30))
end

function SmokeControl()
	local healthpercent, sleeptime, smoketype
	-- wait until construction ends
	while GetUnitValue(GET_CONSTANTS.build_percent_left) > 0 do
		Sleep(400)
	end
	while (1 == 1) do
		healthpercent = GetUnitValue(GET_CONSTANTS.health)
		if healthpercent < 66 then
			smoketype = SFXTYPE.blacksmoke
			if math.random(66) < healthpercent then
				smoketype = SFXTYPE.whitesmoke
			end
			EmitSfx(base, smoketype)
		end
		sleeptime = healthpercent * 50
		if sleeptime < 200 then
			sleeptime = 200
		end
		Sleep(sleeptime)
	end
end

function script.MoveRate2()
	if math.random(10) == 1 and (not MoveRate) then
		MoveRate = true
		Turn(base, z_axis, rad(240), rad(120))
		WaitForTurn(base, z_axis)
		Turn(base, z_axis, rad(120), rad(180))
		WaitForTurn(base, z_axis)
		Turn(base, z_axis, 0, rad(120))
		MoveRate = false
	end
end

function script.Create()
	SetUnitValue(GET_CONSTANTS.standingfireorders, 1)
	MoveRate = false
	StartThread(SmokeControl)
	SetUnitValue(1024, 0)
end

function FearRecovery()
	Signal(SIG_FEARRECOVERY)
	SetSignalMask(SIG_REARRECOVERY)
	while iFear > 0 do
		Sleep(RecoverRate)
		iFear = iFear - RecoverConstant
	end
	return 1
end

function script.HitByWeaponId(z,x,id,damage)
	if Id==701 then
		iFear = iFear + AAFear
		if iFear > FearLimit then
			iFear = FearLimit -- put this line AFTER increasing iFear var
		end
		StartThread(FearRecovery)
		Return(100)
	end

	local health = GetUnitValue(GET_CONSTANTS.health)
	local bombReloadFrame = GetUnitValue(GET_CONSTANTS.weapon_reloadstate, 1)
	local curFrame = GetUnitValue(GET_CONSTANTS.game_frame)
	
	if (health <= BugOutLevel) and (bombReloadFrame < (curFrame + 1)) then
		GetUnitValue(GET_CONSTANTS.weapon_projectile_speed, -1, 100)
		EmitSfx(bombemit1, 2048+1)
		Hide(bomb1)
		Hide(bomb2)
		GetUnitValue(GET_CONSTANTS.weapon_reloadstate, -1, curFrame+108000);
	end
	return 100
end

function luaFunction(arg1)
	arg1 = iFear
end

-- bombs
function script.AimFromWeapon1()
	return fuselage
end

function script.QueryWeapon1()
	return bomb1
end

function script.AimWeapon1(heading, pitch)
	return true
end

function script.FireWeapon1()
end

-- 23mm guns
function script.QueryWeapon2()
	return cannon1
end

function script.AimFromWeapon2()
	return fuselage
end

function script.AimWeapon2(heading, pitch)
	return true
end

function script.FireWeapon2()
	--
end

function script.Shot2()
	EmitSfx(cannon1, LARGE_TRACER)
	EmitSfx(cannon1, XSMALL_MUZZLEFLASH)
end

function script.QueryWeapon3()
	return cannon2
end

function script.AimFromWeapon3()
	return fuselage
end

function script.AimWeapon3(heading, pitch)
	return true
end

function script.FireWeapon3()
	--
end

function script.Shot3()
	EmitSfx(cannon2, LARGE_TRACER)
	EmitSfx(cannon2, XSMALL_MUZZLEFLASH)
end

-- 12.7mm forward facing MG
function script.QueryWeapon4()
	return mg1
end

function script.AimFromWeapon4()
	return fuselage
end

function script.AimWeapon4(heading, pitch)
	return true
end

function script.FireWeapon4()
	EmitSfx(mg1, MEDIUM_TRACER)
end

function script.Shot4()
	EmitSfx(mg1, MG_MUZZLEFLASH)
	EmitSfx(mg1, MG_SHELLCASINGS)
end

function script.QueryWeapon5()
	return mg2
end

function script.AimFromWeapon5()
	return fuselage
end

function script.AimWeapon5(heading, pitch)
	return true
end

function script.FireWeapon5()
	EmitSfx(mg2, MEDIUM_TRACER)
end

function script.Shot5()
	EmitSfx(mg2, MG_MUZZLEFLASH)
	EmitSfx(mg2, MG_SHELLCASINGS)
end

-- AA MG
function script.QueryWeapon6()
	return mgflare
end

function script.AimFromWeapon6()
	return turret
end

function script.AimWeapon6(heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading - rad(180), rad(200))
	Turn(machinegun, x_axis, pitch, rad(200))
	WaitForTurn(turret, y_axis)
	WaitForTurn(machinegun, x_axis)
	return true
end

function script.FireWeapon6()
	EmitSfx(mgflare, MEDIUM_TRACER)
end

function script.Shot6()
	EmitSfx(mgflare, MG_MUZZLEFLASH)
	EmitSfx(mgflare, MG_SHELLCASINGS)
end

function script.Killed(recentDamage, maxHealth)
	local corpsetype = 1
	Explode(base, EXPLOSION.bitmaponly)
	Explode(fuselage, EXPLOSION.fall + EXPLOSION.smoke + EXPLOSION.fire + EXPLOSION.explode_on_hit)
	Explode(wing1, EXPLOSION.fall + EXPLOSION.smoke + EXPLOSION.fire + EXPLOSION.explode_on_hit)
	Explode(wing2, EXPLOSION.fall + EXPLOSION.smoke + EXPLOSION.fire + EXPLOSION.explode_on_hit)
	Explode(gear1, EXPLOSION.fall + EXPLOSION.smoke + EXPLOSION.fire + EXPLOSION.explode_on_hit)
	Explode(gear2, EXPLOSION.fall + EXPLOSION.smoke + EXPLOSION.fire + EXPLOSION.explode_on_hit)
	Explode(propeller, EXPLOSION.fall + EXPLOSION.smoke + EXPLOSION.fire + EXPLOSION.explode_on_hit)
end