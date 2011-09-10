-- Flamethrowers

-- Flamethrower Class
local FlamerClass = Weapon:New{
    burstrate          = 0.05,
    cegTag             = [[Flametrail]],
    edgeEffectiveness  = 0.25,
    explosionGenerator = [[custom:Flamethrower]],
    explosionSpeed     = 0.01,
    fireStarter        = 100,
    groundbounce       = false,
    id                 = 76, -- needed?
    impulseFactor      = 1e-06,
    reloadtime         = 1,
    size               = 0.01,
    soundStart         = [[GEN_Flamethrower]],
    soundTrigger       = true,
    sprayAngle         = 500,
    tolerance          = 200,
    turret             = true,
    weaponType         = [[Cannon]], -- apparantly so?!
    weaponVelocity     = 240,
    customparams = {
      ceg                = [[Flamethrower]],
      damagetime         = 15,
      damagetype         = [[fire]],
      fearid             = 501,
    },
    damage = {
      default            = 20,
    },
}

-- Implementations

-- Wasp Flamethrower (GBR)
local WaspFlamethrower = FlamerClass:New{
  areaOfEffect       = 90,
  burst              = 10,
  name               = [[Wasp Flamethrower]],
  range              = 300,
  customparams = {
    fearaoe            = 75,
  },
}

-- M2 Flamethrower (USA)
local M2Flamethrower = FlamerClass:New{
  areaOfEffect       = 80,
  burst              = 5,
  name               = [[M2-2 Flamethrower]],
  range              = 210,
  customparams = {
    fearaoe            = 60,
  },
}

-- Return only the full weapons
return lowerkeys({
  WaspFlamethrower = WaspFlamethrower,
  M2Flamethrower = M2Flamethrower,
})
