local tail = piece "tail"

local R39 = false

local spare = piece "spare"
if spare then
	R39 = true
end

local spare_tail = piece "spare_39"
local spare_no_tail = piece "spare_35"

local tent = piece "tent"
local tools = piece "tools"

local sidePieces = {}
local i = 1

for i = 1, 4 do
	sidePieces[i] = piece ("marker" .. i)
end

local random = math.random

local function CustomizePieces()

	-- all versions have tools independently of the tail
	if tools and random(3) == 1 then
		Hide(tools)
	end	

	if not R39 then
		-- This is R35
		if tent and random(3) == 1 then
			Hide(tent)
		end

		if random(2) == 1 then
			-- has no tail
			if tail then
				Hide(tail)
				Hide(spare_tail)
			end
			if random(2) == 1 then
				Hide(spare_no_tail)
			end
		else
			-- has a tail
			Hide(spare_no_tail)
			if random(2) == 1 then
				Hide(spare_tail)
			end
		end
	else
		-- This is R39
		if random(2) == 1 then
			-- no tail
			Hide(tail)
			Hide(tent)
			Hide(spare)
		else
			-- has a tail
			if random(3) == 1 then
				Hide(tent)
			end
			if random(3) == 1 then
				Hide(spare)
			end
		end
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