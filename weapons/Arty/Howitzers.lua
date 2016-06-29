-- Artillery - Light Howitzers

-- Implementations

-- QF 25pdr Gun (GBR)
local QF25Pdr = Howitzer:New{
  accuracy           = 720,
  areaOfEffect       = 94,
  edgeEffectiveness  = 0.2, -- overrides default
  name               = [[Ordnance QF 25pdr Gun Mk. II]],
  range              = 7780,
  reloadtime         = 7.2,
  customParams = {
  	weaponcost         = 18,
  },
  damage = {
    default            = 1088,
	cegflare           = "MEDIUMLARGE_MUZZLEFLASH", -- 87mm
  },
}

-- QF 25pdr on a boat
local NavalQF25Pdr = QF25Pdr:New{
  accuracy           = 1400,
}

local QF25PdrHE = HowitzerHE:New(QF25Pdr, true)
local QF25PdrSmoke = HowitzerSmoke:New(QF25Pdr, true)

local NavalQF25PdrHE = HowitzerHE:New(NavalQF25Pdr, true)
local NavalQF25PdrSmoke = HowitzerSmoke:New(NavalQF25Pdr, true)


-- 10.5cm LeFH 18/40 (GER)
local LeFH18 = Howitzer:New{
  accuracy           = 1050,
  areaOfEffect       = 129,
  name               = [[10.5cm LeFH 18/40]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 4200,
  },
}
local LeFH18HE = HowitzerHE:New(LeFH18, true)
local LeFH18Smoke = HowitzerSmoke:New(LeFH18, true)

-- M2 105mm Howitzer (USA)
local M2 = Howitzer:New{
  accuracy           = 1050,
  areaOfEffect       = 131,
  name               = [[10.5cm LeFH 18/40]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 4360,
  },
}
local M2HE = HowitzerHE:New(M2, true)
local M2Smoke = HowitzerSmoke:New(M2, true)

-- M-30 122mm Howitzer (RUS)
local M30122mm = Howitzer:New{
  accuracy           = 1150,
  areaOfEffect       = 154,
  name               = [[M-30 122mm Howitzer]],
  range              = 6965,
  reloadtime         = 15,
  customparams = {
    weaponcost         = 34,
  },
  damage = {
    default            = 7200,
  },
}
local M30122mmHE = HowitzerHE:New(M30122mm, true):New{
  customparams = {
    fearaoe            = 250,
  }
}
local M30122mmSmoke = HowitzerSmoke:New(M30122mm, true)

-- 100m howitzer L22 (ITA)
local Obice100mmL22 = Howitzer:New{
  accuracy           = 1050,
  areaOfEffect       = 115,
  name               = [[Obice 100mm/22 M14]],
  soundStart         = [[ITA_100mm]],
  range              = 7200,
  reloadtime         = 10.25,
  damage = {
    default            = 3800,
  },
}
local Obice100mmL22he = HowitzerHE:New(Obice100mmL22, true)
local Obice100mmL22smoke = HowitzerSmoke:New(Obice100mmL22, true)

--  100mm Howitzer L17 (ITA)
local Obice100mmL17 = Howitzer:New{
  accuracy           = 1150,
  areaOfEffect       = 115,
  name               = [[Obice 100mm/17 M14]],
  soundStart         = [[ITA_100mm]],
  range              = 6000,
  reloadtime         = 9.25,
  damage = {
    default            = 3800,
  },
}
local Obice100mmL17HE = HowitzerHE:New(Obice100mmL17, true)
local Obice100mmL17Smoke = HowitzerSmoke:New(Obice100mmL17, true)

-- Type 91 105m howitzer L/24 (JPN)
local Type91105mmL24 = Howitzer:New{
  accuracy           = 1000,
  areaOfEffect       = 125,
  name               = [[Type 91 105mm/24]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 4050,
  },
}
local Type91105mmL24HE = HowitzerHE:New(Type91105mmL24, true)
local Type91105mmL24Smoke = HowitzerSmoke:New(Type91105mmL24, true)

-- Bofors 10.5 cm kanon m/34
local Bofors105mmM_34 = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[10.5 cm kanon m/34]],
	range              = 10990,
	reloadtime         = 20,	-- Force lower RoF
	damage = {
		default            = 4200,
	},
}

local Bofors105mmM_34HE = HowitzerHE:New(Bofors105mmM_34, true)
local Bofors105mmM_34Smoke = HowitzerSmoke:New(Bofors105mmM_34, true)

