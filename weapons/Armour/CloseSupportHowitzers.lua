-- Armour - Close-Support Howitzers

-- CSHowitzer Base Class
local CSHowitzerClass = Weapon:New{
  accuracy           = 100, -- should surely not be same as other tank guns! :(
  collisionSize      = 4,
  explosionSpeed     = 30, -- needed?
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 600,
  separation         = 2, 
  size               = 1,
  soundHit           = [[GEN_Explo_4]],
  soundStart         = [[GEN_105mm]], -- move later?
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
}

-- HE Round Class
local CSHowitzerHEClass = Weapon:New{
  explosionGenerator = [[custom:HE_Large]],
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 125,
    fearid             = 501,
  },
}

-- Smoke Round Class
local CSHowitzerSmokeClass = Weapon:New{
  areaOfEffect       = 30,
  explosionGenerator = [[custom:HE_Medium]],
  name               = [[Smoke Shell]],
  damage = {
    default            = 100,
  },
  customparams = {
    damagetype         = [[explosive]],
	smokeradius        = 250,
    smokeduration      = 40,
    smokeceg           = [[SMOKESHELL_Medium]],
  },  
}

-- Implementations

-- CS 95mm (GBR)
local CS95mm = CSHowitzerClass:New{
  edgeEffectiveness  = 0.35,
  name               = [[CS 95mm]],
  range              = 1690, -- fwiw I object to this too
  reloadTime         = 9,
  weaponVelocity     = 1200, -- seems rather high?
}

local CS95mmHE = CS95mm:New(CSHowitzerHEClass, true):New{
  areaOfEffect       = 109,
  damage = {
    default            = 2500,
  },  
}
local CS95mmSmoke = CS95mm:New(CSHowitzerSmokeClass, true)

-- M4 105mm (USA)
local M4105mm = CSHowitzerClass:New{
  edgeEffectiveness  = 0.25,
  name               = [[M4 105mm Howitzer]],
  range              = 1700, -- fwiw I object to this too
  reloadTime         = 11.25,
  targetMoveError    = 0.75, -- should be for all CS hows?
  weaponVelocity     = 1200, -- seems rather high?
}

local M4105mmHE = M4105mm:New(CSHowitzerHEClass, true):New{
  areaOfEffect       = 131,
  damage = {
    default            = 4360,
  },  
}
local M4105mmSmoke = M4105mm:New(CSHowitzerSmokeClass, true)


-- Return only the full weapons
return lowerkeys({
  -- CS 95mm
  CS95mmHE = CS95mmHE,
  CS95mmSmoke = CS95mmSmoke,
  -- M4 105mm
  M4105mmHE = M4105mmHE,
  M4105mmSmoke = M4105mmSmoke,
})
