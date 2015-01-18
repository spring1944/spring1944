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
    cegflare           = "MEDIUM_MUZZLEFLASH",
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

return {
  HowitzerClass = HowitzerClass,
  HowitzerHEClass = HowitzerHEClass,
  HowitzerSmokeClass = HowitzerSmokeClass,
}
