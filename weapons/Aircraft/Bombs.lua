-- Aircraft - Bombs

-- Bomb Base Class
local BombClass = Weapon:New{
  collideFriendly    = true,
  explosionSpeed     = 30,
  explosionGenerator = [[custom:HE_XXLarge]],
  gravityaffected    = true,
  heightBoostFactor  = 0,
  impulseFactor      = 0.01,
  manualBombSettings = true,
  size		= 2,
  noSelfDamage		 = true,
  reloadtime         = 600,
  tolerance          = 5000,
  trajectoryHeight   = 0,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 200,
  highTrajectory     = 0,
  customparams = {
    no_range_adjust	   = true,
    damagetype         = [[explosive]],
  },
  damage = {
    default            = 30000,
  },
}

-- Implementations

-- 250Kg Bomb (Generic)
local Bomb = BombClass:New{
  accuracy           = 500,
  areaOfEffect       = 200,
  commandfire        = true,
  edgeEffectiveness  = 0.1,
  startVelocity		= 280,
  flightTime         = 3,
  model              = [[Bomb_Medium.S3O]],
  name               = [[250kg Bomb]],
  range              = 600,
  soundHitDry        = [[GEN_Explo_9]],
}

-- 160Kg Bomb (Generic)
local Bomb160kg = BombClass:New{
  accuracy           = 500,
  areaOfEffect       = 160,
  selfExplode	     = true,
  name               = [[160kg Bomb]],
  model              = [[Bomb_Medium.S3O]],
  burst		= 1,
  reloadtime	= 600,
  range              = 650,
    damage = {
    default            = 15000,
	planes		= 5,
    },
  soundHit           = [[GEN_Explo_9]],
}

-- 50Kg Bomb (Generic)
local Bomb50kg = BombClass:New{
  name               = [[50kg Bomb]],
  model              = [[Bomb_Medium.S3O]],
  weaponType         = [[Cannon]],
  size		     = 1,
  accuracy           = 240,	
  areaOfEffect       = 76,
  trajectoryHeight   = 0.0,
  heightMod		= 0.2,
  mygravity	= 0.05,
    damage = {
    default            = 7500,
	planes		= 5,
    },
  range              = 100,
  explosionGenerator = [[custom:HE_Large]],
  soundHit           = [[GEN_Explo_5]],
  tolerance          = 1000,
}

-- V1 Missile Explosions (GER)
local V1 = BombClass:New{
  areaOfEffect       = 200,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 100,
  name               = [[V1 Missile]],
  soundHitDry        = [[GEN_Explo_9]],
}

-- PTAB "Antitank Aviation Bomb" (RUS)
local PTAB = BombClass:New{
  areaOfEffect       = 24,
  burst              = 36,
  selfExplode	     = true,
  cylinderTargeting  = 0.5,
  burstrate          = 0.1,
  edgeEffectiveness  = 0.5,
  explosionGenerator = [[custom:HE_medium]], -- overrides default
  model              = [[MortarShell.S3O]],
  weaponVelocity     = 150,
  name               = [[PTAB Anti-Tank Bomblets]],
  projectiles        = 8,
  range              = 500,
  soundHitDry        = [[GEN_Explo_3]],
  sprayangle         = 8000,
  customparams = {
    armor_hit_side     = [[top]],
    armor_penetration  = 65,
    damagetype         = [[shapedcharge]], -- overrides default
  },
  damage = {
    default            = 4896, -- Same damage as RPG43, but in fact it had nearly 3 time more weight of explosive than rpg43. Nerfed for balance.
    infantry           = 50, -- I have no idea how effective it should be vs infantry. Nerfed to avoid usages different of historical usage.
    lightBuildings     = 75, -- Nerfed to avoid usages different of historical usage. Still very effective vs storages.
    bunkers            = 500,
	},
  }
--  3.5kg Hollow Charge Bomblet (ITA)
local A_tkbomb = BombClass:New{
  areaOfEffect       = 26,
  burst              = 7,
  selfExplode	     = true,
  cylinderTargeting  = 0.5,
  burstrate          = 0.1,
  edgeEffectiveness  = 0.5,
  explosionGenerator = [[custom:HE_medium]], -- overrides default
  model              = [[MortarShell.S3O]],
  weaponVelocity     = 150,
  name               = [[3.5kg Hollow Charge A-tk Anti-Tank Bomblets]],
  projectiles        = 3,
  range              = 500,
  soundHitDry        = [[GEN_Explo_3]],
  sprayangle         = 3000,
  customparams = {
    armor_hit_side     = [[top]],
    armor_penetration  = 70,
    damagetype         = [[shapedcharge]], -- overrides default
  },
  damage = {
    default            = 4406, 
    infantry           = 50, -- I have no idea how effective it should be vs infantry. Nerfed to avoid usages different of historical usage.
    lightBuildings     = 75, -- Nerfed to avoid usages different of historical usage. Still very effective vs storages.
    bunkers            = 500,
  }
}

-- Return only the full weapons
return lowerkeys({
  Bomb = Bomb,
  Bomb160kg = Bomb160kg,
  Bomb50kg = Bomb50kg,
  PTAB = PTAB,
  A_tkbomb = A_tkbomb,
  V1 = V1,
})
