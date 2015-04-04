-- Artillery - Anti Aircraft Guns

-- Bofors 40mm AA Gun (GBR & USA)
local Bofors40mm = AntiAirGun:New{
  name               = [[40mm Bofors Anti-Aircraft Gun]],
  burst              = 4, -- 4 round clips
  burstrate          = 0.429, -- cyclic 140rpm
  reloadtime         = 2.7, -- practical 90rpm
  weaponVelocity     = 1646,
  damage = {
    default            = 275,
  },
}
local Bofors40mmAA = Bofors40mm:New(AntiAirGunAA, true):New{
  range              = 2025,
}
local Bofors40mmHE = Bofors40mm:New(AutoCannonHE, true):New{
  range              = 725,
}

-- Twin Bofors 40mm AA Gun (For ships)
-- derives from the above, only with half the reloadtime
local Twin_Bofors40mmAA = Bofors40mmAA:New{
  reloadtime         = 1.35,
}
local Twin_Bofors40mmHE = Bofors40mmHE:New{
  reloadtime         = 1.35,
}

-- FlaK 43 37mm AA Gun (GER)
local FlaK4337mm = AntiAirGun:New{
  name               = [[37mm FlaK 43 Anti-Aircraft Gun]],
  burst              = 4, -- 8 round clips
  burstrate          = 0.240, -- cyclic 250rpm
  reloadtime         = 1.6, -- practical 150rpm 
  weaponVelocity     = 1640,
  damage = {
    default            = 162, -- guesstimate, can't get zergs formulas to match up
  },
}
local FlaK4337mmAA = FlaK4337mm:New(AntiAirGunAA, true):New{
  range              = 2025,
}
local FlaK4337mmHE = FlaK4337mm:New(AutoCannonHE, true):New{
  range              = 725,
}

-- M-1939 61-K 37mm AA Gun (RUS)
local M1939_61K37mm = AntiAirGun:New{
  name               = [[37mm M-1939 61-K Anti-Aircraft Gun]],
  burst              = 5, -- 5 round clip
  burstrate          = 0.353, -- cyclic 170rpm
  reloadtime         = 3.8, -- 80rpm practical
  weaponVelocity     = 1760,
  damage = {
    default            = 182,
  },
}
local M1939_61K37mmAA = M1939_61K37mm:New(AntiAirGunAA, true):New{
  range              = 2025,
}
local M1939_61K37mmHE = M1939_61K37mm:New(AutoCannonHE, true):New{
  range              = 725,
}

-- Return only the full weapons
return lowerkeys({
  -- Medium (40mm)
  Bofors40mmAA = Bofors40mmAA,
  Bofors40mmHE = Bofors40mmHE,
  Twin_Bofors40mmAA = Twin_Bofors40mmAA,
  Twin_Bofors40mmHE = Twin_Bofors40mmHE,
  FlaK4337mmAA = FlaK4337mmAA,
  FlaK4337mmHE = FlaK4337mmHE,
  M1939_61K37mmAA = M1939_61K37mmAA,
  M1939_61K37mmHE = M1939_61K37mmHE,
})
