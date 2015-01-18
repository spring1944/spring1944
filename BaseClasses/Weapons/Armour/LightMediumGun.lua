-- Armour - Light-Medium Gun (50 to 57mm)

-- LightMediumGun Base Class
local LightMediumGunClass = Weapon:New{
  accuracy           = 100,
  avoidFeature		 = false,
  collisionSize      = 4,
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 600,
  separation         = 2, 
  size               = 1,
  soundStart         = [[GER_50mm]], -- move later?
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    cegflare           = "MEDIUMSMALL_MUZZLEFLASH",
  }
}

-- HE Round Class
local LightMediumGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.25,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 50,
    fearid             = 301,
  },
}

-- AP Round Class
local LightMediumGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Medium]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

return {
  LightMediumGunClass = LightMediumGunClass,
  LightMediumGunHEClass = LightMediumGunHEClass,
  LightMediumGunAPClass = LightMediumGunAPClass,
}
