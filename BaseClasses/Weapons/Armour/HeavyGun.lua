-- Armour - Heavy Gun (120 to 152mm)

-- HeavyGun Base Class
local HeavyGunClass = Weapon:New{
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
}

-- HE Round Class
local HeavyGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:HE_XLarge]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_4]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 75,
    fearid             = 501,
  },
}

-- AP Round Class
local HeavyGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Large]],
  explosionSpeed     = 100, -- needed?
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- Smoke Round Class
local HeavyGunSmokeClass = HeavyGunHEClass:New{
  areaOfEffect       = 30,
  explosionGenerator = [[custom:HE_Large]],
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

return {
  HeavyGunClass = HeavyGunClass,
  HeavyGunHEClass = HeavyGunHEClass,
  HeavyGunAPClass = HeavyGunAPClass,
  HeavyGunSmokeClass = HeavyGunSmokeClass,
}
