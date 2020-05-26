local antenna = piece "antenna"

local spare = piece "spare"
local tools1 = piece "tools1"
local tools2 = piece "tools2"
local lights = piece "lights"
local sleeve_lights = piece "sleeve_lights"
local horn = piece "horn"

local skirts = {}
local i = 1

for i = 1, 6 do
	skirts[i] = piece ("skirt" .. i)
end

local random = math.random

local function CustomizePieces()

	-- all versions have tools
	if tools1 and random(3) == 1 then
		Hide(tools1)
	end
	if tools2 and random(3) == 1 then
		Hide(tools2)
	end

	if sleeve_lights and random(2) == 1 then
		Hide(sleeve_lights)
	end

	if lights and random(2) == 1 then
		Turn(lights, x_axis, math.rad(-115), math.rad(45))
	end

	if horn and random(3) == 1 then
		Hide(horn)
	end

	if antenna and random(3) ~= 1 then
		Hide(antenna)
	end

	for i = 1, #skirts do
		local n = random(6)
		if i == n then
			Hide(skirts[i])
		end
	end
end

local anims =
{
	postCreate = CustomizePieces,
}

return anims