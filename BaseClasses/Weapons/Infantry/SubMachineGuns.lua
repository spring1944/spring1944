-- Smallarms - Infantry Submachineguns

-- Submachinegun Base Class
local SMGClass = Weapon:New{
  accuracy           = 100,
  areaOfEffect       = 1,
  avoidFeature       = true,
  avoidFriendly      = false,
  burst              = 5,
  collideFeature     = true,
  collideFriendly    = false,
  collisionSize      = 2.5,
  coreThickness      = 0.15,
  duration           = 0.01,
  explosionGenerator = [[custom:Bullet]],
  fireStarter        = 0,
  id                 = 5, -- used for cob based fear from rifle/smg
  impactonly         = 1,
  intensity          = 0.7,
  interceptedByShieldType = 8,
  laserFlareSize     = 0.0001,
  movingAccuracy     = 933,
  rgbColor           = [[1.0 0.75 0.0]],
  soundTrigger       = true,
  sprayAngle         = 350,
  thickness          = 0.4,
  tolerance          = 6000,
  turret             = true,
  weaponTimer        = 1,
  weaponType         = [[LaserCannon]],
  weaponVelocity     = 1500,
  customparams = {
    damagetype         = [[smallarm]],
  },
  damage = {
    default            = 17,
  },
}


return {
  SMGClass = SMGClass,
}
