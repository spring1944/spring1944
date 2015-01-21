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
	cegflare           = "RIFLE_MUZZLEFLASH",
  },
  damage = {
    default            = 33,
  },
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


return {
  RifleClass = RifleClass,
  SniperRifleClass = SniperRifleClass,
}
