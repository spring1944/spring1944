-- Artillery - Infantry Guns

-- Infantry Gun Base Class
local InfGunClass = Weapon:New{
  accuracy           = 510,
  avoidFeature		 = false,
  collisionSize      = 4,
  edgeEffectiveness  = 0.25,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  fireStarter        = 0,
  gravityaffected    = true,
  impulseFactor      = 0,
  intensity          = 0.1,
  noSelfDamage       = true,
  range              = 1310,
  reloadtime         = 6.75,
  rgbColor           = [[0.5 0.5 0.0]],
  separation         = 2,
  size               = 1,
  soundHitDry        = [[GEN_Explo_3]],
  stages             = 50,
  targetMoveError    = 0.5, -- why different?
  tolerance          = 5000,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 825,
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 75,
    fearid             = 401,
  },
}

return {
  InfGunClass = InfGunClass,
}
