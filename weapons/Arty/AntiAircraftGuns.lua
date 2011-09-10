-- Artillery - Anti Aircraft Guns

-- AA Gun Base Class
local AAGunClass = Weapon:New{
  burnblow           = true,
  collisionSize      = 2,
  explosionSpeed     = 30,
  impulseFactor      = 0,
  intensity          = 0.9,
  predictBoost       = 0, -- this seems very strange for an AA weapon!
  size               = 1e-5,
  soundHit           = [[GEN_Explo_Flak1]],
  soundStart         = [[GEN_37mmAA]],
  sprayAngle         = 400,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    damagetype         = [[explosive]],
  },
}

-- AA Round Class
local AAGunAAClass = Weapon:New{
  areaOfEffect       = 60,
  canattackground    = false,
  collisionSize      = 5,
  edgeEffectiveness  = 0.001,
  explosionGenerator = [[custom:HE_Medium]],
  name               = [[AA Shell]],
  tolerance          = 1400,
  customparams = {
    fearaoe            = 450,
    fearid             = 701,
  }
}

-- HE Round Class
local AAGunHEClass = Weapon:New{
  areaOfEffect       = 24,
  edgeEffectiveness  = 0.25,
  explosionGenerator = [[custom:HE_XSmall]],
  name               = [[HE Shell]],
  sprayAngle         = 0,
  tolerance          = 700,
  customparams = {
    fearaoe            = 45,
    fearid             = 301,
  },
}

-- Implementations

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
  burst              = 2, -- seems strange difference to bofors?
  burstrate          = 0.3,
  range              = 2025,
  reloadtime         = 0.85,
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
