-- Smallarms - Infantry Pistols

-- Pistol Base Class
local PistolClass = Weapon:New{
  areaOfEffect       = 1,
  avoidFeature       = true,
  avoidFriendly      = false,
  collideFeature     = true,
  collideFriendly    = false,
  collisionSize      = 2.5,
  coreThickness      = 0.15,
  duration           = 0.025,
  explosionGenerator = [[custom:Bullet]],
  fireStarter        = 0,
  id                 = 1, -- used?
  impactonly         = 1,
  intensity          = 0.0001,
  interceptedByShieldType = 8,
  laserFlareSize     = 0.0001,
  movingAccuracy     = 888,
  range              = 180,
  reloadtime         = 1.5,
  --rgbColor           = [[1.0 0.75 0.0]],
  soundTrigger       = false,
  thickness          = 0.2,
  tolerance          = 6000,
  turret             = true,
  weaponType         = [[LaserCannon]],
  weaponVelocity     = 1500,
  customparams = {
    damagetype         = [[smallarm]],
  },
  damage = {
    default            = 31,
  },
}

return {
  PistolClass = PistolClass,
}
