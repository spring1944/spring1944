-- Artillery - Light Howitzers

-- Howitzer Base Class
local HowitzerClass = Weapon:New{
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
local HowitzerHEClass = Weapon:New{
  name               = [[HE Shell]],
  customparams = {
    fearaoe            = 210,
    fearid             = 501,
  },
}

-- Smoke Round Class
local HowitzerSmokeClass = Weapon:New{
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


-- Type 91 105m howitzer L/24
local jap105mmtype99 = HowitzerClass:New{
  accuracy           = 1050,
  areaOfEffect       = 115,
  name               = [[Type 91 105mm/22]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 3800,
  },
}

-- Type 38 150m howitzer L/11
local jap150mmtype38 = HowitzerClass:New{
  accuracy           = 1050,
  areaOfEffect       = 145,
  name               = [[Type 38 150mm/11]],
  range              = 1650,
  reloadtime         = 15,
  damage = {
    default            = 5500,
  },
}

local jap105mmtype99_he = jap105mmtype99:New(HowitzerHEClass, true)
local jap105mmtype99_smoke = jap105mmtype99:New(HowitzerSmokeClass, true)
local jap150mmtype38_he = jap150mmtype38:New(HowitzerHEClass, true)
local jap150mmtype38_smoke = jap150mmtype38:New(HowitzerSmokeClass, true)

-- Return only the full weapons
return lowerkeys({
  jap105mmtype99_he = jap105mmtype99_he,
  jap105mmtype99_smoke = jap105mmtype99_smoke,
  jap150mmtype38_he = jap150mmtype38_he,
})
