-- Artillery - Mortars

-- Mortar Base Class
local MortarClass = Weapon:New{
  accuracy           = 485,
  collideFriendly    = false,
  edgeEffectiveness  = 0.2,
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  impulseFactor      = 1e-07,
  leadLimit          = 500,
  model              = [[MortarShell.S3O]],
  reloadtime         = 12,
  size               = 1.5,
  soundHit           = [[GEN_Explo_3]],
  soundStart         = [[GEN_Mortar]],
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 550,
  customparams = {
    armor_hit_side     = [[top]],
    damagetype         = [[explosive]],
  },
}

-- HE Round Class
local MortarHEClass = Weapon:New{
  name               = [[HE Shell]],
  customparams = {
    fearaoe            = 105,
    fearid             = 301,
  },
}

-- Smoke Round Class
local MortarSmokeClass = Weapon:New{
  areaOfEffect       = 20,
  name               = [[Smoke Shell]],
  customparams = {
	smokeradius        = 160,
	smokeduration      = 25,
	smokeceg           = [[SMOKESHELL_Small]],
  },
  damage = {
    default = 100,
  } ,
}

-- Implementations

-- ML 3" Mortar (GBR)
local ML3InMortar = MortarClass:New{
  areaOfEffect       = 112,
  edgeEffectiveness  = 0.25, -- overrides default
  name               = [[Ordnance ML 3 Inch Mortar]],
  range              = 1450,
  damage = {
    default            = 1088,
  },
}
local ML3InMortarHE = ML3InMortar:New(MortarHEClass, true)
local ML3InMortarSmoke = ML3InMortar:New(MortarSmokeClass, true)

-- Granatwerfer 34 (GER)
local GrW34_8cmMortar = MortarClass:New{
  areaOfEffect       = 81,
  name               = [[8 cm Granatwerfer 34]],
  range              = 1365,
  damage = {
    default            = 1100,
  },
}
local GrW34_8cmMortarHE = GrW34_8cmMortar:New(MortarHEClass, true)
local GrW34_8cmMortarSmoke = GrW34_8cmMortar:New(MortarSmokeClass, true)

-- M1 81mm Mortar (USA)
local M1_81mmMortar = MortarClass:New{
  areaOfEffect       = 104,
  name               = [[M1 81mm Mortar]],
  range              = 1320,
  damage = {
    default            = 1100,
  },
}
local M1_81mmMortarHE = M1_81mmMortar:New(MortarHEClass, true)
local M1_81mmMortarSmoke = M1_81mmMortar:New(MortarSmokeClass, true) 

-- 82-PM 37 (RUS)
local m1937_Mortar = MortarClass:New{
  areaOfEffect       = 88,
  name               = [[82-PM 37 Mortar]],
  range              = 1365,
  damage = {
    default            = 800,
  },
}
local m1937_MortarHE = m1937_Mortar:New(MortarHEClass, true)
local m1937_MortarSmoke = m1937_Mortar:New(MortarSmokeClass, true) 

-- Return only the full weapons
return lowerkeys({
  ML3InMortar = ML3InMortarHE,
  ML3InMortarSmoke = ML3InMortarSmoke,
  GrW34_8cmMortar = GrW34_8cmMortarHE,
  GrW34_8cmMortarSmoke = GrW34_8cmMortarSmoke,
  M1_81mmMortar = M1_81mmMortarHE,
  M1_81mmMortarSmoke = M1_81mmMortarSmoke,
  m1937_Mortar = m1937_MortarHE,
  m1937_MortarSmoke = m1937_MortarSmoke,
})
