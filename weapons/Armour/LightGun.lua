-- Armour - Light Gun (37 to 45mm)

-- Implementations

-- QF 2Pdr 40mm (GBR)
local QF2Pdr40mm = LightGun:New{
  name               = [[QF 2 Pdr Mk.X]],
  range              = 1070,
  reloadTime         = 4.5,
}

local QF2Pdr40mmHE = QF2Pdr40mm:New(LightHE, true):New{
  areaOfEffect       = 42,
  weaponVelocity     = 1584,
  damage = {
    default            = 350,
  },  
}
local QF2Pdr40mmAP = QF2Pdr40mm:New(LightAP, true):New{
  weaponVelocity     = 1616,
  customparams = {
    armor_penetration_1000m = 45,
    armor_penetration_100m  = 59,
  },
  damage = {
    default            = 1105,
  },
}

-- M6 37mm (USA)
local M637mm = LightGun:New{
  name               = [[37mm M6]],
  range              = 1010,
  reloadTime         = 4.5,
}

-- Canister is radically different!
local M637mmCanister = M637mm:New({
  areaOfEffect       = 10,
  coreThickness      = 0.15,
  duration           = 0.01,
  edgeEffectiveness  = 1,
  explosionGenerator = [[custom:Bullet]],
  explosionSpeed     = 100, -- needed?
  intensity          = 0.7,
  laserFlareSize     = 0.0001,
  name               = [[Canister Shot]],
  projectiles        = 122,
  range              = 550,
  rgbColor           = [[1.0 0.75 0.0]],
  soundTrigger       = true,
  sprayAngle         = 3000,
  targetMoveError    = 0.1,
  thickness          = 0.3,
  weaponType         = [[LaserCannon]], -- this is why it's so different
  weaponVelocity     = 1400,
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 20,
    fearid             = 301,
  },
  damage = {
    default            = 150,
  },  
}, true)

local M637mmHE = M637mm:New(LightHE, true):New{
  areaOfEffect       = 44,
  weaponVelocity     = 1584,
  damage = {
    default            = 228,
  },  
}
local M637mmAP = M637mm:New(LightAP, true):New{
  weaponVelocity     = 1768,
  customparams = {
    armor_penetration_1000m = 46,
    armor_penetration_100m  = 63,
  },
  damage = {
    default            = 933,
  },
}

-- M1938 20K 45mm (RUS)
local M1938_20K45mm = LightGun:New{
  name               = [[20K M1938 45mm]],
  range              = 980,
  reloadTime         = 4.8, -- Naval is 2.4 HE, 3.2 AP?
  soundStart         = [[RUS_45mm]],
}

local M1938_20K45mmHE = M1938_20K45mm:New(LightHE, true):New{
  areaOfEffect       = 52, -- Naval is 47?
  weaponVelocity     = 1584,
  damage = {
    default            = 270, -- Naval is 200?
  },  
}
local M1938_20K45mmAP = M1938_20K45mm:New(LightAP, true):New{
  weaponVelocity     = 1518, -- Naval (unused) is 1768?
  customparams = {
    armor_penetration_1000m = 20,
    armor_penetration_100m  = 43, -- These seem very low!
  },
  damage = {
    default            = 1565,
  },
}

-- Naval copy, only HE used currently. Should these values be so different?
local M1937_40K45mmHE = M1938_20K45mmHE:New{
  areaOfEffect         = 47,
  name                 = [[40K 45mm Naval Gun HE Shell]],
  range                = 1310,
  reloadTime           = 2.4, -- this one probably makes the most sense if its an open mount as opposed to cramped turret
  damage = {
    default            = 200,
  },  
}

-- Cannone da 47/32 M35 (ITA)
local CannoneDa47mml32 = LightGun:New{
  name                 = [[47 mm L/32 Gun]],
  range                = 980,
  reloadTime           = 4.8,
  soundStart           = [[ITA_M35_47mm]],
}

local CannoneDa47mml32AP = CannoneDa47mml32:New(LightAP, true):New{
  weaponVelocity       = 1000,
  customparams = {
    armor_penetration_1000m = 32,
    armor_penetration_100m  = 57,
  },
  damage = {
    default            = 1200,
  },
}

local CannoneDa47mml32HEAT = CannoneDa47mml32:New(HEAT, true):New{
  range                = 637,
  weaponVelocity       = 800,
  customparams = {
    armor_penetration       = 75,
  },
  damage = {
    default            = 1048,
  },
}

