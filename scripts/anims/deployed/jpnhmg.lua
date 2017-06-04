local ammo = piece "ammo"
local ammoPosition = 0

local function postShot(num)
	if num == 1 then
		ammoPosition = ammoPosition + 1
		if ammoPosition > 30 then
			ammoPosition = 0
		end
		Move(ammo, x_axis, -ammoPosition * 0.14)
	end
end

local anims =
{
	postShot = postShot,
}

return anims
