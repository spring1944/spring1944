-- Autogenerate Squad & Sortie spawner units
local defFields = {
	"name",
	"description",
	"buildcostmetal",
	"buildpic",
	"buildtime",
	"side",
	"objectname",
}

local units = {}

local sortieInclude = lowerkeys(VFS.Include("LuaRules/Configs/sortie_defs.lua"))
local squadInclude = lowerkeys(VFS.Include("LuaRules/Configs/squad_defs.lua"))

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