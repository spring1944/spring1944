-- Smallarms - Infantry Rifles

-- Rifle Base Class
local RifleClass = Weapon:New{
  accuracy           = 100,
  areaOfEffect       = 1,
  avoidFeature       = true,
  avoidFriendly      = false,
  collideFeature     = true,
  collideFriendly    = false,
  collisionSize      = 2.5,
  coreThickness      = 0.15,
  duration           = 0.01,
  explosionGenerator = [[custom:Bullet]],
  fireStarter        = 0,
  id                 = 2, -- used for cob based fear from rifle/smg
  impactonly         = 1,
  intensity          = 0.9,
  interceptedByShieldType = 8,
  laserFlareSize     = 0.0001,
  movingAccuracy     = 888,
  rgbColor           = [[1.0 0.75 0.0]],
  sprayAngle         = 100,
  thickness          = 0.4,
  tolerance          = 6000,
  turret             = true,
  weaponType         = [[LaserCannon]],
  weaponVelocity     = 1500,
  customparams = {
    damagetype         = [[smallarm]],
  },
  damage = {
    default            = 33,
  },
}

-- Implementations

-- SMLE No. 4 Mk. I (GBR)
local Enfield = RifleClass:New{
  accuracy           = 50, -- overwrites default
  name               = [[Lee-Enfield No. 4 Mk. I]],
  range              = 680,
  reloadtime         = 2.5,
  soundStart         = [[GBR_Enfield]],
}

-- Karabiner 98K (GER)
local K98k = RifleClass:New{
  name               = [[Karabiner 98k]],
  range              = 665,
  reloadtime         = 2.8,
  soundStart         = [[GER_K98K]],
}

-- M1 Garand (USA)
local M1Garand = RifleClass:New{
  name               = [[M1 Garand]],
  range              = 510,
  reloadtime         = 1.8,
  soundStart         = [[US_M1garand]],
}

-- M1918A2 BAR (USA) (Possibly a little fudged in here)
local BAR = RifleClass:New{
  burst              = 3,
  burstrate          = 0.1,
  movingAccuracy     = 2667,
  name               = [[Browning Automatic Rifle]],
  range              = 710,
  reloadtime         = 2.25,
  soundStart         = [[US_BAR]],
  sprayAngle         = 300,
  customparams = {
    fearaoe            = 45,
    fearid             = 301,
  },
}

-- Mosin Nagant M1890/30 (RUS)
local MosinNagant = RifleClass:New{
  name               = [[Mosin-Nagant]],
  range              = 660,
  reloadtime         = 3,
  rgbColor           = [[0.0 0.7 0.0]], -- overwrites default
  soundStart         = [[RUS_MosinNagant]],
}

-- Mosin Nagant for puny partisan
-- derives from the above MosinNagant
local PartisanMosinNagant = MosinNagant:New{
  accuracy           = 225,
  movingAccuracy     = 1800,
}

-- Return only the full weapons
return lowerkeys({
  Enfield = Enfield,
  K98k = K98k,
  M1Garand = M1Garand,
  BAR = BAR,
  MosinNagant = MosinNagant,
  PartisanMosinNagant = PartisanMosinNagant,
})
