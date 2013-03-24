-- Artillery - Light Howitzers

-- Howitzer Base Class
local ObiceClass = Weapon:New{
  avoidFeature		 = false,
  collisionSize      = 4,
  edgeEffectiveness  = 0.15,
  explosionGenerator = [[custom:HE_Large]],
  explosionSpeed     = 30,
  gravityAffected    = true,
  impulseFactor      = 0,
  intensity          = 0.1,
  leadLimit          = 0.05,
  noSelfDamage       = true,
  rgbColor           = [[0.5 0.5 0.0]],
  separation         = 2,
  size               = 1,
  soundStart         = [[GEN_105mm]],
  soundHitDry        = [[GEN_Explo_4]],
  stages             = 50,
  targetMoveError    = 0.75,
  tolerance          = 3000,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 1200,
  customparams = {
    damagetype         = [[explosive]],
    howitzer           = 1,
  },
}

-- HE Round Class
local ObiceHEClass = Weapon:New{
  name               = [[HE Shell]],
  customparams = {
    fearaoe            = 210,
    fearid             = 501,
  },
}

-- Smoke Round Class
local ObiceSmokeClass = Weapon:New{
  areaOfEffect       = 30,
  name               = [[Smoke Shell]],
  customparams = {
    smokeradius        = 250,
    smokeduration      = 40,
    smokeceg           = [[SMOKESHELL_Medium]],
  },
  damage = {
    default = 100,
  } ,
}

-- Implementations


-- 100m howitzer L22 (ita)
local Obice100mmL22 = ObiceClass:New{
  accuracy           = 1050,
  areaOfEffect       = 115,
  name               = [[Obice 100mm/22 M14]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 3800,
  },
}
local Obice100mmL22he = Obice100mmL22:New(ObiceHEClass, true)
local Obice100mmL22smoke = Obice100mmL22:New(ObiceSmokeClass, true)

--  100mm Howitzer L17 (ita)
local Obice100mmL17 = ObiceClass:New{
  accuracy           = 1150,
  areaOfEffect       = 115,
  name               = [[Obice 100mm/17 M14]],
  range              = 6000,
  reloadtime         = 9.25,
  damage = {
    default            = 3800,
  },
}
local Obice100mmL17he = Obice100mmL17:New(ObiceHEClass, true)
local Obice100mmL17smoke = Obice100mmL17:New(ObiceSmokeClass, true)

-- Return only the full weapons
return lowerkeys({
  Obice100mmL22he = Obice100mmL22he,
  Obice100mmL22smoke = Obice100mmL22smoke,
  Obice100mmL17he = Obice100mmL17he,
  Obice100mmL17smoke = Obice100mmL17smoke,
})
