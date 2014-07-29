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
  },
}

-- Implementations

-- Type 4 200mm rocket mortar
local jpntype4rocketmortar = ArtyRocketClass:New{
  areaOfEffect       = 203,
  reloadtime         = 15,
  explosionGenerator = [[custom:HE_XLarge]],
  name               = [[Type 4 200mm unguided artillery rocket]],
  range              = 3200,
  soundStart         = [[GER_Nebelwerfer]],
  wobble             = 1300,
  damage = {
    default            = 6000,
  },
}

local jpntype4rocketmortar_smoke = ArtyRocketClass:New{
  areaOfEffect       = 30,
  reloadtime         = 15,
  customparams = {
    smokeradius        = 350,
    smokeduration      = 50,
    smokeceg           = [[SMOKESHELL_Medium]],
  },
  name               = [[Type 4 200mm unguided artillery smoke rocket]],
  range              = 3200,
  soundStart         = [[GER_Nebelwerfer]],
  wobble             = 1300,
  damage = {
    default            = 100,
  },
}

-- Return only the full weapons
return lowerkeys({
  jpntype4rocketmortar_he = jpntype4rocketmortar,
  jpntype4rocketmortar_smoke = jpntype4rocketmortar_smoke,
})
