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
  impulsefactor      = 0.1,
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
  range              = 535,
  reloadtime         = 1.7,
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

-- SVT (USSR)
local SVT = RifleClass:New{
  name               = [[SVT-40]],
  range              = 535,
  reloadtime         = 2,
  rgbColor           = [[0.0 0.7 0.0]], -- overwrites default
  soundStart         = [[RUS_SVT]],
}

-- Sniper Rifle Base Class
local SniperRifleClass = RifleClass:New{
  accuracy           = 0,
  explosionGenerator = [[custom:Bullet]],
  movingAccuracy     = 1777,
  range              = 1040,
  reloadtime         = 10,
  soundTrigger       = false,
  tolerance          = 2000,
  turret             = true,
  weaponType         = [[LaserCannon]],
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 90,
    fearid             = 401,
  },
  damage = {
    default              = 625,
    infantry             = 1700,
    sandbags             = 325,
  },
}

-- Implementations

-- SMLE No. 4 Mk. I (T) (GBR)
local Enfield_T = SniperRifleClass:New{
  name               = [[Lee-Enfield No. 4 Mk. I Scoped]],
  reloadtime         = 8.5,
  soundStart         = [[GBR_Enfield]],
}

-- Karabiner 98K Scope (GER)
local K98kScope = SniperRifleClass:New{
  name               = [[Karabiner 98k Scoped]],
  soundStart         = [[GER_K98K]],
}

-- M1903A4 Springfield (USA)
local M1903Springfield = SniperRifleClass:New{
  movingAccuracy     = 888, -- intended?
  name               = [[M1903A4 Springfield]],
  soundStart         = [[US_Springfield]],
}

-- Mosin Nagant M1890/30 PU (RUS)
local MosinNagantPU = SniperRifleClass:New{
  name               = [[Mosin-Nagant PU Scoped]],
  soundStart         = [[RUS_MosinNagant]],
}

-- Return only the full weapons
return lowerkeys({
  Enfield = Enfield,
  K98k = K98k,
  M1Garand = M1Garand,
  BAR = BAR,
  MosinNagant = MosinNagant,
  PartisanMosinNagant = PartisanMosinNagant,
  -- sniper weapons
  Enfield_T = Enfield_T,
  K98kScope = K98kScope,
  M1903Springfield = M1903Springfield,
  MosinNagantPU = MosinNagantPU,
  SVT = SVT,
})
