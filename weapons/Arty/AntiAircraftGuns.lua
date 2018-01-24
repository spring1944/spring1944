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
  customparams = {
    weaponcost = 2,
  },
}
local Bofors40mmAA = AntiAirGunAA:New(Bofors40mm, true):New{
  range              = 1620,
}
local Bofors40mmHE = AutoCannonHE:New(Bofors40mm, true):New{
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
  customparams = {
    weaponcost = 2,
  },
}
local FlaK4337mmAA = AntiAirGunAA:New(FlaK4337mm, true):New{
  range              = 1620,
}
local FlaK4337mmHE = AutoCannonHE:New(FlaK4337mm, true):New{
  range              = 725,
}
local FlaK4337mmAP = AutoCannonAP:New(FlaK4337mm, true):New{
  range              = 725,
  customparams = {
    armor_penetration_1000m = 29,
    armor_penetration_100m  = 52,
  },
  damage = {
    default            = 585,
  },
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
  customparams = {
    weaponcost = 1,
  },
}
local M1939_61K37mmAA = AntiAirGunAA:New(M1939_61K37mm, true):New{
  range              = 1620,
}
local M1939_61K37mmHE = AutoCannonHE:New(M1939_61K37mm, true):New{
  range              = 725,
}

-- 25mm Bofors gun - Swedish ships
local Bofors25mm = AntiAirGun:New{
	name               = [[25mm M/38 Bofors Anti-Aircraft Gun]],
	burst              = 6, -- 6 round clips
	burstrate          = 0.429, -- cyclic 140rpm
	reloadtime         = 2.7, -- practical 90rpm
	weaponVelocity     = 1646,
	damage = {
		default            = 150,
	},
	customparams = {
		weaponcost = 2,
	},
}

local Bofors25mm_AA = AntiAirGunAA:New(Bofors25mm, true):New{
	range              = 1620,
}

local Bofors25mm_HE = AutoCannonHE:New(Bofors25mm, true):New{
	range              = 725,
}

-- Hotchkiss 25mm AA
local Hotchkiss25mmAA = AntiAirGun:New{
	name               = [[Mitrailleuse de 25 mm CA mle 39]],
	burst              = 5, -- 15 round clips, split into bursts of 5
	burstrate          = 0.24, -- cyclic 250rpm
	reloadtime         = 1.52, -- practical 110rpm
	weaponVelocity     = 1646,
	damage = {
		default            = 150,
	},
	customparams = {
		weaponcost = 2,
	},
}

local Hotchkiss25mmAA_AA = AntiAirGunAA:New(Hotchkiss25mmAA, true):New{
	range              = 1620,
}

local Hotchkiss25mmAA_HE = AutoCannonHE:New(Hotchkiss25mmAA, true):New{
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
  FlaK4337mmAP = FlaK4337mmAP,
  M1939_61K37mmAA = M1939_61K37mmAA,
  M1939_61K37mmHE = M1939_61K37mmHE,
  Bofors25mm_AA = Bofors25mm_AA,
  Bofors25mm_HE = Bofors25mm_HE,
  Hotchkiss25mmAA = Hotchkiss25mmAA_AA,
  Hotchkiss25mmHE = Hotchkiss25mmAA_HE,
})
