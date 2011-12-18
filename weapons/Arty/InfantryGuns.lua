-- Artillery - Infantry Guns

-- Infantry Gun Base Class
local InfGunClass = Weapon:New{
  accuracy           = 150,
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
  soundHit           = [[GEN_Explo_3]],
  stages             = 50,
  targetMoveError    = 0.5, -- why different?
  tolerance          = 5000,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 700,
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

-- M8 Pack Howitzer (GER)
local M875mmHE = InfGunClass:New{
  areaOfEffect       = 94,
  name               = [[M8 75mm Pack Howitzer HE Shell]],
  soundStart         = [[US_75mm]],
  damage = {
    default            = 1620,
  },
}

-- Return only the full weapons
return lowerkeys({
  LeIG18HE = LeIG18HE,
  M875mmHE = M875mmHE,
})
