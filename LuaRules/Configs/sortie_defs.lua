--[[
  format:
  sortie_unitname = {
    plane_unitname,
    plane_unitname,
    ...
    
    delay = number, -- number of frames before sortie arrives
    cursor = string, (default "Attack"), --cursor when ordering sortie
    weight = number, -- space taken up in airfield (default 0; better to use integers)
    alwaysAttack = bool, -- if true, sortie will always attack the given target or location
  }
]]

local sortieDefs = {}

-- let's append all the side's sorties to the list
-- first find all the subtables
Spring.Echo("Loading side sortie tables...")
local SideFiles = VFS.DirList("luarules/configs/side_sortie_defs", "*.lua")
Spring.Echo("Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Echo(" - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		local tmpCount = 0
		for sortieName, subTable in pairs(tmpTable) do
			if sortieDefs[sortieName] == nil then
				sortieDefs[sortieName] = {}
			end
			local tmpSubTable = sortieDefs[sortieName]
			-- add everything to it
			for paramName, param in pairs(subTable) do
				if paramName then
					tmpSubTable[paramName] = param
				else
					table.insert(tmpSubTable, param)
				end
			end
			tmpCount = tmpCount + 1
		end
		Spring.Echo(" -- Added "..tmpCount.." entries")
		tmpTable = nil
	end
end

return sortieDefs
