local sideData = VFS.Include("gamedata/sidedata.lua", nil, VFS.ZIP)
local SIDES = {}

for sideNum, data in pairs(sideData) do
	if sideNum > 1 then -- ignore Random/GM
		SIDES[sideNum] = data.name:lower()
	end
end

local function getSideName(name)
	local side = 'UNKNOWN'
	for _, sideName in pairs(SIDES) do
		if name:find(sideName) == 1 then
			side = sideName
			break
		end
	end
	return side
end

return getSideName