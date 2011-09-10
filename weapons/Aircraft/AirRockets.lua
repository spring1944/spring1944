-- Aircraft - Air Launched Rockets

-- AirRocket Base Class
local AirRocketClass = Weapon:New{
  cegTag             = [[BazookaTrail]],
  collideFriendly    = false,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  flightTime         = 2,
  gravityaffected    = true,
  model              = [[Rocket_HVAR.S3O]],
  soundHit           = [[GEN_Explo_2]],
  soundStart         = [[GER_Panzerschrek]],
  startVelocity      = 600,
  tolerance          = 300,
  turret             = true,
  weaponAcceleration = 2000,
  weaponTimer        = 1,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 850,
  wobble             = 1500,
  customparams = {
    armor_hit_side     = [[top]],
    damagetype         = [[shapedcharge]],
  },
}

-- Implementations

-- British rocket, typhoon currently uses HVAR

-- HVAR Rocket (USA)
local HVARRocket = AirRocketClass:New{
  areaOfEffect       = 64,
  name               = [[5-Inch HVAR Rockets]],
  range              = 1500,
  reloadtime         = 5,
  customparams = {
    armor_penetration  = 38,
  },
  damage = {
    default            = 7000,
  },
}

-- Return only the full weapons
return lowerkeys({
  HVARRocket = HVARRocket,
})
