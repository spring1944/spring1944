local SmallArm = Weapon:New{
  areaOfEffect       = 1,
  avoidFeature       = true,
  avoidFriendly      = false,
  collideFeature     = true,
  collideFriendly    = false,
  explosionGenerator = "custom:Bullet",
  fireStarter        = 0,
  impactonly         = true,
  interceptedByShieldType = 8,
  tolerance          = 6000,
  turret             = true,
  weaponType         = "LaserCannon",
  weaponVelocity     = 1500,
  customparams = {
    damagetype         = "smallarm",
    onlytargetCategory = "INFANTRY SOFTVEH DEPLOYED",
    badtargetcategory  = "SOFTVEH DEPLOYED",
  },
}

-- Pistol Base Class
local PistolClass = SmallArm:New{
  collisionSize      = 2.5,
  coreThickness      = 0.15,
  duration           = 0.025,
  id                 = 1, -- used?
  intensity          = 0.0001,
  movingAccuracy     = 888,
  range              = 180,
  reloadtime         = 1.5,
  --rgbColor           = [[1.0 0.75 0.0]],
  soundTrigger       = false,
  thickness          = 0.2,
  customparams = {
    cegflare           = "PISTOL_MUZZLEFLASH",
    scriptanimation    = [[pistol]],
  },
  damage = {
    default            = 31,
  },
}

-- Rifle Base Class
local RifleClass = SmallArm:New{
  accuracy           = 100,
  collisionSize      = 2.5,
  coreThickness      = 0.15,
  duration           = 0.01,
  id                 = 2, -- used for cob based fear from rifle/smg
  impulsefactor      = 0.1,
  intensity          = 0.9,
  movingAccuracy     = 888,
  rgbColor           = [[1.0 0.75 0.0]],
  sprayAngle         = 100,
  thickness          = 0.4,
  customparams = {
    cegflare           = "RIFLE_MUZZLEFLASH",
    scriptanimation    = [[rifle]],
  },
  damage = {
    default            = 33,
  },
}

-- Sniper Rifle Base Class
local SniperRifleClass = RifleClass:New{
  accuracy           = 0,
  movingAccuracy     = 1777,
  range              = 1040,
  reloadtime         = 10,
  tolerance          = 2000,
  customparams = {
    onlyTargetCategory  = "INFANTRY DEPLOYED", -- don't waste sniper shots on light vehs
    fearaoe            = 90,
    fearid             = 401,
    scriptanimation    = [[sniper]],
  },
  damage = {
    default              = 625,
    infantry             = 1700,
    sandbags             = 325,
  },
}

-- Submachinegun Base Class
local SMGClass = SmallArm:New{
  accuracy           = 100,
  burst              = 5,
  collisionSize      = 2.5,
  coreThickness      = 0.15,
  duration           = 0.01,
  id                 = 5, -- used for cob based fear from rifle/smg
  intensity          = 0.7,
  movingAccuracy     = 933,
  rgbColor           = [[1.0 0.75 0.0]],
  soundTrigger       = true,
  sprayAngle         = 350,
  thickness          = 0.4,
  customparams = {
    cegflare           = "SMG_MUZZLEFLASH",
    scriptanimation    = [[smg]],
  },
  damage = {
    default            = 17,
  },
}

-- MachineGun Base Class
local MGClass = SmallArm:New{
  collisionSize      = 2.5,
  fireStarter        = 1,
  heightBoostFactor  = 0,
  size               = 1e-10,
  soundTrigger       = true,
  sprayAngle         = 350,
  tolerance          = 600,
  weaponType         = "Cannon",
  customparams = {
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

local AAMG = Weapon:New{ -- should be used like ammo bases
  canAttackGround    = false,
  predictBoost       = 0.75,
  range              = 1050,
  customparams = {
    no_range_adjust    = true,
    fearid             = 701,
	onlytargetCategory = "AIR",
  }
}

return {
  SmallArm = SmallArm,
  PistolClass = PistolClass,
  RifleClass = RifleClass,
  SniperRifleClass = SniperRifleClass,
  SMGClass = SMGClass,
  MGClass = MGClass,
  HeavyMGClass = HeavyMGClass,
  AAMG = AAMG,
}
