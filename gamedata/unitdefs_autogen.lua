local morphInclude = VFS.Include("LuaRules/Configs/morph_defs.lua")

local MORPH_DAMAGE = 1e+06
local MORPH_SLOPE = 82

local TIME_RATIO = 30.0 / 32.0

local function getTemplate(maxDamage, maxSlope)
	return  { -- can't use lowerkeys() here and needs to be lower case keys!
				acceleration = 0.1,
				brakerate = 1,
				buildcostenergy = 0,
				canmove = 1,
				category = "FLAG",
				explodeas = "noweapon",
				footprintx = 1,
				footprintz = 1,
				idleautoheal = 0,
				maxdamage = maxDamage,
				maxslope = maxSlope,
				maxvelocity = 0.01,
				movementclass = "KBOT_Infantry",
				objectname = "MortarShell.S3O",
				script = "null.cob",
				selfdestructas = "noweapon",
				sfxtypes = {
				},
				customparams = {
					isupgrade = true,
					dontcount = true,
				},
				stealth = 1,
				turnrate = 1,
			}
end

local function isFactory(unitDef)
	local yardmap = unitDef.yardmap
	local velocity = unitDef.maxVelocity or unitDef.maxvelocity
	local workerTime = unitDef.workerTime or unitDef.workertime
	return yardmap and (not velocity or velocity <= 0) and workerTime and workerTime > 0
end


for unitName, unitMorphs in pairs(morphInclude) do
	local unitDef = UnitDefs[unitName]
	if not unitDef then
		Spring.Echo("unitdefs_autogen.lua ERROR", unitName, unitDef) -- useful to debug bad/missing unitdefs causing this code to crash(!)
	elseif isFactory(unitDef) or unitName:lower():find("yard") then
		for i = 1, #unitMorphs do
			local unitMorphData = unitMorphs[i]
			local intoDef = UnitDefs[unitMorphData.into] or {}
			local autoUnit = getTemplate(MORPH_DAMAGE, MORPH_SLOPE)
			local autoUnitName = "morph_" .. unitName .. "_" .. unitMorphData.into
			local buildOptions = unitDef.buildoptions or unitDef.buildOptions or {}
			unitDef.buildoptions = buildOptions
			autoUnit.name = text
			--autoUnit.description = unitMorphData.text
			autoUnit.buildcostmetal = unitMorphData.metal
			autoUnit.buildpic = intoDef.buildpic
			autoUnit.buildtime = (unitDef.workerTime or unitDef.workertime) * unitMorphData.time * TIME_RATIO
			autoUnit.side = intoDef.side
			table.insert(buildOptions, autoUnitName)
			UnitDefs[autoUnitName] = autoUnit
		end
	end
end

