-- Armour - Close-Support Howitzers

-- Implementations

-- CS 95mm (GBR)
Weapon('CS95mm'):Extends('CSHowitzer'):Attrs{
  edgeEffectiveness  = 0.35,
  name               = [[CS 95mm]],
  range              = 1690, -- fwiw I object to this too
  reloadTime         = 9,
  customParams = {
    weaponcost         = 20,
    cegflare           = "MEDIUMLARGE_MUZZLEFLASH",
  },
}

Weapon('CS95mmHE'):Extends('HowitzerHE'):Extends('CS95mm'):Attrs{ -- name append
  areaOfEffect       = 109,
  damage = {
    default            = 2500,
  },  
}
Weapon('CS95mmSmoke'):Extends('HowitzerSmoke'):Extends('CS95mm') -- name append

-- M4 105mm (USA)
Weapon('M4105mm'):Extends('CSHowitzer'):Attrs{
  edgeEffectiveness  = 0.25,
  name               = [[M4 105mm Howitzer]],
  range              = 1700, -- fwiw I object to this too
  reloadTime         = 11.25,
}

Weapon('M4105mmHE'):Extends('HowitzerHE'):Extends('M4105mm'):Attrs{ -- name append
  areaOfEffect       = 131,
  damage = {
    default            = 4360,
  },  
}
Weapon('M4105mmSmoke'):Extends('HowitzerSmoke'):Extends('M4105mm') -- name append


-- Return only the full weapons
