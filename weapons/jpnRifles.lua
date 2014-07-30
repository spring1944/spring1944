-- Smallarms - Infantry Rifles

-- Rifle Base Class
local rifleClass = Weapon:New{
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
  thickness          = 0.2,
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

-- Arisaka type 99
local Arisaka99 = rifleClass:New{
  accuracy           = 95, -- overwrites default
  name               = [[Arisaka Type 99]],
  range              = 630,
  reloadtime         = 2.5,
  soundStart         = [[JPN_Arisaka_Type99]],
}

-- Sniper
local ArisakaSniper = rifleClass:New{
  name               = [[Arisaka Type 99 Sniper Model]],
  id                 = 9,
  reloadtime         = 10,
  range              = 1040,
  soundStart         = [[JPN_Arisaka_Type99]],
    customparams = {
    fearaoe            = 90,
    fearid             = 401,
  },
  damage = {
    default              = 625,
    infantry             = 1700,
    sandbags             = 325,
  }
}

-- Return only the full weapons
return lowerkeys({
  Arisaka99 = Arisaka99,
  Arisaka99Sniper = ArisakaSniper,
})
