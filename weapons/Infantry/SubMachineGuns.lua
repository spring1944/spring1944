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

-- Implementations

-- STEN Mk. II (GBR)
local STEN = SMGClass:New{
  burstrate          = 0.1,
  name               = [[STEN Mk. II]],
  range              = 300,
  reloadtime         = 1.8,
  soundStart         = [[GBR_STEN]],
}

-- Commando Silenced STEN Mk. IIS (GBR)
-- derives from the above STEN
local SilencedSten = STEN:New({
  burst              = 3,
  movingAccuracy     = 400,
  name               = [[Silenced]],
  range              = 360,
  reloadtime         = 1.2,
  sprayAngle         = 200,
  damage = {
    default            = 80,
  }
}, true)

-- MP.40 (GER)
local MP40 = SMGClass:New{
  burstRate          = 0.12,
  movingAccuracy     = 470, -- intended?
  name               = [[Maschinenpistole 40]],
  range              = 330,
  reloadtime         = 2,
  soundStart         = [[GER_MP40]],
}

-- M1A1 Thompson (USA)
local Thompson = SMGClass:New{
  burst              = 6,
  burstRate          = 0.086,
  movingAccuracy     = 1170, -- O_o
  name               = [[M1A1 Thompson]],
  range              = 300,
  reloadtime         = 1.7,
  soundStart         = [[US_Thompson]],
  sprayAngle         = 400, -- intended?
  damage = {
    default            = 19, -- intended?
  },
}

-- PPSh (RUS)
local PPSh = SMGClass:New{
  burst              = 9,
  burstRate          = 0.05,
  movingAccuracy     = 933,
  name               = [[PPsh-1941]],
  range              = 310,
  reloadtime         = 1.5,
  rgbColor           = [[0.3 0.75 0.4]],
  soundStart         = [[RUS_PPsh]],
  sprayAngle         = 500,
}

-- Return only the full weapons
return lowerkeys({
  STEN = STEN,
  SilencedSten = SilencedSten,
  MP40 = MP40,
  Thompson = Thompson,
  PPSh = PPSh,
})
