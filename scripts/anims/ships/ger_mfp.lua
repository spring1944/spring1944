local door1, door2 = piece('door1', 'door2')
local slider_guide = piece('slider_guide')
local ramp = piece('ramp')
local covers = {}

for n = 1, 3 do
	covers[n] = piece('slider' .. n)
end

local SLIDER_INIT_ANGLE = math.rad(5.5)
local COVER_SIZE = -10.16 * 2.54
local COVER_SPEED = COVER_SIZE
local RAMP_ANGLE = math.rad(30)
local RAMP_SPEED = math.rad(10)
local DOOR_SPEED = RAMP_SPEED * 3

local function postCreated()
	Turn(slider_guide, x_axis, SLIDER_INIT_ANGLE)
end

local function OpenRamp()
	Turn(ramp, x_axis, RAMP_ANGLE, RAMP_SPEED)
	Turn(door1, y_axis, math.rad(-90), DOOR_SPEED)
	Turn(door2, y_axis, math.rad(90), DOOR_SPEED)
	for n = 1, 3 do
		Move(covers[n], z_axis, COVER_SIZE, COVER_SPEED)
		WaitForMove(covers[n], z_axis)
		Hide(covers[n])
	end
	WaitForTurn(ramp, x_axis)
end

local function CloseRamp()
	Turn(ramp, x_axis, 0, RAMP_SPEED)
	Turn(door1, y_axis, 0, DOOR_SPEED)
	Turn(door2, y_axis, 0, DOOR_SPEED)
	for n = 1, 3 do
		Show(covers[n])
		Move(covers[n], z_axis, 0, COVER_SPEED)
		WaitForMove(covers[n], z_axis)
	end
end

return {
	postCreated = postCreated,
	OpenRamp = OpenRamp,
	CloseRamp = CloseRamp,
}