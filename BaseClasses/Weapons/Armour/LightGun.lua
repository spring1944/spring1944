-- Armour - Light Gun (37 to 45mm)

-- LightGun Base Class
local LightGunClass = Weapon:New{
  accuracy           = 100,
  collisionSize      = 4,
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 500, --590 for 2pdr?
  separation         = 2, 
  size               = 1,
  soundStart         = [[US_37mm]], -- move later?
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    cegflare           = "XSMALL_MUZZLEFLASH",
  }
}

-- HE Round Class
local LightGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:HE_Small]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 40,
    fearid             = 301,
  },
}

-- AP Round Class
local LightGunAPClass = Weapon:New{
  areaOfEffect       = 5,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Small]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- HEAT Round Class
local LightGunHEATClass = Weapon:New{
  collisionSize      = 3,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:EP_medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[HEAT Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[shapedcharge]],
  },
}

return {
  LightGunClass = LightGunClass,
  LightGunHEClass = LightGunHEClass,
  LightGunAPClass = LightGunAPClass,
  LightGunHEATClass = LightGunHEATClass,
}
