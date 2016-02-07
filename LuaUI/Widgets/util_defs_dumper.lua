function widget:GetInfo()
  return {
    name      = "DefsDumper",
    desc      = "Saves UnitDefs and WeaponDefs to a diffable file.",
    author    = "s44yuritch",
    date      = "2 February 2016",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = false  --  loaded by default?
  }
end

local FILENAME = 'util_defs_dump' .. Game.gameShortName .. Game.gameVersion .. '.txt'
local mainTable = {}

function widget:Initialize()
	local id, def

	for id, def in pairs(UnitDefs) do
		-- Have to remove underscores to make output from 2.0 and master comparable
		AddToResultTable(def, 'Unit:' .. string.gsub(def.name, "_", ""))
	end

	id = nil
	
	Spring.Log("defs dumper", "error", "WeaponDefs:" .. #WeaponDefs)
	
	for id, def in pairs(WeaponDefs) do
		AddToResultTable(def, 'Weapon:' .. def.name or id)
	end
	
	-- sort the result
	local indexTable = {}, index
	for index, _ in pairs(mainTable) do
		table.insert(indexTable, index)
	end
	
	table.sort(indexTable)
	
	local rowName, rowValue
	
	local file = io.open(FILENAME, 'w')
	for _, rowName in ipairs(indexTable) do
		rowValue = mainTable[rowName]
		file:write(rowName .. ':' .. rowValue)
		file:write('\n')
	end

	file:close()
	
	WG.RemoveWidget(self)
end

function AddToResultTable(item, currentPath)
	local newItem, newItemName

	if type(item) == "table" then
		if type(item.pairs) == "function" then
			for newItemName, newItem in item:pairs() do
				AddToResultTable(newItem, currentPath .. '>' .. newItemName)
			end
		else
			for newItemName, newItem in pairs(item) do
				AddToResultTable(newItem, currentPath .. '>' .. newItemName)
			end
		end
	elseif type(item) == "function" then
		-- skip them
		--mainTable[currentPath] = 'function:' .. tostring(item)
	else
		mainTable[currentPath] = tostring(item)
	end
end
