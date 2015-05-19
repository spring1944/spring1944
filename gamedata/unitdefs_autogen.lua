local morphInclude = VFS.Include("LuaRules/Configs/morph_defs.lua")

local MORPH_DAMAGE = 1e+06
local MORPH_SLOPE = 82

local function getTemplate(maxDamage, maxSlope)
	return	{
				acceleration = 0.1,
				brakeRate = 1,
				buildCostEnergy = 0,
				canMove = 1,
				category = "FLAG",
				explodeAs = "noweapon",
				footprintX = 1,
				footprintZ = 1,
				idleAutoHeal = 0,
				maxDamage = maxDamage,
				maxSlope = maxSlope,
				maxVelocity = 0.01,
				movementClass = "KBOT_Infantry",
				objectName = "MortarShell.S3O",
				script = "null.cob",
				selfDestructAs = "noweapon",
				sfxtypes = {
				},
				stealth = 1,
				turnRate = 1,
				
				customparams = {
					dontCount			= 1,
				},
			}
end

local function isFactory(unitDef)
	local buildOptions = unitDef.buildoptions or unitDef.buildOptions
	local velocity = unitDef.maxVelocity or unitDef.maxvelocity
	return buildOptions and (not velocity or velocity == 0)
end


for unitName, unitMorphs in pairs(morphInclude) do
	local unitDef = UnitDefs[unitName]
	if isFactory(unitDef) then
		for i = 1, #unitMorphs do
			local unitMorphData = unitMorphs[i]
			local intoDef = UnitDefs[unitMorphData.into]
			local autoUnit = getTemplate(MORPH_DAMAGE, MORPH_SLOPE)
			local autoUnitName = "morph_" .. unitName .. "_" .. unitMorphData.into
			local buildOptions = unitDef.buildoptions or unitDef.buildOptions
			autoUnit.name = text
			--autoUnit.description = unitMorphData.text
			autoUnit.buildcostmetal = unitMorphData.metal
			autoUnit.buildpic = intoDef.buildpic
			autoUnit.buildtime = (unitDef.workerTime or unitDef.workertime) * unitMorphData.time
			autoUnit.side = intoDef.side
			autoUnit.customParams = { isupgrade = true }
			table.insert(buildOptions, autoUnitName)
			UnitDefs[autoUnitName] = autoUnit
		end
	end
end

