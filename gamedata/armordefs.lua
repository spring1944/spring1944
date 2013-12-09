local armorDefs = {}

-- let's append all the side's units to the list
-- first find all the subtables
Spring.Echo("Loading side armordef tables...")
local SideFiles = VFS.DirList("gamedata/side_armor_defs", "*.lua")
Spring.Echo("Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Echo(" - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		local tmpCount = 0
		for category, subTable in pairs(tmpTable) do
			-- initialize category in main table if not present
			if armorDefs[category] == nil then
				armorDefs[category] = {}
			end
			local tmpTable = armorDefs[category]
			-- add averything to it
			for _, unitName in pairs(subTable) do
				-- No need to check if this unit is already included, duplicates will be auto-eliminated on the next step
				table.insert(tmpTable, unitName)
				tmpCount = tmpCount + 1
			end
		end
		Spring.Echo(" -- Added "..tmpCount.." entries")
		tmpTable = nil
	end
end

local system = VFS.Include('gamedata/system.lua')  

return system.lowerkeys(armorDefs)
