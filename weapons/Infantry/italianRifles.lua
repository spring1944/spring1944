-- Smallarms - Infantry Rifles

-- Rifle Base Class
local fusileClass = Weapon:New{
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
    default            = 30,
  },
}

-- Implementations

-- carcano 91_38
local Mod91 = fusileClass:New{
  accuracy           = 95, -- overwrites default
  name               = [[Carcano Mod.91/38]],
  range              = 610,
  reloadtime         = 2.5,
  soundStart         = [[ITA_CarcanoM91]],
}

-- carcano 91_41
local Mod91_41 = Mod91:New{
	accuracy           = 65,
  name               = [[Carcano Mod.91/41]],
  range              = 640,
}

-- Mod91Sniper
local Mod91Sniper = fusileClass:New{
  name               = [[Carcano Mod.91 Sniper Model]],
  range              = 510,
  id                 = 9,
  reloadtime         = 10,
  range              = 1040,
  soundStart         = [[ITA_CarcanoM91]],
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

-- breda 30
local Breda30 = fusileClass:New{
  burst              = 3,
  accuracy           = 220,
  burstrate          = 0.1,
  movingAccuracy     = 2667,
  name               = [[Breda 30 Light Machine Gun]],
  range              = 675,
  reloadtime         = 2.6,
  soundStart         = [[ITA_Breda30]],
  sprayAngle         = 260,
  customparams = {
    fearaoe            = 45,
    fearid             = 301,
  },
}

-- Return only the full weapons
return lowerkeys({
  Mod91 = Mod91,
  Mod91_41 = Mod91_41,
  Mod91Sniper = Mod91Sniper,
  Breda30 = Breda30,
})
