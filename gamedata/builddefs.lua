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

<<<<<<< HEAD
if (modOptions) then
	if (modOptions.navies) then
		local tmpNavies = tonumber(modOptions.navies)
		if tmpNavies > 0 then
			-- add Light ships
			table.insert(buildoptions.rusboatyardlarge, "ruspr161")
			table.insert(buildoptions.rusboatyardlarge, "ruspr7")
			
			table.insert(buildoptions.gerboatyardlarge, "gerflottentorpboot")
			table.insert(buildoptions.gerboatyardlarge, "gertype1934")	
			
			table.insert(buildoptions.gbrboatyardlarge, "gbrhuntii")
			table.insert(buildoptions.gbrboatyardlarge, "gbroclass")

			table.insert(buildoptions.usboatyardlarge, "ustacoma")
			table.insert(buildoptions.usboatyardlarge, "usfletcher")
		end
	end
end

=======
>>>>>>> master
return buildoptions
