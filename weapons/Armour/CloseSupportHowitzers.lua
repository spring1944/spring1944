-- Armour - Close-Support Howitzers

-- Implementations

-- CS 95mm (GBR)
local CS95mm = CSHowitzerClass:New{
  edgeEffectiveness  = 0.35,
  name               = [[CS 95mm]],
  range              = 1690, -- fwiw I object to this too
  reloadTime         = 9,
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
