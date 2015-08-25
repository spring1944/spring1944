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

local CS95mmHE = CS95mm:New(HowitzerHE, true):New{
  areaOfEffect       = 109,
  damage = {
    default            = 2500,
  },  
}
local CS95mmSmoke = CS95mm:New(HowitzerSmoke, true)

-- M4 105mm (USA)
local M4105mm = CSHowitzer:New{
  edgeEffectiveness  = 0.25,
  name               = [[M4 105mm Howitzer]],
  range              = 1700, -- fwiw I object to this too
  reloadTime         = 11.25,
}

local M4105mmHE = M4105mm:New(HowitzerHE, true):New{
  areaOfEffect       = 131,
  damage = {
    default            = 4360,
  },  
}
local M4105mmSmoke = M4105mm:New(HowitzerSmoke, true)


-- Return only the full weapons
return lowerkeys({
  -- CS 95mm
  CS95mmHE = CS95mmHE,
  CS95mmSmoke = CS95mmSmoke,
  -- M4 105mm
  M4105mmHE = M4105mmHE,
  M4105mmSmoke = M4105mmSmoke,
})
