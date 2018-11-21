local ramp1, ramp2 = piece('ramp1', 'ramp2')

local RAMP_ANGLE = math.rad(40)
local RAMP_SPEED = math.rad(20)

local function OpenRamp()
	Turn(ramp1, x_axis, RAMP_ANGLE, RAMP_SPEED)
	Turn(ramp2, x_axis, RAMP_ANGLE, RAMP_SPEED)
end

local function CloseRamp()
	Turn(ramp1, x_axis, 0, RAMP_SPEED)
	Turn(ramp2, x_axis, 0, RAMP_SPEED)
end

return {
	OpenRamp = OpenRamp,
	CloseRamp = CloseRamp,
}