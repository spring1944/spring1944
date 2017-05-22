local addon1 = piece "addon1"
local addon2 = piece "addon2"

local sidePieces = {}
local i = 1

for i = 1, 4 do
	sidePieces[i] = piece ("side" .. i)
end

local random = math.random

local function CustomizePieces()

	if addon1 and random(3) == 1 then
		Hide(addon1)
	end

	if addon2 and random(3) == 1 then
		Hide(addon2)
	end
	
	local n = random(4)
	for i = 1, #sidePieces do
		if i ~= n then
			Hide(sidePieces[i])
		end
	end
end

local anims =
{
	postCreate = CustomizePieces,
}

return anims