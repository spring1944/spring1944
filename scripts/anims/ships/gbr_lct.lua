local ramp = piece('ramp')

local RAMP_OPEN_ANGLE = math.rad(90)
local RAMP_OPEN_SPEED = math.rad(30)

local function OpenRamp()
	Turn(ramp, x_axis, RAMP_OPEN_ANGLE, RAMP_OPEN_SPEED)
	--WaitForTurn(ramp, x_axis)
end

local function CloseRamp()
	Turn(ramp, x_axis, 0, RAMP_OPEN_SPEED)
end

return {
	OpenRamp = OpenRamp,
	CloseRamp = CloseRamp,
}