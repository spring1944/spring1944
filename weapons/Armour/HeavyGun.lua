-- Armour - Heavy Gun (120 to 152mm)

-- Implementations

-- D-25T 122mm (RUS)
local D25122mm = HeavyGun:New{
  name               = [[D-25T 122mm]],
  range              = 2530,
  reloadTime         = 15,
  soundStart         = [[RUS_122mm]],
}

local D25122mmHE = HeavyHE:New(D25122mm, true):New{
  areaOfEffect       = 154,
  weaponVelocity     = 900,
  damage = {
    default            = 7200,
  },  
}
local D25122mmAP = HeavyAP:New(D25122mm, true):New{
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
local ML20S152mm = HeavyGun:New{
  name               = [[ML-20S 152mm Howitzer]],
  range              = 1950,
  reloadTime         = 17.5,
  soundStart         = [[RUS_152mm]],
  customparams = {
    cegflare           = "XLARGE_MUZZLEFLASH",
	weaponcost         = 63,
  },
}

local ML20S152mmHE = HeavyHE:New(ML20S152mm, true):New{
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
local ML20S152mmAP = HeavyAP:New(ML20S152mm, true):New{
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
local Short120mmHE = HeavyGun:New(HeavyHE, true):New{
  areaOfEffect       = 129,
  name               = [[Short Naval 120mm]],
  range              = 1620,
  reloadtime         = 11.25,
  soundStart         = [[GEN_105mm]],
  weaponVelocity     = 700,
  damage = {
    default            = 5800,
  },
}

-- Type 38 150mm Howitzer L/11 (JPN)
local Type38150mmL11 = HeavyGun:New{
  name               = [[Type 38 150mm/11]],
  soundStart         = [[150mmtype38]],
  
  range              = 1900,
  reloadtime         = 15,
  weaponVelocity     = 700,
  customparams = {
  	weaponcost         = 63,
  },
}

local Type38150mmL11HE = HeavyHE:New(Type38150mmL11, true):New{
  areaOfEffect       = 165,
  soundHitDry        = [[GEN_Explo_6]],
  damage = {
    default            = 8500,
  },
}
local Type38150mmL11Smoke = HeavySmoke:New(Type38150mmL11, true)

-- -- 15 cm Positionshaubits m 06
local haubm06150mmL11 = HeavyGun:New{
  name               = [[15cm haub m/06]],
  soundStart         = [[150mmtype38]],
  
  range              = 2280,
  reloadtime         = 18,
  weaponVelocity     = 750,
  customparams = {
  	weaponcost         = 64,
  },
}

local haubm06150mmL11HE = HeavyHE:New(haubm06150mmL11, true):New{
  areaOfEffect       = 158,
  soundHitDry        = [[GEN_Explo_6]],
  damage = {
    default            = 9200,
  },
}
local haubm06150mmL11Smoke = HeavySmoke:New(haubm06150mmL11, true)
-- 12.8cm Flak40
--flak40_12_8cm
local Flak40_12_8cm = HeavyGun:New{
    name            = [[12.8cm Flak40]],
    soundStart      = [[RUS_122mm]],
    range           = 2500,
    reloadTime      = 10,
    weaponVelocity  = 2000,
}

local Flak40_12_8cm_HE = HeavyHE:New(Flak40_12_8cm, true):New{
    areaOfEffect       = 120,
    damage = {
        default         = 5000,
    }
}

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
  -- Haub M06 150mm L11
  haubm06150mmL11HE = haubm06150mmL11HE,
  haubm06150mmL11Smoke = haubm06150mmL11Smoke,
  -- Flak40
  Flak40_12_8cm_HE = Flak40_12_8cm_HE,
})
