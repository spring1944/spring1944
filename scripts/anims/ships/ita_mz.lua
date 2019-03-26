local ramp = piece('ramp')
local covers = {}

for n = 1, 4 do
	covers[n] = piece('cover' .. n)
end

local COVER_SIZE = -10.16 * 2.54
local COVER_SPEED = COVER_SIZE
local RAMP_ANGLE = math.rad(30)
local RAMP_SPEED = math.rad(10)

local function OpenRamp()
	Turn(ramp, x_axis, RAMP_ANGLE, RAMP_SPEED)
	for n = 1, 4 do
		Move(covers[n], z_axis, COVER_SIZE, COVER_SPEED)
		WaitForMove(covers[n], z_axis)
		Hide(covers[n])
	end
	WaitForTurn(ramp, x_axis)
end

local function CloseRamp()
	Turn(ramp, x_axis, 0, RAMP_SPEED)
	for n = 1, 4 do
		Show(covers[n])
		Move(covers[n], z_axis, 0, COVER_SPEED)
		WaitForMove(covers[n], z_axis)
	end
end

return {
	OpenRamp = OpenRamp,
	CloseRamp = CloseRamp,
}