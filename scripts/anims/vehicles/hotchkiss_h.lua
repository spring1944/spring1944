local tail = piece "tail"
local spare = piece "spare"
local tent = piece "tent"
local tools = piece "tools"

local H39 = false

if tail then
	H39 = true
end

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

	if not H39 then
		-- This is H35
		if spare and random(3) == 1 then
			Hide(spare)
		end
	else
		-- This is H39
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