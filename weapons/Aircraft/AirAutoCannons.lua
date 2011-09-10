-- Aircraft - Aircraft Automatic Cannons

-- AirAutoCannon Base Class
local AirACClass = Weapon:New{
  burnblow           = true,
  collisionSize      = 2,
  collisionvolumetest = 1,
  explosionGenerator = [[custom:HE_XSmall]],
  fireStarter        = 10,
  impactonly         = 1,
  interceptedByShieldType = 8,
  predictBoost       = 0.5,
  size               = 1e-13, -- visuals done with tracers
  sprayAngle         = 250,
  soundTrigger       = true,
  tolerance          = 600,
  turret             = true,
  weaponType         = [[Cannon]],
  customparams = {
    armor_hit_side     = [[top]],
    damagetype         = [[explosive]],
    fearaoe            = 45,
    fearid             = 301,
  },
}

-- Implementations

-- Hispano HS.404 20mm (GBR)
local HS40420mm = AirACClass:New{
  areaOfEffect       = 1, -- why so small?
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
local Mk10830mm = AirACClass:New{
  areaOfEffect       = 50,
  burst              = 3,
  burstRate          = 0.25,
  name               = [[30mm Mk 108 Aircraft Cannon]],
  range              = 700,
  reloadtime         = 3,
  soundStart         = [[GER_30mmAir]],
  sprayAngle         = 100, -- overrides deafult
  weaponVelocity     = 1750,
  damage = {
    default            = 182,
  },
}

-- MG151/20 20mm (GER)
local MG15120mm = AirACClass:New{
  areaOfEffect       = 30,
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
local MG15115mm = MG15120mm:New{
  areaOfEffect       = 1,
  burstRate          = 0.08,
  explosionGenerator = [[custom:Bullet]],
  name               = [[15mm MG 151/15 Aircraft Cannon]],  
  predictBoost       = 0.75,
  reloadTime         = 0.8, -- why so different?
  soundStart         = [[GER_15mmAir]],
  customparams = {
    armor_hit_side     = nil, -- disable this
    damagetype         = [[smallarm]],
  },
  damage = {
    default            = 128, -- higher damage? O_o
  },
} 

-- ShVAK 20mm (RUS)
local ShVAK20mm = AirACClass:New{
  areaOfEffect       = 1, -- why so small?
  burst              = 3,
  burstRate          = 0.085,
  name               = [[20mm ShVAK Aircraft Cannon]],
  range              = 2500, -- O_o?
  reloadtime         = 1,
  soundStart         = [[RUS_20mm]],
  weaponVelocity     = 2600,
  damage = {
    default            = 67,
  },
}

-- VYa 23mm (RUS)
local VYa23mm = AirACClass:New{
  areaOfEffect       = 25,
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

-- Return only the full weapons
return lowerkeys({
  HS40420mm = HS40420mm,
  Mk10830mm = Mk10830mm,
  MG15120mm = MG15120mm,
  MG15115mm = MG15115mm,
  ShVAK20mm = ShVAK20mm,
  VYa23mm = VYa23mm,
})
