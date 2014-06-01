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
  leadLimit	     = 200,
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
-- 50Kg Bomb 

local bomb50kg = BombClass:New{
  name               = [[50kg Bomb]],
  accuracy           = 500,
  areaOfEffect       = 76,
  -- turret             = false,
  manualBombSettings = false,
  weaponVelocity     = 300,

    damage = {
    default            = 7000,
    },
  edgeEffectiveness	= 0.5,
  range              = 800,
  soundHit           = [[GEN_Explo_9]],
  tolerance          = 10,
  targetMoveError = 0.1,
  mygravity	= 0.6,
}

-- Return only the full weapons
return lowerkeys({
  jap_bomb50kg = bomb50kg,

})
