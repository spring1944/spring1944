-- Artillery - Anti Aircraft Guns

-- Bofors 40mm AA Gun (GBR & USA)
local Bofors40mm = AAGunClass:New{
  name               = [[40mm Bofors Anti-Aircraft Gun]],
  weaponVelocity     = 1646,
  damage = {
    default            = 275,
  },
}
local Bofors40mmAA = Bofors40mm:New(AAGunAAClass, true):New{
  burst              = 4,
  burstrate          = 0.33,
  range              = 2025,
  reloadtime         = 1.5,
}
local Bofors40mmHE = Bofors40mm:New(AAGunHEClass, true):New{
  burst              = 2,
  burstrate          = 0.5,
  range              = 725,
  reloadtime         = 1.625,
}

-- Twin Bofors 40mm AA Gun (For ships)
-- derives from the above, only with half the reloadtime
local Twin_Bofors40mmAA = Bofors40mmAA:New{
  reloadtime         = 0.75,
}
local Twin_Bofors40mmHE = Bofors40mmHE:New{
  reloadtime         = 0.8125,
}

-- FlaK 43 37mm AA Gun (GER)
local FlaK4337mm = AAGunClass:New{
  name               = [[37mm FlaK 43 Anti-Aircraft Gun]],
  weaponVelocity     = 1640,
  damage = {
    default            = 162, -- guesstimate, can't get zergs formulas to match up
  },
}
local FlaK4337mmAA = FlaK4337mm:New(AAGunAAClass, true):New{
  burst              = 4,
  burstrate          = 0.250,
  range              = 2025,
  reloadtime         = 1.6,
}
local FlaK4337mmHE = FlaK4337mm:New(AAGunHEClass, true):New{
  burst              = 2,
  burstrate          = 0.625,
  range              = 725,
  reloadtime         = 1.625,
}

-- M-1939 61-K 37mm AA Gun (RUS)
local M1939_61K37mm = AAGunClass:New{
  name               = [[37mm M-1939 61-K Anti-Aircraft Gun]],
  weaponVelocity     = 1760,
  damage = {
    default            = 182,
  },
}
local M1939_61K37mmAA = M1939_61K37mm:New(AAGunAAClass, true):New{
  burst              = 5, -- fed from 5 round clip
  burstrate          = 0.35, -- 170rpm cyclic
  range              = 2025,
  reloadtime         = 3.75, -- 80rpm practical
}
local M1939_61K37mmHE = M1939_61K37mm:New(AAGunHEClass, true):New{
  burst              = 2,
  burstrate          = 0.625,
  range              = 725,
  reloadtime         = 1.625,
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
