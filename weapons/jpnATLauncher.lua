-- Infantry Anti-Tank Launchers

-- AT Launcher Base Class
local ATLClass = Weapon:New{
  explosionGenerator = [[custom:HE_Medium]],
  explosionSpeed     = 30,
  impulseFactor      = 0,
  model              = [[Bomb_Tiny.S3O]],
  noSelfDamage       = true,
  soundHitDry        = [[GEN_Explo_3]],
  tolerance          = 6000,
  turret             = true,
  customparams = {
    damagetype         = [[shapedcharge]],
  },
}

-- Recoilless Rifle (& Spigot Mortar) Class
local RCL_ATLClass = ATLClass:New{
  accuracy           = 500,
  collisionSize      = 3,
  reloadtime         = 15,
  weaponType         = [[Cannon]],
  weaponVelocity     = 400,
}

-- Rocket Launcher Class
local Rocket_ATLClass = ATLClass:New{
  areaOfEffect       = 32,
  cegTag             = [[BazookaTrail]],
  flightTime         = 1,
  gravityaffected    = true,
  reloadtime         = 10,
  startVelocity      = 10,
  weaponAcceleration = 2000,
  weaponTimer        = 1,
  weaponType         = [[MissileLauncher]],
  weaponVelocity     = 1000,
}

-- Implementations
-- Type 4 Rocket Launcher
local Type4AT = Rocket_ATLClass:New{
  name               = [[Type 4 Rocket Launcher]],
  range              = 270,
  soundStart         = [[US_Bazooka]],
  targetMoveError    = 0.075,
  customparams = {
    armor_penetration  = 108,
  },
  damage = {
    default            = 5280,
  },
}

-- Return only the full weapons
return lowerkeys({
	type4at = Type4AT,
})
