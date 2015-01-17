-- Aircraft - Aircraft Automatic Cannons

-- AirAutoCannon Base Class
local AirACClass = Weapon:New{
  avoidFriendly      = false,
  burnblow           = true,
  collideFriendly    = false,
  collisionSize      = 2,
  collisionvolumetest = 1,
  fireStarter        = 10,
  impactonly         = 1,
  interceptedByShieldType = 8,
  predictBoost       = 0.5,
  size               = 1e-13, -- visuals done with tracers
  sprayAngle         = 1500,
  soundHitDry        = [[GEN_Explo_1]],
  soundTrigger       = true,
  tolerance          = 600,
  heightBoostFactor  = 0,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    armor_hit_side     = [[top]],
    no_range_adjust    = true,
  },
}

local AirACHEClass = Weapon:New{
  explosionGenerator = [[custom:HE_XSmall]],
  name               = [[HE Shell]],
  areaOfEffect       = 4,
  customparams = {
    damagetype         = [[explosive]],
    fearaoe            = 45,
    fearid             = 301,
  },
}

local AirACAPClass = Weapon:New{
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

-- Hispano HS.404 20mm (GBR)
local HS40420mm = AirACClass:New(AirACHEClass, true):New{
  areaOfEffect       = 10,
  burst              = 3,
  burstrate          = 0.1,
  name               = [[Hispano HS.404 20mm Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1.1,
  soundStart         = [[GBR_20mmAir]],
  weaponVelocity     = 2700,
  damage = {
    default            = 110,
  },
}

-- Mk. 108 30mm (GER)
local Mk10830mm = AirACClass:New(AirACHEClass, true):New{
  areaOfEffect       = 25,
  burst              = 3,
  burstRate          = 0.25,
  name               = [[30mm Mk 108 Aircraft Cannon]],
  range              = 700,
  reloadtime         = 3,
  soundStart         = [[GER_30mmAir]],
  sprayAngle         = 700, -- overrides default
  weaponVelocity     = 1750,
  damage = {
    default            = 182,
  },
}

-- MG151/20 20mm (GER)
local MG15120mm = AirACClass:New(AirACHEClass, true):New{
  areaOfEffect       = 15,
  burst              = 6,
  burstRate          = 0.085,
  name               = [[20mm MG 151/20 Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1.25,
  soundStart         = [[GER_20mmAir]],
  weaponVelocity     = 2000,
  damage = {
    default            = 52,
  },
}

-- MG151/15 15mm (GER)
-- treated like a machinegun in game, but
-- this derives from the above 20mm
local MG15115mm = AirACClass:New(AirACHEClass, true):New{
  areaOfEffect       = 8,
  burstRate          = 0.08,
  explosionGenerator = [[custom:Bullet]],
  name               = [[15mm MG 151/15 Aircraft Cannon]],  
  predictBoost       = 0.75,
  reloadTime         = 0.8, -- why so different?
  soundStart         = [[GER_15mmAir]],
  damage = {
    default            = 40,
  },
} 

-- ShVAK 20mm (RUS)
local ShVAK20mm = AirACClass:New(AirACHEClass, true):New{
  areaOfEffect       = 10,
  burst              = 3,
  burstRate          = 0.085,
  name               = [[20mm ShVAK Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 67,
  },
}

-- VYa 23mm (RUS)
local VYa23mm = AirACClass:New(AirACHEClass, true):New{
  areaOfEffect       = 14,
  burst              = 3,
  burstRate          = 0.085,
  name               = [[23mm VYa Aircraft Cannon]],
  range              = 900,
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 110,
  },
}

-- Ho-5 20mm AP (JPN)
local Ho520mmAP = AirACClass:New(AirACAPClass, true):New{
  burst              = 5,
  burstRate          = 0.091,
  name               = [[Ho-5 20mm Cannon AP]],
  range              = 830,
  reloadTime         = 0.8,
  soundStart         = [[JPN_20mmAir]],
  weaponVelocity     = 1800,
  customparams = {
    armor_penetration_1000m  = 6,
    armor_penetration_100m   = 28,
  },
  damage = {
    default            = 305,
  },
}

-- Ho-5 20mm HE (JPN) 
local Ho520mmHE = AirACClass:New(AirACHEClass, true):New{
  burst              = 5,
  areaOfEffect       = 6,
  burstRate          = 0.091,
  name               = [[Ho-5 20mm Cannon HE]],
  range              = 830,
  reloadTime         = 0.8,
  soundStart         = [[JPN_20mmAir]],
  weaponVelocity     = 1800,
  damage = {
    default            = 54,
  },
}

-- Return only the full weapons
return lowerkeys({
  HS40420mm = HS40420mm,
  Mk10830mm = Mk10830mm,
  MG15120mm = MG15120mm,
  MG15115mm = MG15115mm,
  ShVAK20mm = ShVAK20mm,
  VYa23mm = VYa23mm,
  Ho520mmAP = Ho520mmAP,
  Ho520mmHE = Ho520mmHE,
})
