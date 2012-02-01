-- Artillery - Auto Cannon (Light AA Guns)

-- AC Base Class
local ACClass = Weapon:New{
  collisionSize      = 2,
  edgeEffectiveness  = 0.5,
  explosionSpeed     = 100, -- needed?
  impulseFactor      = 0,
  movingAccuracy     = 500,
  predictBoost       = 0,
  size               = 1e-13, -- visuals done with tracers, except AP rounds
  soundHit           = [[GEN_Explo_1]],
  targetMoveError    = 0.1,
  tolerance          = 700,
  turret             = true,
  weaponType         = [[Cannon]],
}

-- AA Round Class
local ACAAClass = Weapon:New{
  accuracy           = 0,
  burnblow           = true,
  areaOfEffect       = 30,
  canattackground    = false,
  collisionSize      = 5,
  explosionGenerator = [[custom:HE_Small]],
  movingAccuracy     = 0,
  name               = [[AA Shell]],
  soundHit           = [[GEN_Explo_Flak1]],
  targetMoveError    = 0,
  tolerance          = 1400,
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 450,
    fearid             = 701,
  },
}

-- HE Round Class
local ACHEClass = Weapon:New{
  areaOfEffect       = 24,
  explosionGenerator = [[custom:HE_XSmall]],
  name               = [[HE Shell]],
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 40, -- flak 38 was 45?
    fearid             = 301,
  },
}

-- AP Round Class
local ACAPClass = Weapon:New{
  areaOfEffect       = 2,
  canattackground    = false,
  colormap           = [[ap_colormap.png]],
  explosionGenerator = [[custom:AP_XSmall]],
  intensity          = 0.1,
  name               = [[AP Shell]],
  separation         = 2,
  size               = 1,  
  stages             = 50,
  customparams = {
    damagetype         = [[kinetic]],
  },  
}

-- Implementations

-- FlaK 38 20mm (GER)
local FlaK3820mm = ACClass:New{
  accuracy           = 255,
  burst              = 3,
  burstRate          = 0.16,
  name               = [[2cm FlaK 38]],
  range              = 730,
  reloadTime         = 3,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 1800,
  damage = {
    default            = 110,
  },
}

local FlaK3820mmAA = FlaK3820mm:New(ACAAClass, true):New{
  burst              = 5,
  burstRate          = 0.13,
  range              = 1910,
}
local FlaK3820mmHE = FlaK3820mm:New(ACHEClass, true)
local FlaK3820mmAP = FlaK3820mm:New(ACAPClass, true):New{
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 9,
    armor_penetration_100m  = 20,
  },
  damage = {
    default            = 385,
  },
}

-- Flakvierling
-- derives from the above, only with 1/4 the burstrate and 4x burst
local FlakVierling20mmAA = FlaK3820mmAA:New({
  burst              = 20,
  burstrate          = 0.0325,
  name               = [[(Quad)]],
}, true)
local FlakVierling20mmHE = FlaK3820mmHE:New({
  burst              = 12,
  burstrate          = 0.04,
  name               = [[(Quad)]],
}, true)

-- Oerlikon/Polsten 20mm (GBR)
local Oerlikon20mm = ACClass:New{
  accuracy           = 255,
  burst              = 3,
  burstRate          = 0.16,
  name               = [[20mm Oerlikon]],
  range              = 750,
  reloadTime         = 1.5,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 475,
  weaponVelocity     = 1640,
  damage = {
    default            = 110, -- copy from FlaK / TNSh
  },
}

local Oerlikon20mmAA = Oerlikon20mm:New(ACAAClass, true):New{
  burst              = 5,
  range              = 1950,
}
local Oerlikon20mmHE = Oerlikon20mm:New(ACHEClass, true)
local Twin_Oerlikon20mmAA = Oerlikon20mmAA:New({
  name               = [[(Twin)]],
  reloadTime         = 0.75,
}, true)

-- TNSh 20mm (RUS)
local TNSh20mm = ACClass:New{
  accuracy           = 300,
  burst              = 3,
  burstRate          = 0.1,
  name               = [[20mm TNSh]],
  range              = 675,
  reloadTime         = 4.5,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 444,
  weaponVelocity     = 1600,
  damage = {
    default            = 110,
  },
}

local TNSh20mmHE = TNSh20mm:New(ACHEClass, true)
local TNSh20mmAP = TNSh20mm:New(ACAPClass, true):New{
  weaponVelocity     = 1500,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m  = 35,
  },
  damage = {
    default            = 238.4,
  },
}

-- Return only the full weapons
return lowerkeys({
  -- FlaK 38
  FlaK3820mmAA = FlaK3820mmAA,
  FlaK3820mmHE = FlaK3820mmHE,
  FlaK3820mmAP = FlaK3820mmAP,
  FlakVierling20mmAA = FlakVierling20mmAA,
  FlakVierling20mmHE = FlakVierling20mmHE,
  -- Oerlikon
  Oerlikon20mmAA = Oerlikon20mmAA,
  Oerlikon20mmHE = Oerlikon20mmHE,
  Twin_Oerlikon20mmAA = Twin_Oerlikon20mmAA,
  -- TNSh
  TNSh20mmHE = TNSh20mmHE,
  TNSh20mmAP = TNSh20mmAP,
})
