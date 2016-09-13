local front1 = piece "front_1"
local front2 = piece "front_2"

local cans = piece "cans"
local rear_cans = piece "rear_cans"
local rear_cans_holder = piece "rear_cans_holder"

local tent = piece "tent"
local tools = piece "tools"

local windscreen = piece "windscreen_cover"
local supports = piece "supports"

local random = math.random
local rad = math.rad

local function CustomizePieces()
	-- customize windscreen cover position: either open or closed (and supports are hidden)
	if random(2) == 1 then
		Turn(windscreen, x_axis, -rad(63))
	else
		Hide(supports)
	end
	-- customize front part: either 1 or 2 is shown, the other is hidden. M16 lacks these so check if they are available
	if front1 and front2 then
		if random(2) == 1 then
			Hide(front2)
		else
			Hide(front1)
		end
	end
	-- customize front cans
	if random(2) == 1 then
		Hide(cans)
	end
	-- customize rear cans
	local n = random(3)
	if n == 1 then
		Hide(rear_cans)
		Hide(rear_cans_holder)
	elseif n == 2 then
		Hide(rear_cans)
	end
	-- customize tent. M16 has no tent so check for that
	if tent and random(2) == 1 then
		Hide(tent)
	end
	-- and tools
	if random(2) == 1 then
		Hide(tools)
	end
end

local anims =
{
	postCreate = CustomizePieces,
}

return anims