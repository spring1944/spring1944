-- Artillery - Light Howitzers

-- Implementations

-- QF 25pdr Gun (GBR)
Weapon('QF25Pdr'):Extends('Howitzer'):Attrs{
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
Weapon('NavalQF25Pdr'):Extends('QF25Pdr'):Attrs{
  accuracy           = 1400,
}

Weapon('QF25PdrHE'):Extends('HowitzerHE'):Extends('QF25Pdr') -- name append
Weapon('QF25PdrSmoke'):Extends('HowitzerSmoke'):Extends('QF25Pdr') -- name append

Weapon('NavalQF25PdrHE'):Extends('HowitzerHE'):Extends('NavalQF25Pdr') -- name append
Weapon('NavalQF25PdrSmoke'):Extends('HowitzerSmoke'):Extends('NavalQF25Pdr') -- name append


-- 10.5cm LeFH 18/40 (GER)
Weapon('LeFH18'):Extends('Howitzer'):Attrs{
  accuracy           = 1050,
  areaOfEffect       = 129,
  name               = [[10.5cm LeFH 18/40]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 4200,
  },
}
Weapon('LeFH18HE'):Extends('HowitzerHE'):Extends('LeFH18') -- name append
Weapon('LeFH18Smoke'):Extends('HowitzerSmoke'):Extends('LeFH18') -- name append

-- M2 105mm Howitzer (USA)
Weapon('M2'):Extends('Howitzer'):Attrs{
  accuracy           = 1050,
  areaOfEffect       = 131,
  name               = [[10.5cm LeFH 18/40]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 4360,
  },
}
Weapon('M2HE'):Extends('HowitzerHE'):Extends('M2') -- name append
Weapon('M2Smoke'):Extends('HowitzerSmoke'):Extends('M2') -- name append

-- M-30 122mm Howitzer (RUS)
Weapon('M30122mm'):Extends('Howitzer'):Attrs{
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
Weapon('M30122mmHE'):Extends('HowitzerHE'):Extends('M30122mm'):Attrs{ -- name append
  customparams = {
    fearaoe            = 250,
  }
}
Weapon('M30122mmSmoke'):Extends('HowitzerSmoke'):Extends('M30122mm') -- name append

-- 100m howitzer L22 (ITA)
Weapon('Obice100mmL22'):Extends('Howitzer'):Attrs{
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
Weapon('Obice100mmL22he'):Extends('HowitzerHE'):Extends('Obice100mmL22') -- name append
Weapon('Obice100mmL22smoke'):Extends('HowitzerSmoke'):Extends('Obice100mmL22') -- name append

--  100mm Howitzer L17 (ITA)
Weapon('Obice100mmL17'):Extends('Howitzer'):Attrs{
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
Weapon('Obice100mmL17HE'):Extends('HowitzerHE'):Extends('Obice100mmL17') -- name append
Weapon('Obice100mmL17Smoke'):Extends('HowitzerSmoke'):Extends('Obice100mmL17') -- name append

-- Type 91 105m howitzer L/24 (JPN)
Weapon('Type91105mmL24'):Extends('Howitzer'):Attrs{
  accuracy           = 1000,
  areaOfEffect       = 125,
  name               = [[Type 91 105mm/24]],
  range              = 7200,
  reloadtime         = 11.25,
  damage = {
    default            = 4050,
  },
}
Weapon('Type91105mmL24HE'):Extends('HowitzerHE'):Extends('Type91105mmL24') -- name append
Weapon('Type91105mmL24Smoke'):Extends('HowitzerSmoke'):Extends('Type91105mmL24') -- name append

-- Return only the full weapons
