local spares = piece "spares"

local sidePieces = {}
local i = 1

for i = 1, 8 do
	sidePieces[i] = piece ("skirt" .. i)
end

local random = math.random

local function CustomizePieces()

	if spares and random(3) == 1 then
		Hide(spares)
	end

	for i = 1, #sidePieces do
		if random(3)==1 then
			Hide(sidePieces[i])
		end
	end
end

local anims =
{
	postCreate = CustomizePieces,
}

return anims