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
  soundHitDry        = [[GEN_Explo_3]],
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

-- Knee Mortar
local cKneeMortar = MortarClass:New{
  areaOfEffect       = 50,
  name               = [[Type 89 Grenade Discharger]],
  range              = 650,
  damage = {
    default            = 300,
  },
}
local KneeMortar = cKneeMortar:New(MortarHEClass, true)
local KneeMortar_smoke = cKneeMortar:New(MortarSmokeClass, true) 

-- Type 97 81mm mortar
local Type97_81mmMortar = MortarClass:New{
  areaOfEffect       = 104,
  name               = [[Type 97 81mm Mortar]],
  range              = 1320,
  damage = {
    default            = 1100,
  },
}
local Type97_81mmMortarHE = Type97_81mmMortar:New(MortarHEClass, true)
local Type97_81mmMortarSmoke = Type97_81mmMortar:New(MortarSmokeClass, true) 


-- Return only the full weapons
return lowerkeys({
	KneeMortar = KneeMortar,
	KneeMortar_smoke = KneeMortar_smoke,
	Type97_81mmMortarHE = Type97_81mmMortarHE,
	Type97_81mmMortarSmoke = Type97_81mmMortarSmoke,
})
