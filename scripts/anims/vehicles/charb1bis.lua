local tools = piece "tools"
local chain = piece "chain"
local spare = piece "spare"

local random = math.random

local function CustomizePieces()

	if tools and random(3) == 1 then
		Hide(tools)
	end
	
	if chain and random(3) == 1 then
		Hide(chain)
	end
	
	if spare and random(3) == 1 then
		Hide(spare)
	end
end

local anims =
{
	postCreate = CustomizePieces,
}

return anims