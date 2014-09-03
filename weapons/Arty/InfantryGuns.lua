-- Artillery - Infantry Guns

-- Infantry Gun Base Class
local InfGunClass = Weapon:New{
  accuracy           = 510,
  avoidFeature		 = false,
  collisionSize      = 4,
  edgeEffectiveness  = 0.25,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  fireStarter        = 0,
  gravityaffected    = true,
  impulseFactor      = 0,
  intensity          = 0.1,
  noSelfDamage       = true,
  range              = 1310,
  reloadtime         = 6.75,
  rgbColor           = [[0.5 0.5 0.0]],
  separation         = 2,
  size               = 1,
  soundHitDry        = [[GEN_Explo_3]],
  stages             = 50,
  targetMoveError    = 0.5, -- why different?
  tolerance          = 5000,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 825,
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 75,
    fearid             = 401,
  },
}

-- Implementations

-- LeIG 18 (GER)
local LeIG18HE = InfGunClass:New{
  areaOfEffect       = 88,
  name               = [[75mm LeIG 18 HE Shell]],
  soundStart         = [[GER_75mm]],
  damage = {
    default            = 1340,
  },
}

-- M8 Pack Howitzer (USA)
local M875mmHE = InfGunClass:New{
  areaOfEffect       = 94,
  name               = [[M8 75mm Pack Howitzer HE Shell]],
  soundStart         = [[US_75mm]],
  damage = {
    default            = 1620,
  },
}

-- Cannone da 65/17 (ITA)
local Cannone65L17HE = InfGunClass:New{
  areaOfEffect       = 68,
  name               = [[Cannone da 65/17 HE Shell]],
  range              = 1010,
  reloadtime         = 6.25,
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 420,
  damage = {
    default            = 900,
  },
}

local Cannone65L17HEAT = InfGunClass:New{
  areaOfEffect       = 8,
  explosionGenerator = [[custom:EP_medium]],
  name               = [[Cannone da 65/17 HEAT Shell]],
  range              = 715,
  reloadtime         = 6.25,
  soundHitDry        = [[GEN_Explo_2]],
  soundStart         = [[RUS_45mm]],
  weaponVelocity     = 320,
  customparams = {
    armor_penetration  = 85,
    damagetype         = [[shapedcharge]],
    fearaoe            = nil,
    fearid             = nil,
  },
  damage = {
    default            = 2056,
  },
}

-- Return only the full weapons
return lowerkeys({
  LeIG18HE = LeIG18HE,
  M875mmHE = M875mmHE,
  Cannone65L17HE = Cannone65L17HE,
  Cannone65L17HEAT = Cannone65L17HEAT,
})
