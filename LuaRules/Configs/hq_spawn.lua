local hqDefs = {}

-- let's append all the side's starting units to the list
-- first find all the subtables
Spring.Echo("Loading side starting unit tables...")
local SideFiles = VFS.DirList("luarules/configs/side_hq_spawn", "*.lua")
Spring.Echo("Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Echo(" - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		local tmpCount = 0
		for HQName, subTable in pairs(tmpTable) do
			if hqDefs[HQName] == nil then
				hqDefs[HQName] = {}
			end
			local tmpSubTable = hqDefs[HQName]
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

return hqDefs
