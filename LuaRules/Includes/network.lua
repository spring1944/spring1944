-- Simple Delta compression for binary strings
-- License: GPL v2 or later
--
-- The compression prepends every 8 bytes with a bitmask byte telling which of the
-- following bytes were changed.
-- Example: A mask of 9 (00001001) will be followed by 2 bytes,
--          the first and the fourth.
--          The other 5 weren't sent since they haven't changed
--          since the last frame.

local Net = {}

function Net.DeltaCompress(data, prevData, isKeyFrame)
	local result = ''
	local currentBit = 1
	local sectionBitMask = 0
	local section = ''
	for i=1,data:len() do
		local c = data:sub(i, i)
		if isKeyFrame or c ~= prevData:sub(i, i) then
			section = section .. c
			sectionBitMask = sectionBitMask + currentBit
		end
		if i % 8 == 0 or i == data:len() then
			result = result .. string.char(sectionBitMask) .. section
			currentBit = 1
			sectionBitMask = 0
			section = ''
		else
			currentBit = currentBit * 2
		end
	end
	return result
end

function Net.DeltaDecompress(packet, prevData)
	local result = ''
	local sectionBitMask
	local section = ''
	local offset = 1
	if not prevData then
		for i=1, packet:len() do
			if i % 9 == 1 then
				sectionBitMask = string.byte(packet, i)
			elseif sectionBitMask % 2 ~= 1 then
				return nil
			else
				result = result .. packet:sub(i, i)
				sectionBitMask = math.floor(sectionBitMask / 2) -- 8 bit shift right
			end
		end
		return result
	end
	for i=1,prevData:len() do
		if i % 8 == 1 then
			sectionBitMask = string.byte(packet, offset)
			offset = offset + 1
		end
		if sectionBitMask % 2 == 1 then
			result = result .. packet:sub(offset, offset)
			offset = offset + 1
		else
			result = result .. prevData:sub(i, i)
		end
		sectionBitMask = math.floor(sectionBitMask / 2) -- 8 bit shift right
	end
	return result
end

return Net