-- Armour - Medium Heavy Gun (85 to 100mm)

-- MediumHeavyGun Base Class
local MediumHeavyGunClass = Weapon:New{
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
}

-- HE Round Class
local MediumHeavyGunHEClass = Weapon:New{
  edgeEffectiveness  = 0.15,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30, -- needed?
  accuracy           = 300,
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
local MediumHeavyGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Large]],
  explosionSpeed     = 100, -- needed?
  impactonly         = 1,
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_1]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- Implementations

-- KwK36 8.8cm L/56 (GER)
local KwK88mmL56 = MediumHeavyGunClass:New{
  name               = [[KwK36 8.8cm L/56]],
  range              = 2110,
  reloadTime         = 9.15,
  soundStart         = [[GER_88mm]],
}

local KwK88mmL56HE = KwK88mmL56:New(MediumHeavyGunHEClass, true):New{
  areaOfEffect       = 100,
  weaponVelocity     = 1250,
  damage = {
    default            = 1940,
  },  
}
local KwK88mmL56AP = KwK88mmL56:New(MediumHeavyGunAPClass, true):New{
  weaponVelocity     = 1490,
  customparams = {
    armor_penetration_1000m = 100,
    armor_penetration_100m  = 120,
  },
  damage = {
    default            = 3154,
  },
}

-- KwK43 8.8cm L/71 (GER)
local KwK88mmL71 = MediumHeavyGunClass:New{
  name               = [[KwK43 8.8cm L/71]],
  range              = 2510,
  reloadTime         = 9.75,
  soundStart         = [[GER_88mmL71]],
}

local KwK88mmL71HE = KwK88mmL71:New(MediumHeavyGunHEClass, true):New{
  areaOfEffect       = 96,
  weaponVelocity     = 1250,
  damage = {
    default            = 1740, -- ?
  },  
}
local KwK88mmL71AP = KwK88mmL71:New(MediumHeavyGunAPClass, true):New{
  weaponVelocity     = 2000,
  customparams = {
    armor_penetration_1000m = 165,
    armor_penetration_100m  = 202,
  },
  damage = {
    default            = 3194,
  },
}

-- SK 8.8cm C/30 (GER)
local SK88mmC30 = MediumHeavyGunClass:New(MediumHeavyGunHEClass, true):New{
  areaOfEffect       = 85,
  name               = [[8.8cm SK C/30 Naval Gun]],
  range              = 2110,
  reloadTime         = 4, -- 15rpm
  soundStart         = [[GER_88mm]],
  weaponVelocity     = 1250,
  damage = {
    default            = 1275,
  },  
}


-- S-53 85mm (RUS)
local S5385mm = MediumHeavyGunClass:New{
  name               = [[S-53 85mm]],
  range              = 1605,
  reloadTime         = 6.75,
  soundStart         = [[RUS_85mm]],
}

local S5385mmHE = S5385mm:New(MediumHeavyGunHEClass, true):New{
  areaOfEffect       = 87,
  weaponVelocity     = 1400,
  damage = {
    default            = 1280,
  },  
}
local S5385mmAP = S5385mm:New(MediumHeavyGunAPClass, true):New{
  weaponVelocity     = 1584,
  customparams = {
    armor_penetration_1000m = 86,
    armor_penetration_100m  = 112,
  },
  damage = {
    default            = 3033,
  },
}


-- D-10 100mm (RUS)
local D10S100mm = MediumHeavyGunClass:New{
  name               = [[D-10 100mm]],
  range              = 2260,
  reloadTime         = 10,
  soundStart         = [[RUS_85mm]],
}

local D10S100mmAP = D10S100mm:New(MediumHeavyGunAPClass, true):New{
  weaponVelocity     = 1760,
  customparams = {
    armor_penetration_1000m = 146,
    armor_penetration_100m  = 186,
  },
  damage = {
    default            = 3985,
  },
}


-- M3 90mm (USA)
local M390mm = MediumHeavyGunClass:New{
  name               = [[M3 90mm]],
  range              = 2110,
  reloadTime         = 9.15,
  soundStart         = [[GER_88mm]],
}

local M390mmHE = M390mm:New(MediumHeavyGunHEClass, true):New{
  areaOfEffect       = 100,
  weaponVelocity     = 1250,
  damage = {
    default            = 1940,
  },  
}
local M390mmAP = M390mm:New(MediumHeavyGunAPClass, true):New{
  weaponVelocity     = 1490,
  customparams = {
    armor_penetration_1000m = 107,
    armor_penetration_100m  = 151,
  },
  damage = {
    default            = 3303,
  },
}


-- Return only the full weapons
return lowerkeys({
  -- KwK36 88mm L/56
  KwK88mmL56HE = KwK88mmL56HE,
  KwK88mmL56AP = KwK88mmL56AP,
  -- KwK43 88mm L/71
  KwK88mmL71HE = KwK88mmL71HE,
  KwK88mmL71AP = KwK88mmL71AP,
  -- SK C/30
  SK88mmC30 = SK88mmC30,
  -- S-53 85mm
  S5385mmHE = S5385mmHE,
  S5385mmAP = S5385mmAP,
  -- D-10 100mm
  D10S100mmAP = D10S100mmAP,
  -- M3 90mm
  M390mmHE = M390mmHE,
  M390mmAP = M390mmAP,
})
