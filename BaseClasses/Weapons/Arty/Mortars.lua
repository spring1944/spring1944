-- Artillery - Mortars

-- Mortar Base Class
local MortarClass = Weapon:New{
  accuracy           = 485,
  avoidFeature       = false,
  collideFriendly    = false,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  impulseFactor      = 1e-07,
  leadLimit          = 500,
  model              = [[MortarShell.S3O]],
  reloadtime         = 12,
  size               = 1.5,
  soundHitDry        = [[GEN_Explo_3]],
  soundStart         = [[GEN_Mortar]],
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 550,
  customparams = {
    armor_hit_side     = [[top]],
    damagetype         = [[explosive]],
    cegflare           = [[MEDIUM_MUZZLEFLASH]],
    scriptanimation    = [[mortar]],
  },
}

-- HE Round Class
local MortarHEClass = Weapon:New{
  name               = [[HE Shell]],
  customparams = {
    fearaoe            = 105,
    fearid             = 301,
  },
}

-- Smoke Round Class
local MortarSmokeClass = Weapon:New{
  areaOfEffect       = 20,
  name               = [[Smoke Shell]],
  customparams = {
    smokeradius        = 160,
    smokeduration      = 25,
    smokeceg           = [[SMOKESHELL_Small]],
  },
  damage = {
    default = 100,
  } ,
}

return {
  MortarClass = MortarClass,
  MortarHEClass = MortarHEClass,
  MortarSmokeClass = MortarSmokeClass,
}
