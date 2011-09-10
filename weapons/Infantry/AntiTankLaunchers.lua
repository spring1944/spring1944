-- Infantry Anti-Tank Launchers

-- AT Launcher Base Class
local ATLClass = Weapon:New{
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  impulseFactor      = 0,
  model              = [[Bomb_Tiny.S3O]],
  noSelfDamage       = true,
  soundHit           = [[GEN_Explo_3]],
  tolerance          = 6000,
  turret             = true,
  customparams = {
    damagetype         = [[shapedcharge]],
  },
}

-- Recoilless Rifle (& Spigot Mortar) Class
local RCL_ATLClass = ATLClass:New{
  accuracy           = 500,
  collisionSize      = 3,
  reloadtime         = 15,
  weaponType         = [[Cannon]],
  weaponVelocity     = 400,
}

-- Rocket Launcher Class
local Rocket_ATLClass = ATLClass:New{
  areaOfEffect       = 32,
  cegTag             = [[BazookaTrail]],
  flightTime         = 1,
  gravityaffected    = true,
  reloadtime         = 10,
  startVelocity      = 10,
  weaponAcceleration = 2000,
  weaponTimer        = 1,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 1000,
}

-- Implementations
-- RCL & Spigot Mortar
-- PIAT(GBR)
local PIAT = RCL_ATLClass:New{
  areaOfEffect       = 46,
  edgeEffectiveness  = 0.8,
  name               = [[P.I.A.T.]],
  range              = 245,
  soundStart         = [[GBR_PIAT]],
  targetMoveError    = 0.02,
  customparams = {
    armor_penetration  = 100,
  },
  damage = {
    default            = 8800,
  },
}

-- Panzerfasut 60 (GER)
local Panzerfaust = RCL_ATLClass:New{
  areaOfEffect       = 55,
  edgeEffectiveness  = 0.01, -- ?
  name               = [[Panzerfaust 60]],
  range              = 235,
  soundStart         = [[GER_Panzerfaust]],
  targetMoveError    = 0.1,
  customparams = {
    armor_penetration  = 170, -- wiki says 200?
  },
  damage = {
    default            = 6400, -- less than PIAT?
  }, 
}

-- Rocket Launchers
local Panzerschrek = Rocket_ATLClass:New{
  name               = [[RPzB 54/1 Panzerschrek]],
  range              = 360,
  soundStart         = [[GER_Panzerschrek]],
  targetMoveError    = 0.1,
  customparams = {
    armor_penetration  = 200,
  },
  damage = {
    default            = 5280, -- same as bazooka?
  },
}

-- M9A1 Bazooka (USA)
local M9A1Bazooka = Rocket_ATLClass:New{
  name               = [[M9A1 Bazooka]],
  range              = 270,
  soundStart         = [[US_Bazooka]],
  targetMoveError    = 0.075,
  customparams = {
    armor_penetration  = 108,
  },
  damage = {
    default            = 5280,
  },
}

-- Return only the full weapons
return lowerkeys({
  -- RCL / Spigot Mortar
  PIAT = PIAT,
  Panzerfaust = Panzerfaust,
  -- Rockets
  Panzerschrek = Panzerschrek,
  M9A1Bazooka = M9A1Bazooka,
})
