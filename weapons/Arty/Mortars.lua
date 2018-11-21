-- Artillery - Mortars

-- Implementations

-- ML 3" Mortar (GBR)
local ML3InMortar = Mortar:New{
  areaOfEffect       = 112,
  edgeEffectiveness  = 0.25, -- overrides default
  name               = [[Ordnance ML 3 Inch Mortar]],
  range              = 1450,
}
local ML3InMortarHE = MortarHE:New(ML3InMortar, true):New{
  damage = {
    default            = 1088,
  },
}
local ML3InMortarSmoke = MortarSmoke:New(ML3InMortar, true)

-- 4in Smoke Mortar (GBR)
local BL4InMortar = Mortar:New{
	name			 = [[BL 4 Inch Mortar]],
	range			 = 1450,
	commandFire		 = true,
}
local BL4InMortarSmoke = MortarSmoke:New(BL4InMortar, true)

-- Granatwerfer 34 (GER)
local GrW34_8cmMortar = Mortar:New{
  areaOfEffect       = 81,
  name               = [[8 cm Granatwerfer 34]],
  range              = 1365,
}
local GrW34_8cmMortarHE = MortarHE:New(GrW34_8cmMortar, true):New{
  damage = {
    default            = 1100,
  },
}
local GrW34_8cmMortarSmoke = MortarSmoke:New(GrW34_8cmMortar, true)

-- M1 81mm Mortar (USA)
local M1_81mmMortar = Mortar:New{
  areaOfEffect       = 104,
  name               = [[M1 81mm Mortar]],
  range              = 1320,
}
local M1_81mmMortarHE = MortarHE:New(M1_81mmMortar, true):New{
  damage = {
    default            = 1100,
  },
}
local M1_81mmMortarSmoke = MortarSmoke:New(M1_81mmMortar, true)

-- 82-PM 37 (RUS)
local m1937_Mortar = Mortar:New{
  areaOfEffect       = 88,
  name               = [[82-PM 37 Mortar]],
  range              = 1365,
}
local m1937_MortarHE = MortarHE:New(m1937_Mortar, true):New{
  damage = {
    default            = 800,
  },
}
local m1937_MortarSmoke = MortarSmoke:New(m1937_Mortar, true)

-- Knee Mortar
local cKneeMortar = Mortar:New{
  areaOfEffect       = 50,
  name               = [[Type 89 Grenade Discharger]],
  range              = 650,
  weaponVelocity     = 350,
  customparams = {
    weaponcost         = 5,
  },
}
local KneeMortar = MortarHE:New(cKneeMortar, true):New{
  damage = {
    default            = 300,
  },
}
local KneeMortar_smoke = MortarSmoke:New(cKneeMortar, true)

-- Type 97 81mm mortar
local Type97_81mmMortar = Mortar:New{
  areaOfEffect       = 104,
  name               = [[Type 97 81mm Mortar]],
  range              = 1320,
}
local Type97_81mmMortarHE = MortarHE:New(Type97_81mmMortar, true):New{
  damage = {
    default            = 1100,
  },
}
local Type97_81mmMortarSmoke = MortarSmoke:New(Type97_81mmMortar, true) 



-- Return only the full weapons
return lowerkeys({
  ML3InMortar = ML3InMortarHE,
  ML3InMortarSmoke = ML3InMortarSmoke,
  BL4InMortarSmoke = BL4InMortarSmoke,
  GrW34_8cmMortar = GrW34_8cmMortarHE,
  GrW34_8cmMortarSmoke = GrW34_8cmMortarSmoke,
  M1_81mmMortar = M1_81mmMortarHE,
  M1_81mmMortarSmoke = M1_81mmMortarSmoke,
  m1937_Mortar = m1937_MortarHE,
  m1937_MortarSmoke = m1937_MortarSmoke,
  KneeMortar = KneeMortar,
  KneeMortar_smoke = KneeMortar_smoke,
  Type97_81mmMortarHE = Type97_81mmMortarHE,
  Type97_81mmMortarSmoke = Type97_81mmMortarSmoke,
})
