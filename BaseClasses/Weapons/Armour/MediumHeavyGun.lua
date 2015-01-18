-- Armour - Medium Heavy Gun (85 to 100mm)

-- MediumHeavyGun Base Class
local MediumHeavyGunClass = Weapon:New{
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
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    cegflare           = "MEDIUM_MUZZLEFLASH",
  }
}

-- HE Round Class
local MediumHeavyGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.15,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_3]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 75,
    fearid             = 401,
  },
}

-- AP Round Class
local MediumHeavyGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Large]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- HEAT Round Class
local MediumHeavyGunHEATClass = Weapon:New{
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:EP_Large]],
  explosionSpeed     = 30, -- needed?
  name               = [[HEAT Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_3]],
  customparams = {
    damagetype         = [[shapedcharge]],
  },
}

return {
  MediumHeavyGunClass = MediumHeavyGunClass,
  MediumHeavyGunHEClass = MediumHeavyGunHEClass,
  MediumHeavyGunAPClass = MediumHeavyGunAPClass,
  MediumHeavyGunHEATClass = MediumHeavyGunHEATClass,
}
