-- Misc - Tracers

-- Torpedo Base Class
local TorpedoClass = Weapon:New{
  areaOfEffect       = 32,  -- *
  avoidFriendly      = true,
  burnblow           = true,
  canAttackGround	 = false,
  edgeEffectiveness  = 0.5,
  explosionSpeed     = 30,
  --explosionGenerator = [[custom:nothing]],
  noSelfDamage       = true,
  reloadTime         = 300, -- still needed so e.g. each of the 4 fairmile tubes can only fire once
  rgbColor           = [[1.0 0.75 0.0]],
  soundHit           = "gen_explo_11",
  soundStart         = "watersplash",
  tolerance          = 9000, -- TODO: too high?
  tracks             = true,
  turnRate           = 50000, -- too high?
  turret             = true, -- TODO: needed? certainly for gabi
  waterWeapon        = true,
  weaponType         = "TorpedoLauncher",
  customparams = {
    damagetype         = "shapedcharge",
	minrange           = 400, -- *
  },
}

-- Implementations
local GBR18inTorpedo = TorpedoClass:New{
  name               = "Mk.XV 18inch torpedo",
  damage = {
    default = 8000,
  },
  model              = "533mmtorpedo",
  range              = 1300,
  startVelocity      = 250,
  weaponAcceleration = 230,
  weaponVelocity     = 450,
}

local RUS533mmTorpedo = TorpedoClass:New{
  name               = "53-38 533mm torpedo",
  damage = {
    default = 50000, -- HUGE!
  },
  model              = "533mmtorpedo",
  range              = 1100,
  startVelocity      = 300,
  weaponAcceleration = 250,
  weaponVelocity     = 500,
}

local ITA450mmTorpedo = TorpedoClass:New{
  name               = "450mm torpedo",
  damage = {
    default = 8000, -- HUGE!
  },
  model              = "ita450mmtorpedo",
  range              = 1300,
  sprayangle         = 1300,
  startVelocity      = 250,
  weaponAcceleration = 230,
  weaponVelocity     = 450,
}


-- Return only the full weapons
return lowerkeys({
  GBR18inTorpedo = GBR18inTorpedo,
  RUS533mmTorpedo = RUS533mmTorpedo,
  ITA450mmTorpedo = ITA450mmTorpedo,
})
