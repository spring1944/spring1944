-- Artillery - Anti Aircraft Guns

-- AA Gun Base Class
local AAGunClass = Weapon:New{
  burnblow           = true,
  collisionSize      = 2,
  explosionSpeed     = 30,
  impulseFactor      = 0,
  intensity          = 0.9,
  predictBoost       = 0, -- this seems very strange for an AA weapon!
  size               = 1e-5,
  soundHitDry        = [[GEN_Explo_Flak1]],
  soundStart         = [[GEN_37mmAA]],
  sprayAngle         = 400,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    damagetype         = [[explosive]],
	cegflare           = "SMALL_MUZZLEFLASH", -- this class used mainly for ~40mm weapons
	flareonshot        = true,
  },
  
}

-- AA Round Class
local AAGunAAClass = Weapon:New{
  areaOfEffect       = 60,
  canattackground    = false,
  collisionSize      = 5,
  cylinderTargeting  = 2.5,
  edgeEffectiveness  = 0.001,
  explosionGenerator = [[custom:HE_Medium]],
  name               = [[AA Shell]],
  tolerance          = 1400,
  customparams = {
    no_range_adjust    = true,
    fearaoe            = 450,
    fearid             = 701,
  }
}

-- HE Round Class
local AAGunHEClass = Weapon:New{
  areaOfEffect       = 24,
  edgeEffectiveness  = 0.25,
  explosionGenerator = [[custom:HE_XSmall]],
  name               = [[HE Shell]],
  sprayAngle         = 0,
  tolerance          = 700,
  customparams = {
    fearaoe            = 45,
    fearid             = 301,
  },
}

return {
  AAGunClass = AAGunClass,
  AAGunHEClass = AAGunHEClass,
  AAGunAAClass = AAGunAAClass,
}
