local can = piece "can"
local tools = piece "tools"

local random = math.random

local function CustomizePieces()

	if can and random(2) == 1 then
		Hide(can)
	end

	if tools and random(2) == 1 then
		Hide(tools)
	end

end

local anims =
{
	postCreate = CustomizePieces,
}

return anims