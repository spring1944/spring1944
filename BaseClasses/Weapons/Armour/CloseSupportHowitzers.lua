-- Armour - Close-Support Howitzers

-- CSHowitzer Base Class
local CSHowitzerClass = Weapon:New{
  accuracy           = 300,
  avoidFeature		 = false,
  collisionSize      = 4,
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 600,
  separation         = 2, 
  size               = 1,
  soundHitDry        = [[GEN_Explo_4]],
  soundStart         = [[GEN_105mm]], -- move later?
  stages             = 50,
  targetMoveError    = 0.75,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 1000,
  
  customParams = {
    cegflare           = "LARGE_MUZZLEFLASH",
  },
}

-- HE Round Class
local CSHowitzerHEClass = Weapon:New{
  explosionGenerator = [[custom:HE_Large]],
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 125,
    fearid             = 501,
  },
}

-- Smoke Round Class
local CSHowitzerSmokeClass = Weapon:New{
  areaOfEffect       = 30,
  explosionGenerator = [[custom:HE_Medium]],
  name               = [[Smoke Shell]],
  damage = {
    default            = 100,
  },
  customparams = {
    damagetype         = [[explosive]],
	smokeradius        = 250,
    smokeduration      = 40,
    smokeceg           = [[SMOKESHELL_Medium]],
  },  
}

return {
  CSHowitzerClass = CSHowitzerClass,
  CSHowitzerHEClass = CSHowitzerHEClass,
  CSHowitzerSmokeClass = CSHowitzerSmokeClass,
}
