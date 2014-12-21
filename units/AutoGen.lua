-- Autogenerate Squad & Sortie spawner units
local defFields = {
	"name",
	"description",
	"buildCostMetal",
	"buildPic",
	"buildTime",
	"side",
	"objectName",
}

local units = {}

local sortieInclude = VFS.Include("LuaRules/Configs/sortie_defs.lua")
local squadInclude = VFS.Include("LuaRules/Configs/squad_defs.lua")

local function generateFrom(defFile)
	for unitName, unitData in pairs(defFile) do
		local autoUnit = Null:New{}
		for i = 1, #defFields do
			if unitData[defFields[i]] then
				autoUnit[defFields[i]] = unitData[defFields[i]]
			end
		end
		units[unitName] = autoUnit
	end
end

generateFrom(sortieInclude)
generateFrom(squadInclude)

return lowerkeys(units)