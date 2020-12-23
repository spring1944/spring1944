local function TableConcat(t1,t2)
	local tmpCount = 0
	for tmpName, tmpValue in pairs(t2) do
		t1[tmpName] = tmpValue
		tmpCount = tmpCount + 1
	end
    return t1, tmpCount
end

local buildoptions = {}

-- let's append all the side's units to the list
-- first find all the subtables
Spring.Log('builddefs', 'info', "Loading side build tables...")
local SideFiles = VFS.DirList("gamedata/side_units", "*.lua")
Spring.Log('builddefs', 'info', "Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Log('builddefs', 'info', " - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		local tmpCount
		buildoptions, tmpCount = TableConcat(buildoptions, tmpTable)
		Spring.Log('builddefs', 'info', " -- Added " .. tmpCount .. " entries")
		tmpTable = nil
	end
end

return buildoptions
