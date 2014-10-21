-- Pieces
local base = piece("base")
local tent = piece("tent")

local wheels = piece("front_wheels")
local rollers = {
	piece("roller1"),
	piece("roller_out_1"),
	piece("roller_out_2"),
	piece("roller_out_3"),
	piece("roller_in_1"),
	piece("roller_in_2"),
	piece("roller_in_3"),
	piece("roller_in_4"),
}

local wheelSpinSpeed = math.rad(360)
local rollerSpinSpeed = wheelSpinSpeed * 1.5

local treads = {
	piece("tracks"),
	piece("tracks2")
}

local treadDelay = 150

local SIG_MOVE = 1
local SIG_BUILD = 2

local bMoving = false

function DamageSmoke()
	-- emit some smoke if the unit is damaged
	-- check if the unit has finished building
	_,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
	while (buildProgress > 0) do
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

function WheelControl(speed)
	if speed ~= 0 then
		Spin(wheels, x_axis, wheelSpinSpeed * speed)
	else
		StopSpin(wheels, x_axis)
	end
	for _, roller in pairs(rollers) do
		if speed ~= 0 then
			Spin(roller, x_axis, rollerSpinSpeed * speed)
		else
			StopSpin(roller, x_axis)
		end
	end
end

function Treads()
	local treadNum = 1
	while true do
		if bMoving then
			Hide(treads[treadNum])
			treadNum = treadNum + 1
			if treadNum > #treads then
				treadNum = 1
			end
			Show(treads[treadNum])
		end
		Sleep(treadDelay)
	end
end

function script.Create()
	bMoving = false
	StartThread(DamageSmoke)
	StartThread(Treads)
end

function script.StartMoving()
	bMoving = true
	WheelControl(1)
end

function script.StopMoving()
	bMoving = false
	WheelControl(0)
end

function script.StartBuilding(heading, pitch)
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

function script.StopBuilding()
	SetUnitValue(COB.INBUILDSTANCE, 0)
end

function script.QueryNanoPiece()
	return base
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth
	local corpseNum = 0
	Explode(tent, SFX.SHATTER)
	if severity < 0.5 then
		corpseNum = 1
	elseif severity < 2.5 then
		corpseNum = 2
	elseif severity < 5 then
		corpseNum = 3
	else
		corpseNum = 4
		Explode(base, SFX.SHATTER)
	end
	return corpseNum
end