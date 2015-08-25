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

local QF25PdrHE = QF25Pdr:New(HowitzerHE, true)
local QF25PdrSmoke = QF25Pdr:New(HowitzerSmoke, true)

local NavalQF25PdrHE = NavalQF25Pdr:New(HowitzerHE, true)
local NavalQF25PdrSmoke = NavalQF25Pdr:New(HowitzerSmoke, true)


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
local LeFH18HE = LeFH18:New(HowitzerHE, true)
local LeFH18Smoke = LeFH18:New(HowitzerSmoke, true)

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
local M2HE = M2:New(HowitzerHE, true)
local M2Smoke = M2:New(HowitzerSmoke, true)

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
local M30122mmHE = M30122mm:New(HowitzerHE, true):New{
  customparams = {
    fearaoe            = 250,
  }
}
local M30122mmSmoke = M30122mm:New(HowitzerSmoke, true)

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
local Obice100mmL22he = Obice100mmL22:New(HowitzerHE, true)
local Obice100mmL22smoke = Obice100mmL22:New(HowitzerSmoke, true)

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
local Obice100mmL17HE = Obice100mmL17:New(HowitzerHE, true)
local Obice100mmL17Smoke = Obice100mmL17:New(HowitzerSmoke, true)

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
local Type91105mmL24HE = Type91105mmL24:New(HowitzerHE, true)
local Type91105mmL24Smoke = Type91105mmL24:New(HowitzerSmoke, true)

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
})
