-- Smallarms - Machineguns

-- MachineGun Base Class
local MGClass = Weapon:New{
  areaOfEffect       = 1,
  avoidFeature       = true,
  avoidFriendly      = false,
  burnblow           = true, -- used?
  collideFeature     = true,
  collideFriendly    = false,
  collisionSize      = 2.5,
  collisionVolumeTest= 1,
  explosionGenerator = [[custom:Bullet]],
  fireStarter        = 1,
  impactonly         = 1,
  interceptedByShieldType = 8,
  noSelfDamage       = true,
  size               = 1e-10,
  soundTrigger       = true,
  sprayAngle         = 350,
  tolerance          = 600,
  turret             = true,
  weaponType         = [[LaserCannon]],
  weaponVelocity     = 1500,
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 45,
    fearid             = 301,
    cegflare           = "MG_MUZZLEFLASH",
    flareonshot        = true,
    scriptanimation    = [[mg]],
  },
  damage = {
    default            = 33,
  },
}

local HeavyMGClass = MGClass:New{
  burst              = 8,
  burstRate          = 0.1,
  interceptedByShieldType = 16,
  movingAccuracy     = 500,
  targetMoveError    = 0.25,
  tolerance          = 3000, -- needed?
  weaponVelocity     = 3000,
  customparams = {
    fearid             = 401,
  },
  damage = {
    default            = 50,
  },
}


return {
  MGClass = MGClass,
  HeavyMGClass = HeavyMGClass,
}
