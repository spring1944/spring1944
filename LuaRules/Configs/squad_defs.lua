--[[

Syntax:

local squadDefs = {
	["squad_spawner"] = {
		"squad_member_1",
		"squad_member_2",
		"squad_member_3",
		...
		"squad_member_n",
	},
	... -- more squad spawners
}

where:

  squad_spawner is the unitname of the unit that spawns the
squad upon completion. This unit can be build from a factory, 
builder, spawned by Lua, anything. When it is created, it will
spawn the units specified in its squad_member array

  squad_member_n is the unit name of one of unit to spawn in
the squad. There can be as many squad_members as needed. All 
members of the squad will receive the orders assigned to the 
spawner unit. Thus, whole squads can be ordered around from
in a factory, like a normal unit would be.

]]--

local squadDefs = {
}

-- let's append all the side's squad units to the list
-- first find all the subtables
Spring.Echo("Loading side starting unit tables...")
local SideFiles = VFS.DirList("luarules/configs/side_squad_defs", "*.lua")
Spring.Echo("Found "..#SideFiles.." tables")
-- then add their contents to the main table
for _, SideFile in pairs(SideFiles) do
	Spring.Echo(" - Processing "..SideFile)
	local tmpTable = VFS.Include(SideFile)
	if tmpTable then
		local tmpCount = 0
		for morphName, subTable in pairs(tmpTable) do
			if squadDefs[morphName] == nil then
				squadDefs[morphName] = {}
			end
			local tmpSubTable = squadDefs[morphName]
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

-------------------------------------------------
-- Dont touch below here
-------------------------------------------------

if UnitDefNames then
    local squadDefIDs = { }

    for i, squad in pairs(squadDefs) do
        unitDef = UnitDefNames[i]
        if unitDef ~= nil then
            squadDefIDs[unitDef.id] = squad
        else
            Spring.Echo("  Bad unitName! " .. i)
        end
    end

    for i, squad in pairs(squadDefIDs) do
        squadDefs[i] = squad
    end
end

return squadDefs