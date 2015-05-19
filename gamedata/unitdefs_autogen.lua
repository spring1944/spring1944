local morphInclude = VFS.Include("LuaRules/Configs/morph_defs.lua")

local function getTemplate()
	return  	{
					canmove = true, -- required to pass orders
					category = "FLAG",
					explodeas = "noweapon",
					footprintx = 1,
					footprintz = 1,
					idleautoheal = 0,
					maxdamage = 1e+06,
					maxvelocity = 0.01,
					movementclass = "KBOT_Infantry", -- as is this
					objectname = "GEN/Null.S3O",
					script = "null.lua",
					selfdestructas = "noweapon",
					shownanoframe			= false,
					shownanospray			= false,
					stealth = true,
					
					customparams = {
						isupgrade			= true,
						dontcount			= 1,
					},
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
	elseif isFactory(unitDef) then
		for i = 1, #unitMorphs do
			local unitMorphData = unitMorphs[i]
			local intoDef = UnitDefs[unitMorphData.into] or {}
			local autoUnit = getTemplate()
			local autoUnitName = "morph_" .. unitName .. "_" .. unitMorphData.into
			local buildOptions = unitDef.buildoptions or unitDef.buildOptions or {}
			unitDef.buildoptions = buildOptions
			autoUnit.name = text
			--autoUnit.description = unitMorphData.text
			autoUnit.buildcostmetal = unitMorphData.metal
			autoUnit.buildpic = intoDef.buildpic
			autoUnit.buildtime = (unitDef.workerTime or unitDef.workertime) * unitMorphData.time
			autoUnit.side = intoDef.side
			table.insert(buildOptions, autoUnitName)
			UnitDefs[autoUnitName] = autoUnit
		end
	end
end
