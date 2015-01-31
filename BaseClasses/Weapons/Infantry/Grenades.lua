-- Smallarms - Infantry Grenades

-- Grenade Base Class
local GrenadeClass = Weapon:New{
  bounceRebound      = 0.2,
  bounceSlip         = 0.1,
  canAttackGround    = false,
  explosionSpeed     = 30,
  groundBounce       = true,
  id                 = 31, -- used?
  impulseFactor      = 1e-05,
  model              = "MortarShell.S3O",
  targetBorder       = 1,
  tolerance          = 10000,
  turret             = true,
  --weaponTimer        = 5,
  weaponType         = "Cannon",
  weaponVelocity     = 200,
}

-- Anti-Personel Grenade Class
local APGrenadeClass = GrenadeClass:New{
  collisionSize      = 1e-100,
  edgeEffectiveness  = 0.8,
  explosionGenerator = "custom:HE_Small",
  movingAccuracy     = 3500,
  range              = 180,
  reloadtime         = 8,
  soundHitDry        = "GEN_Explo_Grenade",
  customparams = {
    armor_penetration  = 80, -- more than AT nades??
    damagetype         = "grenade",
  },
  damage = {
    default            = 1450,
  },
}

-- Anti-Tank Grenade Class
local ATGrenadeClass = GrenadeClass:New{
  edgeEffectiveness  = 0.5,
  explosionGenerator = "custom:HE_Medium",
  movingAccuracy     = 7111,
  range              = 230,
  reloadTime         = 5,
  soundHitDry        = "GEN_Explo_3",
  customparams = {
    damagetype         = "shapedcharge",
	badtargetcategory  = "INFANTRY",
  },
}

-- Smoke Grenade Class
local SmokeGrenadeClass = GrenadeClass:New{
  areaOfEffect       = 20,
  canAttackGround    = true,
  commandFire        = true,
  range              = 200,
  reloadTime         = 15,
  customparams = {
    nosmoketoggle      = true,
	smokeradius        = 160,
	smokeduration      = 25,
	smokeceg           = "SMOKESHELL_Small",
  },
  damage = {
    default = 100,
  } ,
}


return {
  GrenadeClass = GrenadeClass,
  APGrenadeClass = APGrenadeClass,
  ATGrenadeClass = ATGrenadeClass,
  SmokeGrenadeClass = SmokeGrenadeClass,
}
