-- Smallarms - Infantry Sniper Rifles

-- Sniper Rifle Base Class
local SniperRifleClass = Weapon:New{
  areaOfEffect       = 2,
  avoidFeature       = true,
  avoidFriendly      = false,
  collideFeature     = true,
  collideFriendly    = false,
  collisionSize      = 3,
  explosionGenerator = [[custom:Bullet]],
  fireStarter        = 0,
  id                 = 9, -- used?
  impactonly         = 1,
  intensity          = 0.0001,
  interceptedByShieldType = 8,
  movingAccuracy     = 1777,
  range              = 1040,
  reloadtime         = 10,
  soundTrigger       = false,
  thickness          = 0.2,
  tolerance          = 2000,
  turret             = true,
  weaponType         = [[LaserCannon]],
  weaponVelocity     = 1500,
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
  reloadtime         = 8.5, -- intended?
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
  Enfield_T = Enfield_T,
  K98kScope = K98kScope,
  M1903Springfield = M1903Springfield,
  MosinNagantPU = MosinNagantPU,
})
