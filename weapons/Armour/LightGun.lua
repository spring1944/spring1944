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
}

-- HE Round Class
local LightGunHEClass = Weapon:New{
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
})
