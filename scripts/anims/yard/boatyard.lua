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

local function startBuildingAnim()
	active = true
	SafeMove(barge1, x_axis, -BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeMove(barge2, x_axis, BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeMove(barge3, x_axis, -BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
	SafeMove(barge4, x_axis, BARGE_MOVE_DIST, BARGE_MOVE_SPEED)
end

local function stopBuildingAnim()
	active = false
	SafeMove(barge1, x_axis, 0, BARGE_MOVE_SPEED)
	SafeMove(barge2, x_axis, 0, BARGE_MOVE_SPEED)
	SafeMove(barge3, x_axis, 0, BARGE_MOVE_SPEED)
	SafeMove(barge4, x_axis, 0, BARGE_MOVE_SPEED)
end

local function postCreate()
	StartThread(Funnels)
end

local anims =
{
	startBuildingAnim = startBuildingAnim,
	stopBuildingAnim = stopBuildingAnim,
	postCreate = postCreate,
}

return anims