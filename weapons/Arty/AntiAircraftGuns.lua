-- Artillery - Anti Aircraft Guns

-- Bofors 40mm AA Gun (GBR & USA)
Weapon('Bofors40mm'):Extends('AntiAirGun'):Attrs{
  name               = [[40mm Bofors Anti-Aircraft Gun]],
  burst              = 4, -- 4 round clips
  burstrate          = 0.429, -- cyclic 140rpm
  reloadtime         = 2.7, -- practical 90rpm
  weaponVelocity     = 1646,
  damage = {
    default            = 275,
  },
  customparams = {
    weaponcost = 2,
  },
}
Weapon('Bofors40mmAA'):Extends('AntiAirGunAA'):Extends('Bofors40mm'):Attrs{ -- name append
  range              = 2025,
}
Weapon('Bofors40mmHE'):Extends('AutoCannonHE'):Extends('Bofors40mm'):Attrs{ -- name append
  range              = 725,
}

-- Twin Bofors 40mm AA Gun (For ships)
-- derives from the above, only with half the reloadtime
Weapon('Twin_Bofors40mmAA'):Extends('Bofors40mmAA'):Attrs{
  reloadtime         = 1.35,
}
Weapon('Twin_Bofors40mmHE'):Extends('Bofors40mmHE'):Attrs{
  reloadtime         = 1.35,
}

-- FlaK 43 37mm AA Gun (GER)
Weapon('FlaK4337mm'):Extends('AntiAirGun'):Attrs{
  name               = [[37mm FlaK 43 Anti-Aircraft Gun]],
  burst              = 4, -- 8 round clips
  burstrate          = 0.240, -- cyclic 250rpm
  reloadtime         = 1.6, -- practical 150rpm 
  weaponVelocity     = 1640,
  damage = {
    default            = 162, -- guesstimate, can't get zergs formulas to match up
  },
  customparams = {
    weaponcost = 2,
  },
}
Weapon('FlaK4337mmAA'):Extends('AntiAirGunAA'):Extends('FlaK4337mm'):Attrs{ -- name append
  range              = 2025,
}
Weapon('FlaK4337mmHE'):Extends('AutoCannonHE'):Extends('FlaK4337mm'):Attrs{ -- name append
  range              = 725,
}

-- M-1939 61-K 37mm AA Gun (RUS)
Weapon('M1939_61K37mm'):Extends('AntiAirGun'):Attrs{
  name               = [[37mm M-1939 61-K Anti-Aircraft Gun]],
  burst              = 5, -- 5 round clip
  burstrate          = 0.353, -- cyclic 170rpm
  reloadtime         = 3.8, -- 80rpm practical
  weaponVelocity     = 1760,
  damage = {
    default            = 182,
  },
  customparams = {
    weaponcost = 1,
  },
}
Weapon('M1939_61K37mmAA'):Extends('AntiAirGunAA'):Extends('M1939_61K37mm'):Attrs{ -- name append
  range              = 2025,
}
Weapon('M1939_61K37mmHE'):Extends('AutoCannonHE'):Extends('M1939_61K37mm'):Attrs{ -- name append
  range              = 725,
}

-- Return only the full weapons
