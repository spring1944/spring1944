-- Aircraft - Air Launched Rockets

-- AirRocket Base Class
local AirRocketClass = Weapon:New{
  cegTag             = [[BazookaTrail]],
  collideFriendly    = false,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  flightTime         = 2,
  gravityaffected    = true,
  impulseFactor      = 0,
  leadLimit		= 0,
  model              = [[Rocket_HVAR.S3O]],
  soundHitDry        = [[GEN_Explo_2]],
  soundStart         = [[GER_Panzerschrek]],
  startVelocity      = 600,
  tolerance          = 300,
  turret             = true,
  weaponAcceleration = 2000,
  weaponTimer        = 1,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 850,
  wobble             = 500,
  customparams = {
    no_range_adjust    = true,

  },
}

return {
  AirRocketClass = AirRocketClass,
}
