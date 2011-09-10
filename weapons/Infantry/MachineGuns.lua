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
  weaponType         = [[Cannon]], -- intended? :o
  weaponVelocity     = 1500,
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 45,
    fearid             = 301,
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

-- Implementations
-- Rifle Calibre (~8mm) MG's
-- BESA
local BESA = MGClass:New{
  burst              = 8,
  burstRate          = 0.109,
  movingAccuracy     = 7111,
  name               = [[BESA]],
  range              = 900,
  reloadTime         = 2.8,
  soundStart         = [[GBR_BREN]],
  soundTrigger       = false, -- overrides default
  sprayAngle         = 410, --?
}

-- Bren Mk. 2 (GBR)
local Bren = MGClass:New{
  burst              = 5,
  burstRate          = 0.109,
  movingAccuracy     = 7111,
  name               = [[Bren Gun]],
  range              = 735,
  reloadTime         = 2.5,
  soundStart         = [[GBR_BREN]],
  soundTrigger       = false, -- overrides default
}

-- MG34 (GER)
local MG34 = MGClass:New{
  accuracy           = 100, --?
  burst              = 10,
  burstRate          = 0.069,
  movingAccuracy     = 2666,
  name               = [[Maschinengewehr 34]],
  range              = 945,
  reloadTime         = 2.55,
  soundStart         = [[GER_MG34]],
  sprayAngle         = 300, -- ?
}

-- MG42 (GER)
local MG42 = MGClass:New{
  accuracy           = 100, --?
  burst              = 11,
  burstRate          = 0.0175,
  movingAccuracy     = 7111,
  name               = [[Maschinengewehr 42]],
  range              = 850,
  reloadTime         = 2.55,
  soundStart         = [[GER_MG42]],
  sprayAngle         = 530,
}
-- Deployed MG42
local MG42_Deployed = MG42:New{
  range              = 1040,
  sprayAngle         = 360,
}
-- Anti Air MG42
local MG42AA = MG42:New{
  canAttackGround    = false,
  range              = 1170,
  sprayAngle         = 460,
  customparams = { -- don't cause fear, should cause Aircraft fear?
    fearaoe            = nil,
    fearid             = nil, 
  }
}

-- DP (RUS)
local DP = MGClass:New{
  burst              = 5,
  burstRate          = 0.12,
  movingAccuracy     = 1777, -- this looks like backwards 7111?
  name               = [[DP]],
  range              = 700,
  reloadTime         = 2.25,
  soundStart         = [[RUS_DP]],
}
-- DT
local DT = DP:New{
  movingAccuracy     = 300,
  range              = 910,
  reloadTime         = 3,
  sprayAngle         = 250,
}

-- Maxim (RUS)
local Maxim = MGClass:New{
  burst              = 14,
  burstRate          = 0.05,
  name               = [[M1910 Maxim]],
  range              = 1270,
  reloadTime         = 2.7,
  soundStart         = [[RUS_Maxim]],
}
-- Maxim AA
local MaximAA = Maxim:New{
  burst              = 7,
  burstRate          = 0.103,
  canAttackGround    = false,
  movingAccuracy     = 400,
  predictBoost       = 0.75,
  range              = 1050,
  customParams = {
    fearaoe            = 1,
    fearid             = 701,
  }
}
-- Vickers (GBR)
local Vickers = Maxim:New{
  name               = [[Vickers, .303 Mark 1]],
  sprayAngle         = 300, -- ?
}

-- M1919 Browning (USA)
local M1919A4Browning = MGClass:New{
  burst              = 7,
  burstRate          = 0.14,
  movingAccuracy     = 6222,
  name               = [[M1919A4 Browning .30 caliber machinegun]],
  range              = 820,
  reloadTime         = 3,
  soundStart         = [[US_30Cal]],
  sprayAngle         = 460,
}
-- Deployed Browning
local M1919A4Browning_Deployed = M1919A4Browning:New{
  range              = 1020,
  sprayAngle         = 400,
}

-- Large calibre (12.7mm) MG's
-- Vickers 50 cal (GBR)
local Twin05CalVickers = HeavyMGClass:New{
  name               = [[Twin Vickers .50 Caliber Heavy Machine Gun]],
  range              = 875,
  reloadTime         = 2.2,
  soundStart         = [[US_50CAL]],
}

-- DShK (RUS)
local DShK = HeavyMGClass:New{
  name               = [[DShK 12.7mm Heavy Machine Gun]],
  range              = 1300,
  reloadTime         = 3,
  soundStart         = [[RUS_DShK]],
}
-- Twin DShK
local Twin_DShK = DShK:New{
  reloadTime         = 1.4, -- why not 1.5?
}

-- M2 Browning  (USA)
local M2Browning = HeavyMGClass:New{
  name               = [[M2 Browning .50 Caliber Heavy Machine Gun]],
  range              = 880,
  reloadTime         = 4,
  soundStart         = [[US_50CAL]],
}
-- M2 Browning AA
local M2BrowningAA = M2Browning:New{
  burst              = 6,
  canAttackGround    = false,
  movingAccuracy     = 200,
  range              = 1170,
  reloadTime         = 1.5,
  sprayAngle         = 250, --?
  customParams = {
    fearaoe            = 1,
    fearid             = 701,
  }  
}
-- M2 Browning Aircraft
local M2BrowningAMG = M2Browning:New{
  burst             = 6,
  burstRate         = 0.085,
  interceptedByShieldType = 8, --??
  predictBoost      = 0.75,
  range             = 900,
  reloadTime        = 0.6,
  soundStart        = [[US_50CALAir]],
  sprayAngle        = 250,
  tolerance         = 600, --?
}

-- Return only the full weapons
return lowerkeys({
  -- 8mm
  BESA = BESA,
  Bren = Bren,
  Vickers = Vickers,
  MG34 = MG34,
  MG42 = MG42,
  MG42_Deployed = MG42_Deployed,
  MG42AA = MG42AA,
  DP = DP,
  DT = DT,
  Maxim = Maxim,
  MaximAA = MaximAA,
  M1919A4Browning = M1919A4Browning,
  M1919A4Browning_Deployed = M1919A4Browning_Deployed,
  -- 13mm
  Twin05CalVickers = Twin05CalVickers,
  DShK = DShK,
  Twin_DShK = Twin_DShK,
  M2Browning = M2Browning,
  M2BrowningAA = M2BrowningAA,
  M2BrowningAMG = M2BrowningAMG,
})
