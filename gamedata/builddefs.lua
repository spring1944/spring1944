local function TableConcat(t1,t2)
	local tmpCount = 0
	for tmpName, tmpValue in pairs(t2) do
		t1[tmpName] = tmpValue
		tmpCount = tmpCount + 1
	end
    return t1, tmpCount
end

local modOptions
if (Spring.GetModOptions) then
  modOptions = Spring.GetModOptions()
end

buildoptions = {}

-- let's append all the side's units to the list
-- first find all the subtables
Spring.Echo("Loading side build tables...")
local SideFiles = VFS.DirList("gamedata/side_units", "*.lua")
Spring.Echo("Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Echo(" - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		buildoptions, tmpCount = TableConcat(buildoptions, tmpTable)
		Spring.Echo(" -- Added "..tmpCount.." entries")
		tmpTable = nil
	end
end

return buildoptions
