include "Yard.lua"
Spring.Echo("bla")
local crane = piece "crane"
local crane2 = piece "crane2"
local turret = piece "turret"
local turret2 = piece "turret2"
local smoke = piece "smoke"
local smoke2 = piece "smoke2"
local barge1 = piece "barge1"
local barge2 = piece "barge2"
local barge3 = piece "barge3"
local barge4 = piece "barge4"

local CRANE_TURN_SPEED  = math.rad(5)
local CRANE_RAISE_ANGLE	= math.rad(-30)
local CRANE_MIN_POS     = math.rad(80)
local CRANE_MAX_STEPS   = 20
local CRANE_STEP_VALUE  = CRANE_MIN_POS / CRANE_MAX_STEPS
local BARGE_MOVE_DIST   = 6
local BARGE_MOVE_SPEED  = 3
local SMOKE_DELAY       = 500


local active = false


local _Activate = script.Activate
local _Deactivate = script.Deactivate
local _Create = script.Create
local _StartBuilding = script.StartBuilding
local _StopBuilding = script.StopBuilding

local function SafeTurn(p, ...)
	if p then
		Turn(p, ...)
	end
end

local function SafeMove(p, ...)
	if p then
		Move(p, ...)
	end
end

local function SafeWaitForMove(p, ...)
	if p then
		WaitForMove(p, ...)
	end
end

local function SafeEmitSfx(p, ...)
	if p then
		EmitSfx(p, ...)
	end
end


local function Funnels()
	while true do
		if active then
			if math.random(2) == 1 then
				SafeEmitSfx(smoke, SFX.BLACK_SMOKE)
			end
			if math.random(2) == 1 then
				SafeEmitSfx(smoke2, SFX.BLACK_SMOKE)
			end
		end
		Sleep(SMOKE_DELAY)
	end
end

local function CraneMovement1()
	if not turret then
		return
	end
	local nextCranePos
	while true do
		while active do
			nextCranePos = math.random(0, CRANE_MAX_STEPS)
			nextCranePos = nextCranePos * CRANE_STEP_VALUE + CRANE_MIN_POS
			Turn(turret, y_axis,-nextCranePos, CRANE_TURN_SPEED)
			Sleep(math.random(500, 5000))
		end
		Sleep(250)
	end
end

local function CraneMovement2()
	if not turret2 then
		return
	end
	local nextCranePos
	while true do
		while active do
			nextCranePos = math.random(0, CRANE_MAX_STEPS)
			nextCranePos = nextCranePos * CRANE_STEP_VALUE + CRANE_MIN_POS
			Turn(turret2, y_axis, math.pi + nextCranePos, CRANE_TURN_SPEED)
			Sleep(math.random(500, 5000))
		end
		Sleep(250)
	end
end

local function OpenYard()
	Signal(1)
	SetSignalMask(1)
	SafeMove(barge1, x_axis, -BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeMove(barge2, x_axis, BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeMove(barge3, x_axis, -BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeMove(barge4, x_axis, BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeWaitForMove(barge1, x_axis)
	SafeWaitForMove(barge2, x_axis)
	
	SetUnitValue(COB.YARD_OPEN, true)
end

local function CloseYard()
	Signal(1)
	SetSignalMask(1)
	SetUnitValue(COB.YARD_OPEN, false)
	
	SafeMove(barge1, x_axis, 0, BARGE_MOVE_SPEED)
	SafeMove(barge2, x_axis, 0, BARGE_MOVE_SPEED)
	SafeMove(barge3, x_axis, 0, BARGE_MOVE_SPEED)
	SafeMove(barge4, x_axis, 0, BARGE_MOVE_SPEED)
	SafeWaitForMove(barge1, x_axis)
	SafeWaitForMove(barge2, x_axis)
	
end

function script.Create()
	_Create()
	StartThread(Funnels)
	StartThread(CraneMovement1)
	StartThread(CraneMovement2)
end

function script.Activate()
	_Activate()
	active = true
	StartThread(OpenYard)
end

function script.Deactivate()
	_Deactivate()
	active = false
	StartThread(CloseYard)
end

function script.StartBuilding()
	_StartBuilding()
	SafeTurn(crane   ,x_axis, CRANE_RAISE_ANGLE, CRANE_TURN_SPEED)
	SafeTurn(crane2  ,x_axis, -CRANE_RAISE_ANGLE, CRANE_TURN_SPEED)
	active = true
end

function script.StopBuilding()
	_StopBuilding()
	SafeTurn(crane   ,x_axis, 0, CRANE_TURN_SPEED)
	SafeTurn(crane2  ,x_axis, 0, CRANE_TURN_SPEED)
	SafeTurn(turret  ,y_axis, 0, CRANE_TURN_SPEED)
	SafeTurn(turret2 ,y_axis, 0, CRANE_TURN_SPEED)
	active = false
end
