-- Artillery - Rocket Artillery

-- Rocket Artillery Base Class
local ArtyRocketClass = Weapon:New{
  avoidFeature		 = false,
  cegTag             = [[RocketTrail]],
  commandfire        = true,
  edgeEffectiveness  = 0.1,
  explosionSpeed     = 30,
  flightTime         = 10,
  gravityaffected    = true,
  impulseFactor      = 0,
  model              = [[KatyushaRocket.S3O]],
  reloadtime         = 45,
  soundHitDry        = [[GEN_Explo_5]],
  soundTrigger       = false,
  startVelocity      = 10,
  targetMoveError    = 0.1,
  tolerance          = 2000,
  trajectoryHeight   = 0.5,
  turret             = true,
  weaponAcceleration = 2000,
  weaponTimer        = 1,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 1400,
  customparams = {
    armor_hit_side     = [[top]],
    damagetype         = [[explosive]],
    fearaoe            = 200,
    fearid             = 501,
    howitzer           = 1,
	cegflare           = "dirt_backblast",
	flareonshot        = true,
  },
}

return {
  ArtyRocketClass = ArtyRocketClass,
}
