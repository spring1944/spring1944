-- Armour - Heavy Gun (120 to 152mm)

-- HeavyGun Base Class
local HeavyGunClass = Weapon:New{
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
local HeavyGunHEClass = Weapon:New{
  accuracy           = 300,
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:HE_XLarge]],
  explosionSpeed     = 30, -- needed?
  name               = [[HE Shell]],
  rgbColor           = [[0.5 0.5 0.0]],
  soundHitDry        = [[GEN_Explo_4]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 75,
    fearid             = 501,
  },
}

-- AP Round Class
local HeavyGunAPClass = Weapon:New{
  areaOfEffect       = 10,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  edgeEffectiveness  = 0.1,
  explosionGenerator = [[custom:AP_Large]],
  explosionSpeed     = 100, -- needed?
  name               = [[AP Shell]],
  soundHitDry        = [[GEN_Explo_2]],
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- Smoke Round Class
local HeavyGunSmokeClass = HeavyGunHEClass:New{
  areaOfEffect       = 30,
  explosionGenerator = [[custom:HE_Large]],
  name               = [[Smoke Shell]],
  customparams = {
    smokeradius        = 350,
    smokeduration      = 50,
    smokeceg           = [[SMOKESHELL_Medium]],
  },
  damage = {
    default = 100,
  } ,
}

-- Implementations

-- D-25T 122mm (RUS)
local D25122mm = HeavyGunClass:New{
  name               = [[D-25T 122mm]],
  range              = 2530,
  reloadTime         = 15,
  soundStart         = [[RUS_122mm]],
}

local D25122mmHE = D25122mm:New(HeavyGunHEClass, true):New{
  areaOfEffect       = 154,
  weaponVelocity     = 900,
  damage = {
    default            = 7200,
  },  
}
local D25122mmAP = D25122mm:New(HeavyGunAPClass, true):New{
  weaponVelocity     = 1584,
  customparams = {
    armor_penetration_1000m = 131,
    armor_penetration_100m  = 162,
  },
  damage = {
    default            = 4990,
  },
}

-- ML-20S 152mm (RUS)
local ML20S152mm = HeavyGunClass:New{
  name               = [[ML-20S 152mm Howitzer]],
  range              = 1750,
  reloadTime         = 17.5,
  soundStart         = [[RUS_152mm]],
}

local ML20S152mmHE = ML20S152mm:New(HeavyGunHEClass, true):New{
  areaOfEffect       = 183,
  soundHitDry        = [[GEN_Explo_6]],
  weaponVelocity     = 1200, --?
  damage = {
    default            = 12000,
  },  
  customparams = {
    fearaoe            = 150,
  },
}
local ML20S152mmAP = ML20S152mm:New(HeavyGunAPClass, true):New{
  soundHitDry        = [[GEN_Explo_4]],
  weaponVelocity     = 1200,
  customparams = {
    armor_penetration_1000m = 99,
    armor_penetration_100m  = 109,
  },
  damage = {
    default            = 6325,
  },
}

-- 120mm Short Gun (JPN)
local Short120mmHE = HeavyGunClass:New(HeavyGunHEClass, true):New{
  areaOfEffect       = 129,
  name               = [[Short Naval 120mm]],
  range              = 1720,
  reloadtime         = 11.25,
  soundStart         = [[GEN_105mm]],
  weaponVelocity     = 700,
  damage = {
    default            = 5800,
  },
}

-- Type 38 150mm Howitzer L/11 (JPN)
local Type38150mmL11 = HeavyGunClass:New{
  name               = [[Type 38 150mm/11]],
  soundStart         = [[150mmtype38]],
  
  range              = 1700,
  reloadtime         = 15,
  weaponVelocity     = 700,
}

local Type38150mmL11HE = Type38150mmL11:New(HeavyGunHEClass, true):New{
  areaOfEffect       = 165,
  soundHitDry        = [[GEN_Explo_6]],
  damage = {
    default            = 8500,
  },
}
local Type38150mmL11Smoke = Type38150mmL11:New(HeavyGunSmokeClass, true)


-- Return only the full weapons
return lowerkeys({
  -- D-25T 122mm
  D25122mmHE = D25122mmHE,
  D25122mmAP = D25122mmAP,
  -- ML-20S 152mm
  ML20S152mmHE = ML20S152mmHE,
  ML20S152mmAP = ML20S152mmAP,
  -- 120mm Short Gun (JPN)
  Short120mmHE = Short120mmHE,
  -- Type 38 150mm Howitzer L/11
  Type38150mmL11HE = Type38150mmL11HE,
  Type38150mmL11Smoke = Type38150mmL11Smoke,
})
