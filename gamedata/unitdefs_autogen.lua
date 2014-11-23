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
                stealth = 1,
                turnrate = 1,
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
            autoUnit.buildtime = (unitDef.workerTime or unitDef.workertime) * unitMorphData.time * TIME_RATIO
            autoUnit.side = intoDef.side
            autoUnit.customParams = { isupgrade = true }
            table.insert(buildOptions, autoUnitName)
            UnitDefs[autoUnitName] = autoUnit
        end
    end
end

