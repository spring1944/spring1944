-- Armour - Medium Gun (75 to 76mm)

-- MediumGun Base Class
local MediumGunClass = Weapon:New{
  accuracy           = 100,
  avoidFeature		 = false,
  collisionSize      = 4,
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 600,
  separation         = 2, 
  size               = 1,
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    cegflare           = "MEDIUM_MUZZLEFLASH",
  }
}

-- HE Round Class
local MediumGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_3]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 75,
    fearid             = 401,
  },
}

-- AP Round Class
local MediumGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Medium]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- HEAT Round Class
local MediumGunHEATClass = Weapon:New{
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:EP_medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[HEAT Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[shapedcharge]],
  },
}


-- Implementations

-- QF 75mm (GBR)
local QF75mm = MediumGunClass:New{
  name               = [[QF 75mm Mk.V]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

local QF75mmHE = QF75mm:New(MediumGunHEClass, true):New{
  areaOfEffect       = 88,
  weaponVelocity     = 926,
  damage = {
    default            = 1334,
  },  
}
local QF75mmAP = QF75mm:New(MediumGunAPClass, true):New{
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
local QF17Pdr = MediumGunClass:New{
  name               = [[QF 17Pdr Mk.IV]],
  range              = 1690,
  reloadTime         = 6.75,
  soundStart         = [[US_76mm]],
}

local QF17PdrHE = QF17Pdr:New(MediumGunHEClass, true):New{
  areaOfEffect       = 90,
  weaponVelocity     = 1768,
  damage = {
    default            = 1420,
  },  
}
local QF17PdrAP = QF17Pdr:New(MediumGunAPClass, true):New{
  weaponVelocity     = 1584,
  customparams = {
    armor_penetration_1000m = 119,
    armor_penetration_100m  = 140,
  },
  damage = {
    default            = 2777,
  },
}

-- KwK 40 75mm L/48 (GER)
local KwK75mmL48 = MediumGunClass:New{
  name               = [[7.5cm KwK 40 L/48]],
  range              = 1520,
  reloadTime         = 6.45,
  soundStart         = [[GER_75mm]],
}

local KwK75mmL48HE = KwK75mmL48:New(MediumGunHEClass, true):New{
  areaOfEffect       = 87,
  weaponVelocity     = 1096,
  damage = {
    default            = 1280,
  },  
}
local KwK75mmL48AP = KwK75mmL48:New(MediumGunAPClass, true):New{
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
local KwK75mmL71 = MediumGunClass:New{
  name               = [[7.5cm KwK 42 L/71]],
  range              = 1860,
  reloadTime         = 7.65,
  soundStart         = [[GER_75mmLong]],
}

local KwK75mmL71HE = KwK75mmL71:New(MediumGunHEClass, true):New{
  areaOfEffect       = 85,
  weaponVelocity     = 1096,
  damage = {
    default            = 1220,
  },  
}
local KwK75mmL71AP = KwK75mmL71:New(MediumGunAPClass, true):New{
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
local F3476mm = MediumGunClass:New{
  name               = [[F-34 76.2mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[RUS_76mm]],
}

local F3476mmHE = F3476mm:New(MediumGunHEClass, true):New{
  areaOfEffect       = 103, -- !
  weaponVelocity     = 926,
  damage = {
    default            = 2160,
  },  
}
local F3476mmAP = F3476mm:New(MediumGunAPClass, true):New{
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
local ZiS376mm = MediumGunClass:New{
  name               = [[ZiS-3 76.2mm]],
  range              = 1310,
  reloadTime         = 5.25,
  soundStart         = [[RUS_76mm]],
}

local ZiS376mmHE = ZiS376mm:New(MediumGunHEClass, true):New{
  areaOfEffect       = 103, -- !
  weaponVelocity     = 926,
  damage = {
    default            = 2160,
  },  
}
local ZiS376mmAP = ZiS376mm:New(MediumGunAPClass, true):New{
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
local M375mm = MediumGunClass:New{
  name               = [[M3 75mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

local M375mmHE = M375mm:New(MediumGunHEClass, true):New{
  areaOfEffect       = 88,
  weaponVelocity     = 926,
  damage = {
    default            = 1334,
  },  
}
local M375mmAP = M375mm:New(MediumGunAPClass, true):New{
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
local M7 = MediumGunClass:New{
  name               = [[M7 76.2mm]],
  range              = 1545,
  reloadTime         = 6.75,
  soundStart         = [[US_76mm]],
}

local M7HE = M7:New(MediumGunHEClass, true):New{
  areaOfEffect       = 74,
  weaponVelocity     = 1646,
  damage = {
    default            = 780,
  },  
}
local M7AP = M7:New(MediumGunAPClass, true):New{
  weaponVelocity     = 1584, -- lower than HE?
  customparams = {
    armor_penetration_1000m = 81,
    armor_penetration_100m  = 100,
  },
  damage = {
    default            = 2646,
  },
}

-- Mk22 3inch (USA)
local Mk223in50 = MediumGunClass:New{
  areaOfEffect       = 80,
  name               = [[Mk22 3in L/50]],
  range              = 2000,
  reloadTime         = 3.5, -- 15 - 20 rounds per minute, as per Russian sources
  soundStart         = [[GEN_105mm]], -- :o
  weaponVelocity     = 926,
  damage = {
    default            = 1152,
  },  
}:New(MediumGunHEClass, true)


-- Ansaldo L/18 75mm (ITA)
local Ansaldo75mmL18 = MediumGunClass:New{
  name               = [[Ansaldo L/18 75mm Howitzer]],
  range              = 1310,
  reloadTime         = 6.75,
  soundStart         = [[US_75mm]],
}

local Ansaldo75mmL18HE = Ansaldo75mmL18:New(MediumGunHEClass, true):New{
  areaOfEffect       = 94,
  weaponVelocity     = 800,
  damage = {
    default            = 2509,
  },  
}

local Ansaldo75mmL18HEAT = Ansaldo75mmL18:New(MediumGunHEATClass, true):New{
  range              = 851,
  weaponVelocity     = 600,
  customparams = {
    armor_penetration       = 90,
  },
  damage = {
    default            = 2419,
  },
}

-- Ansaldo L/27 75mm (ITA)
local Ansaldo75mmL27HE = MediumGunClass:New(MediumGunHEClass, true):New{
  areaOfEffect       = 94,
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
local Ansaldo75mmL34 = MediumGunClass:New{
  name               = [[Ansaldo L/34 75mm]],
  range              = 1270,
  reloadTime         = 5.25,
  soundStart         = [[US_75mm]],
}

local Ansaldo75mmL34HE = Ansaldo75mmL34:New(MediumGunHEClass, true):New{
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
local Ansaldo75mmL34AP = Ansaldo75mmL34:New(MediumGunAPClass, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 51,
    armor_penetration_100m  = 89,
  },
  damage = {
    default            = 2280,
  },
}

-- Ansaldo L/46 75mm (ITA) 15 RPM
local Ansaldo75mmL46 = MediumGunClass:New{
  name               = [[Ansaldo L/46 75mm]],
  range              = 1530,
  reloadTime         = 5.0,
  soundStart         = [[GER_75mmLong]],
}

local Ansaldo75mmL46HE = Ansaldo75mmL46:New(MediumGunHEClass, true):New{
  areaOfEffect       = 104,
  weaponVelocity     = 926,
  damage = {
    default            = 1280,
  },  
}

local Ansaldo75mmL46AP = Ansaldo75mmL46:New(MediumGunAPClass, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 86,
    armor_penetration_100m  = 98,
  },
  damage = {
    default            = 2613,
  },
}

-- Ansaldo 76/40 Mod. 1916 R.M. Naval gun (ITA)
local Ansaldo76mmL40HE = MediumGunClass:New(MediumGunHEClass, true):New{
  areaOfEffect       = 76,
  name               = [[Ansaldo 76mm/40 Naval Gun]],
  range              = 1320,
  reloadTime         = 3.8,
  soundStart         = [[GER_75mm]],
  weaponVelocity     = 1300,
  damage = {
    default            = 2150,
  },  
}

-- Type 3 75mm/38 (JPN) 12RPM
local Type375mmL38 = MediumGunClass:New{
  name               = [[Type 3 75mm/38]],
  range              = 1480,
  reloadTime         = 4.85,
  soundStart         = [[GER_75mm]],
}

local Type375mmL38HE = Type375mmL38:New(MediumGunHEClass, true):New{
  areaOfEffect       = 84,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}
local Type375mmL38AP = Type375mmL38:New(MediumGunAPClass, true):New{
  weaponVelocity     = 1358,
  customparams = {
    armor_penetration_1000m = 70,
    armor_penetration_100m  = 91,
  },
  damage = {
    default            = 2490,
  },
}

-- Type 90 75mm (JPN) 7 RPM
local Type9075mm = MediumGunClass:New{
  name               = [[Type 90 75mm]],
  range              = 1270,
  reloadTime         = 6.5,
  soundStart         = [[GER_75mm]],
}

local Type9075mmHE = Type9075mm:New(MediumGunHEClass, true):New{
  areaOfEffect       = 84,
  weaponVelocity     = 926,
  damage = {
    default            = 2260,
  },  
}

local Type9075mmAP = Type9075mm:New(MediumGunAPClass, true):New{
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
local Type376mmL40HE = MediumGunClass:New(MediumGunHEClass, true):New{
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

-- Return only the full weapons
return lowerkeys({
  -- QF 75mm
  QF75mmHE = QF75mmHE,
  QF75mmAP = QF75mmAP,
  -- QF 17Pdr
  QF17PdrHE = QF17PdrHE,
  QF17PdrAP = QF17PdrAP,
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
  -- Ansaldo L/46 75mm
  Ansaldo75mmL46HE = Ansaldo75mmL46HE,
  Ansaldo75mmL46AP = Ansaldo75mmL46AP,
  -- Ansaldo 76/40 Mod. 1916 R.M. Naval gun
  Ansaldo76mmL40HE = Ansaldo76mmL40HE,
  -- Type 3 75mm/38
  Type375mmL38HE = Type375mmL38HE,
  Type375mmL38AP = Type375mmL38AP,
  -- Type 90 75mm
  Type9075mmHE = Type9075mmHE,
  Type9075mmAP = Type9075mmAP,
  -- Type 3 76mm/40 Naval gun (JPN)
  Type376mmL40HE = Type376mmL40HE,
})
