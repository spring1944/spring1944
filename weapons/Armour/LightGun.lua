-- Armour - Light Gun (37 to 45mm)

-- LightGun Base Class
local LightGunClass = Weapon:New{
  accuracy           = 100,
  collisionSize      = 4,
  impulseFactor      = 0,
  intensity          = 0.25,
  leadBonus          = 0.5,
  leadLimit          = 0,
  movingAccuracy     = 500, --590 for 2pdr?
  separation         = 2, 
  size               = 1,
  soundStart         = [[US_37mm]], -- move later?
  stages             = 50,
  tolerance          = 300,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    cegflare           = "XSMALL_MUZZLEFLASH",
  }
}

-- HE Round Class
local LightGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:HE_Small]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 40,
    fearid             = 301,
  },
}

-- AP Round Class
local LightGunAPClass = Weapon:New{
  areaOfEffect       = 5,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Small]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- HEAT Round Class
local LightGunHEATClass = Weapon:New{
  collisionSize      = 3,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:EP_medium]],
  explosionSpeed     = 30, -- needed?
  name               = [[AP Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[shapedcharge]],
  },
}

-- Implementations

-- QF 2Pdr 40mm (GBR)
local QF2Pdr40mm = LightGunClass:New{
  name               = [[QF 2 Pdr Mk.X]],
  range              = 1070,
  reloadTime         = 4.5,
}

local QF2Pdr40mmHE = QF2Pdr40mm:New(LightGunHEClass, true):New{
  areaOfEffect       = 42,
  weaponVelocity     = 1584,
  damage = {
    default            = 350,
  },  
}
local QF2Pdr40mmAP = QF2Pdr40mm:New(LightGunAPClass, true):New{
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
local M637mm = LightGunClass:New{
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

local M637mmHE = M637mm:New(LightGunHEClass, true):New{
  areaOfEffect       = 44,
  weaponVelocity     = 1584,
  damage = {
    default            = 228,
  },  
}
local M637mmAP = M637mm:New(LightGunAPClass, true):New{
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
local M1938_20K45mm = LightGunClass:New{
  name               = [[20K M1938 45mm]],
  range              = 980,
  reloadTime         = 4.8, -- Naval is 2.4 HE, 3.2 AP?
  soundStart         = [[RUS_45mm]],
}

local M1938_20K45mmHE = M1938_20K45mm:New(LightGunHEClass, true):New{
  areaOfEffect       = 52, -- Naval is 47?
  weaponVelocity     = 1584,
  damage = {
    default            = 270, -- Naval is 200?
  },  
}
local M1938_20K45mmAP = M1938_20K45mm:New(LightGunAPClass, true):New{
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
local CannoneDa47mml32 = LightGunClass:New{
  movingAccuracy       = 600,
  name                 = [[47 mm L/32 Gun]],
  range                = 980,
  reloadTime           = 4.8,
  soundStart           = [[ITA_M35_47mm]],
}

local CannoneDa47mml32AP = CannoneDa47mml32:New(LightGunAPClass, true):New{
  weaponVelocity       = 1000,
  customparams = {
    armor_penetration_1000m = 32,
    armor_penetration_100m  = 57,
  },
  damage = {
    default            = 1200,
  },
}

local CannoneDa47mml32HEAT = CannoneDa47mml32:New(LightGunHEATClass, true):New{
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
local CannoneDa47mml40 = LightGunClass:New{
  movingAccuracy       = 600,
  name                 = [[47 mm L/40 Gun]],
  range                = 1090,
  reloadTime           = 4.4,
  soundStart           = [[ITA_M39_47mm]],
}

local CannoneDa47mml40HE = CannoneDa47mml40:New(LightGunHEClass, true):New{
  areaOfEffect       = 52,
  weaponVelocity     = 1084,
  damage = {
    default            = 270,
  },  
}

local CannoneDa47mml40AP = M637mm:New(LightGunAPClass, true):New{
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
local Type137mm = LightGunClass:New{
  movingAccuracy       = 600,
  name                 = [[Type 1 37 mm Gun]],
  range                = 950,
  reloadTime           = 4.0,
  soundStart           = [[RUS_45mm]],
}

local Type137mmHE = Type137mm:New(LightGunHEClass, true):New{
  areaOfEffect       = 26,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

local Type137mmAP = Type137mm:New(LightGunAPClass, true):New{
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
local Type9837mm = LightGunClass:New{
  movingAccuracy       = 600,
  name                 = [[Type 97 37 mm Gun]],
  range                = 930,
  reloadTime           = 4.0,
  soundStart           = [[RUS_45mm]],
}

local Type9837mmHE = Type9837mm:New(LightGunHEClass, true):New{
  areaOfEffect       = 28,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

local Type9837mmAP = Type9837mm:New(LightGunAPClass, true):New{
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 20,
    armor_penetration_100m  = 40,
  },
  damage = {
    default            = 818,
  },
}

-- Type 98 37mm (JPN)
local Type9437mm = LightGunClass:New{
  movingAccuracy       = 600,
  name                 = [[Type 94 37 mm Gun]],
  range                = 900,
  reloadTime           = 4.0,
  soundStart           = [[RUS_45mm]],
}

local Type9437mmHE = Type9437mm:New(LightGunHEClass, true):New{
  areaOfEffect       = 28,
  weaponVelocity     = 800,
  damage = {
    default            = 220,
  },
}

local Type9437mmAP = Type9437mm:New(LightGunAPClass, true):New{
  weaponVelocity     = 1518,
  customparams = {
    armor_penetration_1000m = 25,
    armor_penetration_100m  = 40,
  },
  damage = {
    default            = 900,
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
  Type9837mmAP = Type9837mmHE,
  Type9437mmHE = Type9437mmHE,
  Type9437mmAP = Type9437mmHE,
  
})
