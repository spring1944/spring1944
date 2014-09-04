-- Aircraft - Bombs

-- Bomb Base Class
local BombClass = Weapon:New{
  collideFriendly    = false,
  explosionSpeed     = 30,
  explosionGenerator = [[custom:HE_XXLarge]],
  gravityaffected    = true,
  impulseFactor      = 0.01,
  manualBombSettings = true,
  noSelfDamage		 = true,
  reloadtime         = 600,
  startVelocity      = 280,
  tolerance          = 4000,
  trajectoryHeight   = 0.15,
  turret             = true,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 280,
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
  accuracy           = 1500,
  areaOfEffect       = 200,
  commandfire        = true,
  edgeEffectiveness  = 0.1,
  flightTime         = 3,
  model              = [[Bomb_Medium.S3O]],
  name               = [[250kg Bomb]],
  range              = 600,
  soundHitDry        = [[GEN_Explo_9]],
}

-- 160Kg Bomb (Generic)
local Bomb160kg = Bomb:New{
  accuracy           = 1000,
  areaOfEffect       = 160,
  explosionGenerator = [[custom:HE_XLarge]],
  name               = [[160kg Bomb]],
  range              = 450,
  soundHitDry        = [[GEN_Explo_6]],
  damage = {
    default            = 15000,
	planes		       = 5,
  },
}

-- 50Kg Bomb (Generic)
local Bomb50kg = Bomb:New{
  accuracy           = 1400,
  areaOfEffect       = 76,
  explosionGenerator = [[custom:HE_XLarge]],
  name               = [[50kg Bomb]],
  range              = 800,
  soundHitDry        = [[GEN_Explo_9]],
  damage = {
    default            = 7500,
	planes		       = 5,
  },
}

-- V1 Missile Explosions (GER)
local V1 = BombClass:New{
  areaOfEffect       = 200,
  name               = [[V1 Missile]],
  soundHitDry        = [[GEN_Explo_9]],
}

-- PTAB "Antitank Aviation Bomb" (RUS)
local PTAB = BombClass:New{
  areaOfEffect       = 24,
  burst              = 13,
  burstrate          = 0.1,
  cylinderTargeting  = true, -- required?
  edgeEffectiveness  = 0.5,
  explosionGenerator = [[custom:HE_medium]], -- overrides default
  flightTime         = 0.5,
  model              = [[MortarShell.S3O]],
  name               = [[PTAB Anti-Tank Bomblets]],
  projectiles        = 9,
  range              = 525,
  soundHitDry        = [[GEN_Explo_3]],
  sprayangle         = 65535,
  startVelocity      = 110, -- overrides default
  weaponVelocity     = 110, -- overrides default
  customparams = {
    armor_hit_side     = [[top]],
    armor_penetration  = 65,
    damagetype         = [[shapedcharge]], -- overrides default
  },
  damage = {
    default            = 4896, -- Same damage as RPG43, but in fact it had nearly 3 time more weight of explosive than rpg43. Nerfed for balance.
    infantry           = 250, -- I have no idea how effective it should be vs infantry. Nerfed to avoid usages different of historical usage.
    lightBuildings     = 275, -- Nerfed to avoid usages different of historical usage. Still very effective vs storages.
    bunkers            = 500,
  }
}

-- Return only the full weapons
return lowerkeys({
  Bomb = Bomb,
  Bomb160kg = Bomb160kg,
  Bomb50kg = Bomb50kg,
  PTAB = PTAB,
  V1 = V1,
})
