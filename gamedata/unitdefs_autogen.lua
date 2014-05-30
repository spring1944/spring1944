
local defFields = {
    "name",
    "description",
    "buildCostMetal",
    "buildPic",
    "buildTime",
    "side",
}

local sortieInclude = VFS.Include("LuaRules/Configs/sortie_defs.lua")

local squadInclude = VFS.Include("LuaRules/Configs/squad_defs.lua")

local SORTIE_DAMAGE = 1e+06
local SORTIE_SLOPE = 82

local SQUAD_DAMAGE = 100
local SQUAD_SLOPE = 30


local function getTemplate(maxDamage, maxSlope)
    return  {
                acceleration = 0.1,
                brakeRate = 1,
                buildCostEnergy=0,
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
            }
end

local function generateFrom(defFile, damage, slope)
    for unitName, unitData in pairs(defFile) do
        local autoUnit = getTemplate(damage, slope)
        for i = 1, #defFields do
            autoUnit[defFields[i]] = unitData[defFields[i]]
        end
        UnitDefs[unitName] = autoUnit
    end
end

generateFrom(sortieInclude, SORTIE_DAMAGE, SORTIE_SLOPE)

generateFrom(squadInclude, SQUAD_DAMAGE, SQUAD_SLOPE)

