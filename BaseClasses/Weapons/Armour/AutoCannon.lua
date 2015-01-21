-- Artillery - Auto Cannon (Light AA Guns)

-- AC Base Class
local ACClass = Weapon:New{
  collisionSize      = 2,
  edgeEffectiveness  = 0.5,
  explosionSpeed     = 100, -- needed?
  impulseFactor      = 0,
  movingAccuracy     = 500,
  predictBoost       = 0,
  size               = 1e-13, -- visuals done with tracers, except AP rounds
  soundHitDry        = [[GEN_Explo_1]],
  targetMoveError    = 0.1,
  tolerance          = 700,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
	cegflare           = "XSMALL_MUZZLEFLASH",
	flareonshot        = true,
  },
}

-- AA Round Class
local ACAAClass = Weapon:New{
  accuracy           = 0,
  burnblow           = true,
  areaOfEffect       = 30,
  canattackground    = false,
  collisionSize      = 5,
  explosionGenerator = [[custom:HE_Small]],
  movingAccuracy     = 0,
  name               = [[AA Shell]],
  soundHitDry        = [[GEN_Explo_Flak1]],
  targetMoveError    = 0,
  tolerance          = 1400,
  customparams = {
    damagetype         = [[explosive]],
    no_range_adjust    = true,
    fearaoe            = 450,
    fearid             = 701,
  },
}

-- HE Round Class
local ACHEClass = Weapon:New{
  areaOfEffect       = 24,
  explosionGenerator = [[custom:HE_XSmall]],
  name               = [[HE Shell]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 40, -- flak 38 was 45?
    fearid             = 301,
  },
}

-- AP Round Class
local ACAPClass = Weapon:New{
  areaOfEffect       = 2,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  explosionGenerator = [[custom:AP_XSmall]],
  intensity          = 0.1,
  name               = [[AP Shell]],
  separation         = 2,
  size               = 1,  
  stages             = 50,
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

return {
  ACClass = ACClass,
  ACAAClass = ACAAClass,
  ACHEClass = ACHEClass,
  ACAPClass = ACAPClass,
}
