-- Armour - Close-Support Howitzers

-- Implementations

-- CS 95mm (GBR)
local CS95mm = CSHowitzer:New{
  edgeEffectiveness  = 0.35,
  name               = [[CS 95mm]],
  range              = 1690, -- fwiw I object to this too
  reloadTime         = 9,
  customParams = {
    weaponcost         = 20,
    cegflare           = "MEDIUMLARGE_MUZZLEFLASH",
  },
}

local CS95mmHE = HowitzerHE:New(CS95mm, true):New{
  areaOfEffect       = 109,
  damage = {
    default            = 2500,
  },  
}
local CS95mmSmoke = HowitzerSmoke:New(CS95mm, true)

-- M4 105mm (USA)
local M4105mm = CSHowitzer:New{
  edgeEffectiveness  = 0.25,
  name               = [[M4 105mm Howitzer]],
  range              = 1700, -- fwiw I object to this too
  reloadTime         = 11.25,
}

local M4105mmHE = HowitzerHE:New(M4105mm, true):New{
  areaOfEffect       = 131,
  damage = {
    default            = 4360,
  },  
}
local M4105mmSmoke = HowitzerSmoke:New(M4105mm, true)

-- Ansaldo 105mm/25 (ITA)
local Ansaldo105mmL25 = CSHowitzer:New{
  name               = [[Ansaldo L/25 105mm Howitzer]],
  range              = 1775,
  reloadTime         = 11.25,
  soundStart         = [[GEN_105mm]],
  customparams = {
    cegflare           = "LARGE_MUZZLEFLASH",
  }
}

local Ansaldo105mmL25HE = HeavyHE:New(Ansaldo105mmL25, true):New{
  areaOfEffect       = 129,
  weaponVelocity     = 900,
  damage = {
    default            = 4009,
  },  
}

local Ansaldo105mmL25HEAT = HeavyHEAT:New(Ansaldo105mmL25, true):New{
  accuracy	= 700,
  weaponVelocity     = 600,
  customparams = {
    armor_penetration       = 140,
  },
  damage = {
    default            = 3790,
  },
}

-- MÁVAG 40/43M L20.5 
local Mavag_105_4043M = CSHowitzer:New{
  name               = [[MÁVAG 105mm 40/43M L20.5  Howitzer]],
  range              = 1775,
  reloadTime         = 11.25,
  soundStart         = [[GEN_105mm]],
  customparams = {
    cegflare           = "LARGE_MUZZLEFLASH",
  }
}

local Mavag_105_4043MHE = HeavyHE:New(Mavag_105_4043M, true):New{
  areaOfEffect       = 129,
  weaponVelocity     = 900,
  damage = {
    default            = 4009,
  },  
}

local Mavag_105_4043MHEAT = HeavyHEAT:New(Mavag_105_4043M, true):New{
  accuracy	= 700,
  weaponVelocity     = 600,
  customparams = {
    armor_penetration       = 90,
  },
  damage = {
    default            = 3790,
  },
}

-- Return only the full weapons
return lowerkeys({
  -- CS 95mm
  CS95mmHE = CS95mmHE,
  CS95mmSmoke = CS95mmSmoke,
  -- M4 105mm
  M4105mmHE = M4105mmHE,
  M4105mmSmoke = M4105mmSmoke,
  -- Ansaldo 105mm/25
  Ansaldo105mmL25HE = Ansaldo105mmL25HE,
  Ansaldo105mmL25HEAT = Ansaldo105mmL25HEAT,
  Mavag_105_4043MHE = Mavag_105_4043MHE,
  Mavag_105_4043MHEAT = Mavag_105_4043MHEAT,
})
