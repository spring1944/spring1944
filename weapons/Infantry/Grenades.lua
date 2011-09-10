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
  model              = [[MortarShell.S3O]],
  targetBorder       = 1,
  tolerance          = 10000,
  turret             = true,
  --weaponTimer        = 5,
  weaponType         = [[Cannon]],
  weaponVelocity     = 200,
}

-- Anti-Personel Grenade Class
local APGrenadeClass = GrenadeClass:New{
  collisionSize      = 1e-100,
  dynDamageExp       = 1,
  dynDamageRange     = 200,
  edgeEffectiveness  = 0.8,
  explosionGenerator = [[custom:HE_Small]],
  movingAccuracy     = 3500,
  range              = 180,
  reloadtime         = 8,
  soundHit           = [[GEN_Explo_Grenade]],
  customparams = {
    armor_penetration  = 80, -- more than AT nades??
    damagetype         = [[grenade]],
  },
  damage = {
    default            = 1450,
  },
}

-- Anti-Tank Grenade Class
local ATGrenadeClass = GrenadeClass:New{
  edgeEffectiveness  = 0.5,
  explosionGenerator = [[custom:HE_Medium]],
  movingAccuracy     = 7111,
  range              = 230,
  reloadTime         = 5,
  soundHit           = [[GEN_Explo_3]],
  customparams = {
    damagetype         = [[shapedcharge]],
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
	smokeceg           = [[SMOKESHELL_Small]],
  },
  damage = {
    default = 100,
  } ,
}

-- Implementations
-- AP Nades
-- No. 69 Mills Bomb (GBR)
local No69 = APGrenadeClass:New{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[No. 69 Hand Grenade]],
}

-- Model 24 (GER)
local Model24 = APGrenadeClass:New{
  accuracy           = 1250,
  areaOfEffect       = 24,
  dynDamageRange     = 220,
  edgeEffectiveness  = 0.5, -- intended?
  name               = [[Model 24 Stielhandgranate]],
  range              = 200,
  reloadtime         = 6.5, -- intended?
  weaponVelocity     = 210, -- intended?
  damage = {
    default            = 1725,
  },
}

-- Mk. 2 (USA)
local Mk2 = APGrenadeClass:New{
  accuracy           = 1777,
  areaOfEffect       = 40,
  name               = [[Mk. 2 Hand Grenade]],
  weaponVelocity     = 310, -- intended?
}

-- F1 (RUS)
-- this is new, currently unused, stas copied from No.69
local F1 = APGrenadeClass:New{
  accuracy           = 1421,
  areaOfEffect       = 32,
  name               = [[F-1 Hand Grenade]],
}

-- AT nades
-- RPG-43 AT Nade (RUS)
local RPG43 = ATGrenadeClass:New{
  accuracy           = 400,
  areaOfEffect       = 24,
  name               = [[RPG-43 Anti-Tank Grenade]],
  customparams = {
    armor_penetration  = 75,
  },
  damage = {
    default            = 4896,
  },  
}

-- Smoke nades
-- No. 77 WP (GBR)
local No77 = SmokeGrenadeClass:New{
  accuracy           = 1421,
  name               = [[No. 77 Smoke Grenade]],
}

-- Other nades
local Molotov = GrenadeClass:New{
  areaOfEffect       = 40,
  canattackground    = true, -- intended?
  cegTag             = [[Flametrail]],
  explosionGenerator = [[custom:Molotov]],
  explosionSpeed     = 0.01, -- needed?
  fireStarter        = 100,
  groundBounce       = false,
  name               = [["Molotov Cocktail"]],
  range              = 180,
  reloadTime         = 10,
  tolerance          = 200,
  weaponVelocity     = 260,
  customparams = {
	damagetype         = [[fire]],
	fearaoe            = 1,
	fearid             = 1,
	damagetime         = 25,
	ceg                = [[Molotov]],
  },
  damage = {
    default            = 20,
	lightbuildings     = 400,
  },  
}

-- Return only the full weapons
return lowerkeys({
  -- AP nades
  No69 = No69,
  Model24 = Model24,
  Mk2 = Mk2,
  F1 = F1,
  -- AT nades
  RPG43 = RPG43,
  -- Smoke nades
  No77 = No77,
  -- Other
  Molotov = Molotov,
})
