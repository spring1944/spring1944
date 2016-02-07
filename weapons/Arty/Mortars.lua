-- Artillery - Mortars

-- Implementations

-- ML 3" Mortar (GBR)
Weapon('ML3InMortar'):Extends('Mortar'):Attrs{
  areaOfEffect       = 112,
  edgeEffectiveness  = 0.25, -- overrides default
  name               = [[Ordnance ML 3 Inch Mortar]],
  range              = 1450,
  damage = {
    default            = 1088,
  },
}
Weapon('ML3InMortarHE'):Extends('MortarHE'):Extends('ML3InMortar') -- name append
Weapon('ML3InMortarSmoke'):Extends('MortarSmoke'):Extends('ML3InMortar') -- name append

-- 4in Smoke Mortar (GBR)
Weapon('BL4InMortar'):Extends('Mortar'):Attrs{
	name			 = [[BL 4 Inch Mortar]],
	range			 = 1450,
	commandFire		 = true,
}
Weapon('BL4InMortarSmoke'):Extends('MortarSmoke'):Extends('BL4InMortar') -- name append

-- Granatwerfer 34 (GER)
Weapon('GrW34_8cmMortar'):Extends('Mortar'):Attrs{
  areaOfEffect       = 81,
  name               = [[8 cm Granatwerfer 34]],
  range              = 1365,
  damage = {
    default            = 1100,
  },
}
Weapon('GrW34_8cmMortarHE'):Extends('MortarHE'):Extends('GrW34_8cmMortar') -- name append
Weapon('GrW34_8cmMortarSmoke'):Extends('MortarSmoke'):Extends('GrW34_8cmMortar') -- name append

-- M1 81mm Mortar (USA)
Weapon('M1_81mmMortar'):Extends('Mortar'):Attrs{
  areaOfEffect       = 104,
  name               = [[M1 81mm Mortar]],
  range              = 1320,
  damage = {
    default            = 1100,
  },
}
Weapon('M1_81mmMortarHE'):Extends('MortarHE'):Extends('M1_81mmMortar') -- name append
Weapon('M1_81mmMortarSmoke'):Extends('MortarSmoke'):Extends('M1_81mmMortar') -- name append

-- 82-PM 37 (RUS)
Weapon('m1937_Mortar'):Extends('Mortar'):Attrs{
  areaOfEffect       = 88,
  name               = [[82-PM 37 Mortar]],
  range              = 1365,
  damage = {
    default            = 800,
  },
}
Weapon('m1937_MortarHE'):Extends('MortarHE'):Extends('m1937_Mortar') -- name append
Weapon('m1937_MortarSmoke'):Extends('MortarSmoke'):Extends('m1937_Mortar') -- name append

-- Knee Mortar
Weapon('cKneeMortar'):Extends('Mortar'):Attrs{
  areaOfEffect       = 50,
  name               = [[Type 89 Grenade Discharger]],
  range              = 650,
  weaponVelocity     = 350,
  customparams = {
    weaponcost         = 7,
  },
  damage = {
    default            = 300,
  },
}
Weapon('KneeMortar'):Extends('MortarHE'):Extends('cKneeMortar') -- name append
Weapon('KneeMortar_smoke'):Extends('MortarSmoke'):Extends('cKneeMortar') -- name append

-- Type 97 81mm mortar
Weapon('Type97_81mmMortar'):Extends('Mortar'):Attrs{
  areaOfEffect       = 104,
  name               = [[Type 97 81mm Mortar]],
  range              = 1320,
  damage = {
    default            = 1100,
  },
}
Weapon('Type97_81mmMortarHE'):Extends('MortarHE'):Extends('Type97_81mmMortar') -- name append
Weapon('Type97_81mmMortarSmoke'):Extends('MortarSmoke'):Extends('Type97_81mmMortar') -- name append



-- Return only the full weapons
