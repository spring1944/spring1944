-- Smallarms - Infantry Grenades

-- Grenade Base Class
local bombaamanoClass = Weapon:New{
  bounceRebound      = 0.2,
  bounceSlip         = 0.1,
  canAttackGround    = false,
  explosionSpeed     = 30,
  accuracy			= 350,
  groundBounce       = true,
  id                 = 31, -- used?
  impulseFactor      = 1e-05,
  model              = [[MortarShell.S3O]],
  targetBorder       = 1,
  tolerance          = 10000,
  turret             = true,
    customparams = {
    damagetype         = [[explosive]],
    howitzer	= true,
  },
  weaponType         = [[Cannon]],
  weaponVelocity     = 200,
    edgeEffectiveness  = 0.5,
  explosionGenerator = [[custom:HE_Medium]],
  movingAccuracy     = 711,
  range              = 190,
  reloadTime         = 5,
  soundHit           = [[GEN_Explo_3]],
}

-- Anti-Personel Grenade 
local OTO_model35 = bombaamanoClass:New{
  collisionSize      = 1e-100,
  edgeEffectiveness  = 0.8,
  areaOfEffect       = 30,
  name               = [[italian Grenade]],
  explosionGenerator = [[custom:HE_Small]],
  movingAccuracy     = 3500,
  range              = 200,
  reloadtime         = 8,
  soundHit           = [[GEN_Explo_Grenade]],
  customparams = {
    armor_penetration  = 25, 
    damagetype         = [[grenade]],
  },
  damage = {
    default            = 880,
  },
}


-- standard AT grenade
local BredaMod42 = bombaamanoClass:New{
  areaOfEffect       = 31,
  name               = [[Breda Anti-Tank Grenade]],
  reloadtime         = 9,
  damage = {
    default            = 3080,
  },
}

-- heavy AT grenade
local L_type_grenade = bombaamanoClass:New{
  areaOfEffect       = 33,
  name               = [[Anti-Tank Stickgrenade]],
  reloadtime         = 12, 
  weaponVelocity     = 190, 
  damage = {
    default            = 4580,
  },
}

-- Return only the full weapons
return lowerkeys({
  OTO_model35 = OTO_model35,
  BredaMod42 = BredaMod42,
  L_type_grenade = L_type_grenade,
})
