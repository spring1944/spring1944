include "Yard.lua"
local smoke = piece "smoke"
local smoke2 = piece "smoke2"
local barge1 = piece "barge1"
local barge2 = piece "barge2"
local barge3 = piece "barge3"
local barge4 = piece "barge4"

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
	active = true
end

function script.StopBuilding()
	_StopBuilding()
	active = false
end
