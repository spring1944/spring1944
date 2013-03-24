-- Aircraft - italian Bombs

-- Bomb Base Class
local BombClass = Weapon:New{
  avoidFeature		= false,
  collideFriendly    = false,
  explosionSpeed     = 30,
  explosionGenerator = [[custom:HE_XLarge]],
  impulseFactor      = 0.01,
  manualBombSettings = true,
  reloadtime         = 600,
  tolerance          = 4000,
  turret             = true,
  weaponType         = [[Cannon]],
  weaponVelocity     = 400,
  model              = [[Bomb_Medium.S3O]],
  customparams = {
	no_range_adjust	   = true,
    damagetype         = [[explosive]],
  },
  damage = {
    default            = 30000,
  },
}

-- Implementations


-- 160Kg Bomb 

local bomb160kg = BombClass:New{
  accuracy           = 1000,
  areaOfEffect       = 160,
  edgeEffectiveness  = 0.01,
  name               = [[160kg Bomb]],
  weaponType         = [[AircraftBomb]],
  manualBombSettings = true,
  burst		= 1,
  reloadtime	= 600,
  mygravity	= 0.5,
  texture1 = projectile,
  range              = 650,
    damage = {
    default            = 15000,
	planes		= 5,
    },
  soundHit           = [[GEN_Explo_6]],
}

-- 50Kg Bomb 

local bomb50kg = BombClass:New{
  name               = [[50kg Bomb]],
  accuracy           = 1400,	
  areaOfEffect       = 76,
  weaponVelocity     = 300,

    damage = {
    default            = 7500,
    },
  edgeEffectiveness	= 0.5,
  range              = 800,
  soundHit           = [[GEN_Explo_9]],
  tolerance          = 1000,
  targetMoveError = 0.1,
  mygravity	= 0.3,
}

-- Return only the full weapons
return lowerkeys({
  bomb160kg = bomb160kg,
  bomb50kg = bomb50kg,

})
