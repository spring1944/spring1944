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

if Spring then
	local sortieInclude = VFS.Include("LuaRules/Configs/sortie_defs.lua")
	local squadInclude = VFS.Include("LuaRules/Configs/squad_defs.lua")

	local function generateFrom(defFile)
		for unitName, unitData in pairs(defFile) do
			Unit(unitName):Extends('Null'):Attrs(unitData)
		end
	end

	generateFrom(sortieInclude)
	generateFrom(squadInclude)
else
	-- CLI interface
	io.output(io.stderr):write("skipping units/AutoGen.lua, no sortie or squad units are present in DB\n")
end
