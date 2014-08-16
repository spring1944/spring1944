-- heavyguns

-- Heavies Base Class
local heavygunClass = Weapon:New{
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
  weaponVelocity     = 700,
  customparams = {
    damagetype         = [[explosive]],
  },
}

-- HE Round Class
local heavygunHEClass = Weapon:New{
  name               = [[HE Shell]],
  customparams = {
    fearaoe            = 300,
    fearid             = 501,
  },
}

-- Smoke Round Class
local heavygunSmokeClass = Weapon:New{
  areaOfEffect       = 30,
  name               = [[Smoke Shell]],
  customparams = {
    smokeradius        = 350,
    smokeduration      = 50,
    smokeceg           = [[SMOKESHELL_Medium]],
  },
  damage = {
    default = 100,
  } ,
}

-- Implementations


-- short120mm
local jpnshort120mm = heavygunClass:New{
  accuracy           = 300,
  areaOfEffect       = 129,
  name               = [[Short naval 120mm]],
  range              = 1720,
  reloadtime         = 11.25,
  damage = {
    default            = 5800,
  },
}

-- Type 38 150mm howitzer L/11
local jpn150mmtype38 = heavygunClass:New{
  accuracy           = 300,
  areaOfEffect       = 165,
  name               = [[Type 38 150mm/11]],
  soundStart         = [[150mmtype38]],
  soundHitDry        = [[GEN_Explo_6]],
  range              = 1700,
  reloadtime         = 15,
  damage = {
    default            = 8500,
  },
}

local jpnshort120mm_he = jpnshort120mm:New(heavygunHEClass, true)

local jpn150mmtype38_he = jpn150mmtype38:New(heavygunHEClass, true)
local jpn150mmtype38_smoke = jpn150mmtype38:New(heavygunSmokeClass, true)

-- Return only the full weapons
return lowerkeys({
  jpnshort120mm_he = jpnshort120mm_he,
  jpn150mmtype38_he = jpn150mmtype38_he,
  jpn150mmtype38_smoke = jpn150mmtype38_smoke,
})
