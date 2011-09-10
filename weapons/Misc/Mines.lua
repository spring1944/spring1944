-- Misc - Mines

-- Mine Base Class
local MineClass = Weapon:New{
  explosionGenerator = [[custom:HE_Large]],
  explosionSpeed     = 30,
  fireSubmersed      = true,
  soundHit           = [[GEN_Explo_4]],
  turret             = true,
  weaponVelocity     = 90,
  customparams = {
    damagetype         = [[explosive]], 
  },
  damage = {
    mines              = 0,
  },
}

-- Implementations

-- Anti-Personnel Mine
local APMine = MineClass:New{
  areaOfEffect       = 88,
  explosionGenerator = [[custom:HE_Medium]], -- overrides default
  impulseFactor      = 0.1,
  name               = [[Anti-Personnel Mine]],
  range              = 25,
  soundHit           = [[GEN_Explo_1]],
  damage = {
    default            = 400,
  },
}

-- Anti-Tank Mine
local ATMine = MineClass:New{
  areaOfEffect       = 46,
  name               = [[Anti-Tank Mine]],
  range              = 35,
  customparams = {
    armor_hit_side     = [[top]],
    armor_penetration  = 100,
    damagetype         = [[shapedcharge]], -- overrides default
  },
  damage = {
    default            = 10000,
  },
}

-- Satchel Charge (GBR)
local SatchelCharge = MineClass:New{
  areaOfEffect       = 104,
  edgeEffectiveness  = 1,
  name               = [[Satchel Charge]],
  customparams = {
    fearaoe            = 210,
    fearid             = 501,
  },
  damage = {
    default            = 16000,
  },
}

-- Return only the full weapons
return lowerkeys({
  APMine = APMine,
  ATMine = ATMine,
  SatchelCharge = SatchelCharge,
})
