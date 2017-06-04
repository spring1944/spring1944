local tools = piece "tools"
local addons = piece "addons"

local tent1 = piece "tent"
local tent2 = piece "trailer_tent"

local random = math.random

local function CustomizePieces()

	if tools and random(3) == 1 then
		Hide(tools)
	end

	if addons and random(3) == 1 then
		Hide(addons)
	end
	
	if tent1 and random(3) == 1 then
		Hide(tent1)
	end

	if tent2 and random(3) == 1 then
		Hide(tent2)
	end
end

local anims =
{
	postCreate = CustomizePieces,
}

return anims