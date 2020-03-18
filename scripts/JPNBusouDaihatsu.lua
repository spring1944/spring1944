info = GG.lusHelper[unitDefID]

local rad = math.rad

-- Pieces
local base = piece("base")
local wake = piece("wake")
local ramp = piece("ramp")

local crane = piece("crane")
local cable2 = piece("cable2")
local cable3 = piece("cable3")
local cable4 = piece("cable4")
local crane_rocket = piece("crane_rocket")

local rockets =
	{
		[1] = piece("rocket1"),
		[2] = piece("rocket2"),
		[3] = piece("rocket3"),
	}

local turret = piece("turret")
local barrel = piece("barrel")
local rocket = piece("rocket")
local flare = piece("flare")
local backblast = piece("backblast")
local barrel_lid = piece("barrel_lid")

-- animation settings
local cable_length = -2.1
local cable_speed = 0.5
local crane_angle_pickup = rad(-110)
local crane_angle_release = rad(-45)
local crane_speed = rad(10)
local lid_open_angle = rad(60)
local lid_open_speed = rad(10)

-- aiming settings
local turretTurnSpeed = info.turretTurnSpeed or rad(5)
local elevationSpeed = info.elevationSpeed or rad(5)

local RESTORE_PERIOD = (info.reloadTimes[1] + 1) * 1000

-- signals
local SIG_MOVE = 1
local SIG_AIM = SIG_MOVE * 2

local rocket_count = 3
local isReloading = false

local usesAmmo = info.usesAmmo

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

function Wakes()
	local wake = piece("wake")
	
	while (1 == 1) do
		if bMoving then
			EmitSfx(wake, SFX.WAKE)
		end
		Sleep(150)
	end
end

function RestoreTurret()
	SetSignalMask(SIG_AIM)
	Sleep(RESTORE_PERIOD)
	if isReloading then
		return
	end
	Turn(turret, y_axis, 0, turretTurnSpeed)
	Turn(barrel, x_axis, 0, elevationSpeed)
end

function GetAmmo()
	local ammo = 0
	if usesAmmo then
		ammo = Spring.GetUnitRulesParam(unitID, 'ammo')
	end
	return ammo
end

function Reload()
	Signal(SIG_AIM)
	isReloading = true
	Hide(crane_rocket)
	Hide(rocket)
	-- Turret to 0
	Turn(turret, y_axis, 0, turretTurnSpeed)
	Turn(barrel, x_axis, 0, elevationSpeed)
	-- Crane to position to get a new rocket
	Turn(crane, y_axis, crane_angle_pickup, crane_speed)
	Turn(cable4, y_axis, 0 - crane_angle_pickup, crane_speed)
	WaitForTurn(crane, y_axis)
	Move(cable2, y_axis, cable_length, cable_speed)
	Move(cable3, y_axis, cable_length, cable_speed)
	Move(cable4, y_axis, cable_length, cable_speed)
	WaitForMove(cable2, y_axis)
	-- grab a rocket
	rocket_count = rocket_count - 1
	if rocket_count <= 0 then
		rocket_count = 1
		Show(rockets[3])
	end
	if rocket_count == 3 then
		-- Show the first 2 so they are here next time
		Show(rockets[1])
		Show(rockets[2])
	end
	Hide(rockets[rocket_count])
	Turn(cable4, y_axis, 0 - crane_angle_pickup + rad(90))
	Show(crane_rocket)
	-- get it back
	-- 1. Over the blast shield
	Move(cable2, y_axis, 0, cable_speed)
	Move(cable3, y_axis, 0, cable_speed)
	Move(cable4, y_axis, 0, cable_speed)
	WaitForMove(cable2, y_axis)
	-- 2. To the weapon
	Turn(cable4, y_axis, 0 - crane_angle_pickup)
	Turn(crane, y_axis, crane_angle_release, crane_speed)
	Turn(cable4, y_axis, 0 - crane_angle_release, crane_speed)
	-- 3. Open the lid
	Turn(barrel_lid, x_axis, lid_open_angle, lid_open_speed)
	-- 4. Lower rocket into the barrel
	WaitForTurn(crane, y_axis)
	Move(cable2, y_axis, cable_length, cable_speed)
	Move(cable3, y_axis, cable_length, cable_speed)
	Move(cable4, y_axis, cable_length, cable_speed)
	WaitForMove(cable2, y_axis)
	Hide(crane_rocket)
	Show(rocket)
	-- 5. Return crane to 0, close lid
	Turn(crane, y_axis, 0, crane_speed)
	Move(cable2, y_axis, 0, cable_speed)
	Move(cable3, y_axis, 0, cable_speed)
	Move(cable4, y_axis, 0, cable_speed)
	WaitForMove(cable2, y_axis)
	Turn(barrel_lid, x_axis, 0, lid_open_speed)
	WaitForTurn(barrel_lid, x_axis)
	isReloading = false
end

function script.Create()
	Hide(crane_rocket)
	StartThread(DamageSmoke)
	StartThread(Wakes)
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

function script.AimFromWeapon(weaponID)
	return turret
end

function script.QueryWeapon(weaponID)
	return flare
end

function script.AimWeapon(weaponID, heading, pitch)
	if isReloading then
		return false
	end
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(turret, y_axis, heading, turretTurnSpeed)
	Turn(barrel, x_axis, 0 - pitch, elevationSpeed)
	WaitForTurn(turret, y_axis)
	WaitForTurn(barrel, x_axis)
	-- failsafe in case it aims but never shoots
	StartThread(RestoreTurret)
	return true
end

function script.FireWeapon(weaponID)
	if usesAmmo then
		local currentAmmo = Spring.GetUnitRulesParam(unitID, 'ammo')
		Spring.SetUnitRulesParam(unitID, 'ammo', currentAmmo - 1)
	end
	return true
end

function script.Shot(weaponID)
	local ceg = info.weaponCEGs[1]
	GG.EmitSfxName(unitID, backblast, ceg)

	StartThread(Reload)
	return true
end

function script.StartMoving()
	bMoving = true
end

function script.StopMoving()
	bMoving = false
end

function script.Killed(recentDamage, maxHealth)
	local corpseType
	local severity = recentDamage / maxHealth

	local dA = info.deathAnim
	corpseType = 1
	for axis, data in pairs(dA) do
		Turn(base, info.axes[axis] or z_axis, -math.rad(data.angle or 30), math.rad(data.speed or 10))
	end
	for axis, data in pairs(dA) do
		WaitForTurn(base, info.axes[axis] or z_axis)
	end

	return corpseType
end