-- Same for m/27 - Hungary uses that
local m31_105mm = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[31.M 105mm cannon]],
	range              = 10990,
	reloadtime         = 20,	-- Force lower RoF
	damage = {
		default            = 4200,
	},
}

local m31_105mmHE = HowitzerHE:New(m31_105mm, true)
local m31_105mmSmoke = HowitzerSmoke:New(m31_105mm, true)

-- Cannone da 105/32
local Cannone105_32 = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[Cannone da 105/32]],
	range              = 9000,
	reloadtime         = 15,	-- Force lower RoF
	damage = {
		default            = 4200,
	},
}

local Cannone105_32HE = HowitzerHE:New(Cannone105_32, true)
local Cannone105_32Smoke = HowitzerSmoke:New(Cannone105_32, true)

-- 10 sK18
local GER10sK18 = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[10.5 cm schwere Kanone 18]],
	range              = 12000,
	reloadtime         = 22,	-- Force lower RoF
	damage = {
		default            = 4200,
	},
}

local GER10sK18HE = HowitzerHE:New(GER10sK18, true)
local GER10sK18Smoke = HowitzerSmoke:New(GER10sK18, true)

-- Type 92 10 cm Cannon
local Type92_10cm = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[Type 92 10 cm Cannon]],
	range              = 12300,
	reloadtime         = 22,	-- Force lower RoF
	damage = {
		default            = 4200,
	},
} 

local Type92_10cmHE = HowitzerHE:New(Type92_10cm, true)
local Type92_10cmSmoke = HowitzerSmoke:New(Type92_10cm, true)

-- BL 4.5-inch gun
local BL45inGun = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[BL 4.5 inch Medium Gun]],
	range              = 12100,
	reloadtime         = 22,	-- Force lower RoF
	damage = {
		default            = 4500,	-- a bit more than for 105
	},
}

local BL45inGunHE = HowitzerHE:New(BL45inGun, true)
local BL45inGunSmoke = HowitzerSmoke:New(BL45inGun, true)

-- US M1 4.5in gun - same as British
local M1_45in_Gun = LongRangeCannon:New{
	accuracy           = 950,
	areaOfEffect       = 129,
	name               = [[4.5 inch Gun M1]],
	range              = 12100,
	reloadtime         = 22,	-- Force lower RoF
	damage = {
		default            = 4500,	-- a bit more than for 105
	},
}

local M1_45in_GunHE = HowitzerHE:New(M1_45in_Gun, true)
local M1_45in_GunSmoke = HowitzerSmoke:New(M1_45in_Gun, true)

-- Return only the full weapons
return lowerkeys({
  QF25PdrHE = QF25PdrHE,
  QF25PdrSmoke = QF25PdrSmoke,
  NavalQF25PdrHE = NavalQF25PdrHE,
  NavalQF25PdrSmoke = NavalQF25PdrSmoke,
  LeFH18HE = LeFH18HE,
  LeFH18Smoke = LeFH18Smoke,
  M2HE = M2HE,
  M2Smoke = M2Smoke,
  M30122mmHE = M30122mmHE,
  M30122mmSmoke = M30122mmSmoke,
  Obice100mmL22he = Obice100mmL22he,
  Obice100mmL22smoke = Obice100mmL22smoke,
  Obice100mmL17HE = Obice100mmL17HE,
  Obice100mmL17Smoke = Obice100mmL17Smoke,
  Type91105mmL24HE = Type91105mmL24HE,
  Type91105mmL24Smoke = Type91105mmL24Smoke,
  Bofors105mmM_34HE = Bofors105mmM_34HE,
  Bofors105mmM_34Smoke = Bofors105mmM_34Smoke,
  m31_105mmHE = m31_105mmHE,
  m31_105mmSmoke = m31_105mmSmoke,
  Cannone105_32HE = Cannone105_32HE,
  Cannone105_32Smoke = Cannone105_32Smoke,
  GER10sK18HE = GER10sK18HE,
  GER10sK18Smoke = GER10sK18Smoke,
  Type92_10cmHE = Type92_10cmHE,
  Type92_10cmSmoke = Type92_10cmSmoke,
  BL45inGunHE = BL45inGunHE,
  BL45inGunSmoke = BL45inGunSmoke,
  M1_45in_GunHE = M1_45in_GunHE,
  M1_45in_GunSmoke = M1_45in_GunSmoke,
})
