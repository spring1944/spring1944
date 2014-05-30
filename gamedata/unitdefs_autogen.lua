
local defFields = {
    "name",
    "description",
    "buildCostMetal",
    "buildPic",
    "buildTime",
    "side",
}

local sortieInclude = VFS.Include("LuaRules/Configs/sortie_defs.lua")

local function getTemplate()
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
                maxDamage = 1e+06,
                maxSlope = 82,
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


for sortieUnitName, sortie in pairs(sortieInclude) do
    local autoUnit = getTemplate()
    for i = 1, #defFields do
        autoUnit[defFields[i]] = sortie[defFields[i]]
    end
    UnitDefs[sortieUnitName] = autoUnit
end