-- Cannone da 47/40 (ITA)
-- it had some links:
-- https://web.archive.org/web/20081021061843/http://ww2armor.jexiste.fr/Files/Axis/Axis/1-Vehicles/Italy/2-MediumTanks/M13-40/2-Design.htm
-- http://www.quarry.nildram.co.uk/ammotable6.htm
local CannoneDa47mml40 = LightGun:New{
  name                 = [[47 mm L/40 Gun]],
  range                = 1090,
  reloadTime           = 4.4,
  soundStart           = [[ITA_M39_47mm]],
}

local CannoneDa47mml40HE = CannoneDa47mml40:New(LightHE, true):New{
  areaOfEffect       = 52,
  weaponVelocity     = 1084,
  damage = {
    default            = 270,
  },  
}

local CannoneDa47mml40AP = CannoneDa47mml40:New(LightAP, true):New{
  weaponVelocity     = 1818,
  customparams = {
    armor_penetration_1000m = 43,
    armor_penetration_100m  = 71,
  },
  damage = {
    default            = 1225,
  },
}


-- Type 1 37mm (JPN)
local Type137mm = LightGun:New{
  name                 = [[Type 1 37 mm Gun]],
  range                = 950,
  reloadTime           = 4.4,
  soundStart           = [[US_37mm]],
}

local Type137mmHE = Type137mm:New(LightHE, true):New{
  areaOfEffect       = 26,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

local Type137mmAP = Type137mm:New(LightAP, true):New{
  weaponVelocity     = 1118,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 50,
  },
  damage = {
    default            = 818,
  },
}


-- Type 98 37mm (JPN)
local Type9837mm = LightGun:New{
  name                 = [[Type 98 37 mm Gun]],
  range                = 930,
  reloadTime           = 4.0,
  soundStart           = [[RUS_45mm]],
}

local Type9837mmHE = Type9837mm:New(LightHE, true):New{
  areaOfEffect       = 28,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

local Type9837mmAP = Type9837mm:New(LightAP, true):New{
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 20,
    armor_penetration_100m  = 40,
  },
  damage = {
    default            = 818,
  },
}

-- Type 94 37mm (JPN)
local Type9437mm = LightGun:New{
  name                 = [[Type 94 37 mm Gun]],
  range                = 900,
  reloadTime           = 4.8,
  soundStart           = [[RUS_45mm]],
}

local Type9437mmHE = Type9437mm:New(LightHE, true):New{
  areaOfEffect       = 32,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

local Type9437mmAP = Type9437mm:New(LightAP, true):New{
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 40,
  },
  damage = {
    default            = 900,
  },
}

-- Type 1 47mm (JPN)
local Type147mm = LightGun:New{
  name                 = [[Type 1 47 mm Gun]],
  range                = 1100,
  reloadTime           = 4.5,
  soundStart           = [[RUS_45mm]],
}

local Type147mmHE = Type147mm:New(LightHE, true):New{
  areaOfEffect       = 38,
  weaponVelocity     = 800,
  damage = {
    default            = 350,
  },
}

local Type147mmAP = Type147mm:New(LightAP, true):New{
  weaponVelocity     = 1118,
  customparams = {
    armor_penetration_1000m = 53,
    armor_penetration_100m  = 76,
  },
  damage = {
    default            = 1183,
  },
}


-- Return only the full weapons
return lowerkeys({
  -- QF 2Pdr
  QF2Pdr40mmHE = QF2Pdr40mmHE,
  QF2Pdr40mmAP = QF2Pdr40mmAP,
  -- M6 37mm
  M637mmHE = M637mmHE,
  M637mmAP = M637mmAP,
  M637mmCanister = M637mmCanister,
  -- M1938 20K 45mm
  M1938_20K45mmHE = M1938_20K45mmHE,
  M1938_20K45mmAP = M1938_20K45mmAP,
  -- M1936 40K 45mm
  M1937_40K45mmHE = M1937_40K45mmHE,
  -- Cannone da 47/32 M35
  CannoneDa47mml32AP = CannoneDa47mml32AP,
  CannoneDa47mml32HEAT = CannoneDa47mml32HEAT,
  -- Cannone da 47/40
  CannoneDa47mml40HE = CannoneDa47mml40HE,
  CannoneDa47mml40AP = CannoneDa47mml40AP,
  -- Japanese 37mms
  Type137mmHE = Type137mmHE,
  Type137mmAP = Type137mmAP,
  Type9837mmHE = Type9837mmHE,
  Type9837mmAP = Type9837mmAP,
  Type9437mmHE = Type9437mmHE,
  Type9437mmAP = Type9437mmAP,
  -- Type 1 47mm
  Type147mmHE = Type147mmHE,
  Type147mmAP = Type147mmAP,
})
