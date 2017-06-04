local tent = piece "tent"

local random = math.random

local function CustomizePieces()

	if tent and random(2) == 1 then
		Hide(tent)
	end

end

local anims =
{
	postCreate = CustomizePieces,
}

return anims