-- Armour - Medium Gun (75 to 76mm)

-- Implementations

-- QF 75mm (GBR)
local QF75mm = MediumGun:New{
  name               = [[QF 75mm Mk.V]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

local QF75mmHE = MediumHE:New(QF75mm, true):New{
  areaOfEffect       = 88,
  weaponVelocity     = 926,
  damage = {
    default            = 1334,
  },  
}
local QF75mmAP = MediumAP:New(QF75mm, true):New{
  weaponVelocity     = 1236,
  customparams = {
    armor_penetration_1000m = 52,
    armor_penetration_100m  = 81,
  },
  damage = {
    default            = 2559,
  },
}

-- QF 17pdr 76mm (GBR)
local QF17Pdr = MediumGun:New{
  name               = [[QF 17Pdr Mk.IV]],
  range              = 1690,
  reloadTime         = 6.75,
  soundStart         = [[US_76mm]],
  customparams = {
    weaponcost    = 19,
  },
}
local QF17PdrHE = MediumHE:New(QF17Pdr, true):New{
  areaOfEffect       = 90,
  weaponVelocity     = 1584,
  damage = {
    default            = 1420,
  },  
}
local QF17PdrAP = MediumAP:New(QF17Pdr, true):New{
  weaponVelocity     = 1768,
  customparams = {
    armor_penetration_1000m = 119,
    armor_penetration_100m  = 140,
  },
  damage = {
    default            = 2777,
  },
}
local QF17PdrMkVIHE = QF17PdrHE:New{
  name               = [[QF 17Pdr Mk.VI]],
  reloadTime         = 8.1,
}
local QF17PdrMkVIAP = QF17PdrAP:New{
  name               = [[QF 17Pdr Mk.VI]],
  reloadTime         = 8.1,
}
-- KwK 40 75mm L/48 (GER)
local KwK75mmL48 = MediumGun:New{
  name               = [[7.5cm KwK 40 L/48]],
  range              = 1520,
  reloadTime         = 6.45,
  soundStart         = [[GER_75mm]],
  customparams = {
    weaponcost    = 16,
  },  
}

local KwK75mmL48HE = MediumHE:New(KwK75mmL48, true):New{
  areaOfEffect       = 87,
  weaponVelocity     = 1096,
  damage = {
    default            = 1280,
  },  
}
local KwK75mmL48AP = MediumAP:New(KwK75mmL48, true):New{
  weaponVelocity     = 1480,
  customparams = {
    armor_penetration_1000m = 81,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2613,
  },
}

-- KwK 42 75mm L/71 (GER)
local KwK75mmL71 = MediumGun:New{
  name               = [[7.5cm KwK 42 L/71]],
  range              = 1860,
  reloadTime         = 7.65,
  soundStart         = [[GER_75mmLong]],
  customparams = {
    weaponcost    = 19,
  },
}

local KwK75mmL71HE = MediumHE:New(KwK75mmL71, true):New{
  areaOfEffect       = 85,
  weaponVelocity     = 1096,
  damage = {
    default            = 1220,
  },  
}
local KwK75mmL71AP = MediumAP:New(KwK75mmL71, true):New{
  weaponVelocity     = 1870,
  customparams = {
    armor_penetration_1000m = 111,
    armor_penetration_100m  = 138,
  },
  damage = {
    default            = 2608,
  },
}

-- F-34 76.2mm (RUS)
local F3476mm = MediumGun:New{
  name               = [[F-34 76.2mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[RUS_76mm]],
}

local F3476mmHE = MediumHE:New(F3476mm, true):New{
  areaOfEffect       = 103, -- !
  weaponVelocity     = 926,
  damage = {
    default            = 2160,
  },  
}
local F3476mmAP = MediumAP:New(F3476mm, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 46,
    armor_penetration_100m  = 67,
  },
  damage = {
    default            = 2510,
  },
}

-- ZiS-3 76.2mm (RUS)
local ZiS376mm = MediumGun:New{
  name               = [[ZiS-3 76.2mm]],
  range              = 1310,
  reloadTime         = 5.25,
  soundStart         = [[RUS_76mm]],
}

local ZiS376mmHE = MediumHE:New(ZiS376mm, true):New{
  areaOfEffect       = 103, -- !
  weaponVelocity     = 926,
  damage = {
    default            = 2160,
  },  
}
local ZiS376mmAP = MediumAP:New(ZiS376mm, true):New{
  weaponVelocity     = 1420,
  customparams = {
    armor_penetration_1000m = 47,
    armor_penetration_100m  = 70,
  },
  damage = {
    default            = 2510,
  },
}

-- M3 75mm (USA)
local M375mm = MediumGun:New{
  name               = [[M3 75mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

local M375mmHE = MediumHE:New(M375mm, true):New{
  areaOfEffect       = 88,
  weaponVelocity     = 926,
  damage = {
    default            = 1334,
  },  
}
local M375mmAP = MediumAP:New(M375mm, true):New{
  weaponVelocity     = 1176,
  customparams = {
    armor_penetration_1000m = 57,
    armor_penetration_100m  = 71,
  },
  damage = {
    default            = 2557,
  },
}

-- M7 76mm (USA)
local M7 = MediumGun:New{
  name               = [[M7 76.2mm]],
  range              = 1545,
  reloadTime         = 6.75,
  soundStart         = [[US_76mm]],
  customparams = {
    weaponcost    = 16,
  },
}

local M7HE = MediumHE:New(M7, true):New{
  areaOfEffect       = 74,
  weaponVelocity     = 1586,
  damage = {
    default            = 780,
  },  
}
local M7AP = MediumAP:New(M7, true):New{
  weaponVelocity     = 1674, 
  customparams = {
    armor_penetration_1000m = 81,
    armor_penetration_100m  = 100,
  },
  damage = {
    default            = 2646,
  },
}
local M7APe8 = M7AP:New{
  movingaccuracy	= 350, -- HVSS buff
}

-- Mk22 3inch (USA)
local Mk223in50 = MediumGun:New{
  areaOfEffect       = 80,
  name               = [[Mk22 3in L/50]],
  range              = 1800,
  reloadTime         = 3.5, -- 15 - 20 rounds per minute, as per Russian sources
  soundStart         = [[GEN_105mm]], -- :o
  weaponVelocity     = 1406,
  damage = {
    default            = 1325,
  },  
}:New(MediumHE, true)


-- Ansaldo L/18 75mm (ITA)
local Ansaldo75mmL18 = MediumGun:New{
  name               = [[Ansaldo L/18 75mm Howitzer]],
  range              = 1310,
  reloadTime         = 6.75,
  soundStart         = [[short_75mm]],
}

local Ansaldo75mmL18HE = MediumHE:New(Ansaldo75mmL18, true):New{
  areaOfEffect       = 94,
  weaponVelocity     = 800,
  damage = {
    default            = 2258,
  },  
}

local Ansaldo75mmL18HEAT = HEAT:New(Ansaldo75mmL18, true):New{
  accuracy	= 500,
  weaponVelocity     = 750,
  customparams = {
    armor_penetration       = 90,
  },
  damage = {
    default            = 2032,
  },
}

-- Ansaldo L/27 75mm (ITA)
local Ansaldo75mmL27HE = MediumGun:New(MediumHE, true):New{
  areaOfEffect       = 98,
  name               = [[Ansaldo L/27 75mm Howitzer]],
  range              = 1390,
  reloadTime         = 6.75,
  soundStart         = [[US_75mm]],
  weaponVelocity     = 820,
  damage = {
    default            = 2509,
  },  
}

-- Ansaldo L/34 75mm (ITA)
local Ansaldo75mmL34 = MediumGun:New{
  name               = [[Ansaldo L/34 75mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

local Ansaldo75mmL34HE = MediumHE:New(Ansaldo75mmL34, true):New{
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
local Ansaldo75mmL34AP = MediumAP:New(Ansaldo75mmL34, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 51,
    armor_penetration_100m  = 89,
  },
  damage = {
    default            = 2412,
  },
}
local Ansaldo75mmL34HEAT = HEAT:New(Ansaldo75mmL34, true):New{
  weaponVelocity     = 1358,
  accuracy	= 500,
  customparams = {
    armor_penetration       = 120,
  },
  damage = {
    default            = 2010,
  },
}

-- Ansaldo L/46 75mm (ITA) 15 RPM
local Ansaldo75mmL46 = MediumGun:New{
  name               = [[Ansaldo L/46 75mm]],
  range              = 1530,
  reloadTime         = 5.0,
  soundStart         = [[GER_75mmLong]],
  customparams = {
    weaponcost    = 16,
  },  
}

local Ansaldo75mmL46HE = MediumHE:New(Ansaldo75mmL46, true):New{
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 1280,
  },  
}

local Ansaldo75mmL46AP = MediumAP:New(Ansaldo75mmL46, true):New{
  weaponVelocity     = 1658,
  customparams = {
    armor_penetration_1000m = 90,
    armor_penetration_100m  = 118,
  },
  damage = {
    default            = 2613,
  },
}

-- Ansaldo 76/40 Mod. 1916 R.M. Naval gun (ITA)
local Ansaldo76mmL40HE = MediumGun:New(MediumHE, true):New{
  areaOfEffect       = 96,
  name               = [[Ansaldo 76mm/40 Naval Gun]],
  range              = 1320,
  reloadTime         = 3.8,
  soundStart         = [[GER_75mm]],
  weaponVelocity     = 1100,
  damage = {
    default            = 1828,
  },  
}

-- Type 3 75mm/38 (JPN) 12RPM
local Type375mmL38 = MediumGun:New{
  name               = [[Type 3 75mm/38]],
  range              = 1480,
  reloadTime         = 4.85,
  soundStart         = [[JPN_75mm]],
  customparams = {
    weaponcost    = 16,
  },  
}

local Type375mmL38HE = MediumHE:New(Type375mmL38, true):New{
  areaOfEffect       = 84,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
local Type375mmL38AP = MediumAP:New(Type375mmL38, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 70,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2490,
  },
}
-- Type 5 75mm/56.4 (JPN) 
local Type575mmL56 = MediumGun:New{
  name               = [[Type 5 75mm/56]],
  range              = 1770, -- good sights
  reloadTime         = 6.5,
  soundStart         = [[JPN_type5_75mm]],
  customparams = {
    weaponcost    = 17,
  },  
}

local Type575mmL56HE = MediumHE:New(Type575mmL56, true):New{
  areaOfEffect       = 82,
  weaponVelocity     = 1026,
  damage = {
    default            = 2200,
  },  
}
local Type575mmL56AP = MediumAP:New(Type575mmL56, true):New{
  weaponVelocity     = 1728,
  customparams = {
    armor_penetration_1000m = 80,
    armor_penetration_100m  = 122,
  },
  damage = {
    default            = 2450,
  },
}
-- Type 90 75mm (JPN) 7 RPM
local Type9075mm = MediumGun:New{
  name               = [[Type 90 75mm]],
  range              = 1270,
  reloadTime         = 6.5,
  soundStart         = [[JPN_75mm]],
  customparams = {
    weaponcost    = 16,
  },  
}

local Type9075mmHE = MediumHE:New(Type9075mm, true):New{
  areaOfEffect       = 84,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}

local Type9075mmAP = MediumAP:New(Type9075mm, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 70,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2490,
  },
}

-- Type 3 76mm/40 Naval gun (JPN)
local Type376mmL40HE = MediumGun:New(MediumHE, true):New{
  areaOfEffect       = 80,
  name               = [[Type 3 76mm/40 Naval gun]],
  range              = 1300,
  reloadTime         = 4,
  soundStart         = [[GER_75mm]],
  weaponVelocity     = 1300,
  damage = {
    default            = 2250,
  },  
}

-- 75 mm m/41 gun L/34 (SWE)
local SWE75mmL34 = MediumGun:New{
  name               = [[75 mm m/41 gun L/34]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[SWE_75_mm_Strv_42]],
}

local SWE75mmL34HE = MediumHE:New(SWE75mmL34, true):New{
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
local SWE75mmL34AP = MediumAP:New(SWE75mmL34, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 51,
    armor_penetration_100m  = 89,
  },
  damage = {
    default            = 2280,
  },
}

-- Hungary
local Mavag_75_41M = MediumGun:New{
  name               = [[MAVAG 41.M 75mm/24]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[short_75mm]],
}

local Mavag_75_41MHE = MediumHE:New(Mavag_75_41M, true):New{
  areaOfEffect       = 91,
  weaponVelocity     = 926,
  damage = {
    default            = 1534,
  },  
}

-- 42/36M páncélgránát
local Mavag_75_41MAP = MediumAP:New(Mavag_75_41M, true):New{
  weaponVelocity     = 1176,
  customparams = {
    armor_penetration_1000m = 45,
    armor_penetration_100m  = 56,
  },
  damage = {
    default            = 2557,
  },
}

-- 7,5 cm 42M páncélrobbantó gránát
local Mavag_75_41MHEAT = HEAT:New(Mavag_75_41M, true):New{
  weaponVelocity     = 1158,
  accuracy	= 500,
  customparams = {
    armor_penetration       = 70,
  },
  damage = {
    default            = 2045,
  },
}

local Mavag_75_43MHE = MediumHE:New(KwK75mmL48, true):New{
	name				= [[MAVAG 43.M 75mm]],
	areaOfEffect       = 87,
	weaponVelocity     = 1096,
	damage = {
		default            = 1280,
	},  
}
local Mavag_75_43MAP = MediumAP:New(KwK75mmL48, true):New{
	name				= [[MAVAG 43.M 75mm]],
	weaponVelocity     = 1480,
	customparams = {
		armor_penetration_1000m = 81,
		armor_penetration_100m  = 91,
	},
	damage = {
		default            = 2613,
	},
}

-- France
local FRA75mmSA35 = MediumGun:New{
	name               = [[75mm SA35 L17]],
	range              = 1270,
	reloadTime         = 6,	-- sources say 15-30, but that's too much for manually loaded 75mm
	soundStart         = [[short_75mm]],
}

local FRA75mmSA35HE = MediumHE:New(FRA75mmSA35, true):New{
	areaOfEffect       = 88,
	weaponVelocity     = 926,
	damage = {
		default            = 1334,
	},
}

-- 75mm Mle1897
local FRA75mmMle1897 = M375mm:New{
	name				= [[Canon de 75 modèle 1897]],
}

local FRA75mmMle1897HE = M375mmHE:New{
	name				= [[Canon de 75 modèle 1897 HE]],
}

local FRA75mmMle1897AP = M375mmAP:New{
	name				= [[Canon de 75 modèle 1897 AP]],
	customparams = {
		armor_penetration_1000m = 52,
		armor_penetration_100m  = 62,
	},
}

-- Return only the full weapons
return lowerkeys({
  -- QF 75mm
  QF75mmHE = QF75mmHE,
  QF75mmAP = QF75mmAP,
  -- QF 17Pdr
  QF17PdrHE = QF17PdrHE,
  QF17PdrAP = QF17PdrAP,
  QF17PdrMkVIHE = QF17PdrMkVIHE,
  QF17PdrMkVIAP = QF17PdrMkVIAP,
  -- KwK 40 L/48
  KwK75mmL48HE = KwK75mmL48HE,
  KwK75mmL48AP = KwK75mmL48AP,
  -- KwK 40 L/71
  KwK75mmL71HE = KwK75mmL71HE,
  KwK75mmL71AP = KwK75mmL71AP,
  -- F-34 76.2mm
  F3476mmHE = F3476mmHE,
  F3476mmAP = F3476mmAP,
  -- ZiS-3 76.2mm
  ZiS376mmHE = ZiS376mmHE,
  ZiS376mmAP = ZiS376mmAP,
  -- M3 75mm
  M375mmHE = M375mmHE,
  M375mmAP = M375mmAP,
  -- M7 76mm
  M7HE = M7HE,
  M7AP = M7AP,
  M7APe8 = M7APe8,
  -- Mk22 3inch
  Mk223in50 = Mk223in50,
  -- Ansaldo L/18 75mm
  Ansaldo75mmL18HE = Ansaldo75mmL18HE,
  Ansaldo75mmL18HEAT = Ansaldo75mmL18HEAT,
  -- Ansaldo L/27 75mm
  Ansaldo75mmL27HE = Ansaldo75mmL27HE,
  -- Ansaldo L/34 75mm
  Ansaldo75mmL34HE = Ansaldo75mmL34HE,
  Ansaldo75mmL34AP = Ansaldo75mmL34AP,
  Ansaldo75mmL34HEAT = Ansaldo75mmL34HEAT,
  -- Ansaldo L/46 75mm
  Ansaldo75mmL46HE = Ansaldo75mmL46HE,
  Ansaldo75mmL46AP = Ansaldo75mmL46AP,
  -- Ansaldo 76/40 Mod. 1916 R.M. Naval gun
  Ansaldo76mmL40HE = Ansaldo76mmL40HE,
  -- Type 3 75mm/38
  Type375mmL38HE = Type375mmL38HE,
  Type375mmL38AP = Type375mmL38AP,
  -- Type 5 75mm/56
  Type575mmL56HE = Type575mmL56HE,
  Type575mmL56AP = Type575mmL56AP,
  -- Type 90 75mm
  Type9075mmHE = Type9075mmHE,
  Type9075mmAP = Type9075mmAP,
  -- Type 3 76mm/40 Naval gun (JPN)
  Type376mmL40HE = Type376mmL40HE,
  SWE75mmL34HE = SWE75mmL34HE,
  SWE75mmL34AP = SWE75mmL34AP,
  Mavag_75_41MAP = Mavag_75_41MAP,
  Mavag_75_41MHE = Mavag_75_41MHE,
  Mavag_75_41MHEAT = Mavag_75_41MHEAT,
  Mavag_75_43MAP = Mavag_75_43MAP,
  Mavag_75_43MHE = Mavag_75_43MHE,
  -- France
  FRA75mmSA35HE = FRA75mmSA35HE,
  FRA75mmMle1897HE = FRA75mmMle1897HE,
  FRA75mmMle1897AP = FRA75mmMle1897AP,
})
