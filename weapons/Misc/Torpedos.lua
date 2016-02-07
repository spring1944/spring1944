-- Misc - Torpedos

-- Implementations
Weapon('GBR18inTorpedo'):Extends('TorpedoClass'):Attrs{
  name               = "Mk.XV 18inch torpedo",
  damage = {
    default = 8000,
  },
  model              = "533mmTorpedo.s3o",
  range              = 1300,
  startVelocity      = 250,
  weaponAcceleration = 230,
  weaponVelocity     = 450,
}

Weapon('RUS533mmTorpedo'):Extends('TorpedoClass'):Attrs{
  name               = "53-38 533mm torpedo",
  damage = {
    default = 50000, -- HUGE!
  },
  model              = "533mmTorpedo.s3o",
  range              = 1100,
  startVelocity      = 300,
  weaponAcceleration = 250,
  weaponVelocity     = 500,
}

Weapon('ITA450mmTorpedo'):Extends('TorpedoClass'):Attrs{
  name               = "450mm torpedo",
  damage = {
    default = 8000, -- HUGE!
  },
  model              = "450mmTorpedo.s3o",
  range              = 1300,
  sprayangle         = 1300,
  startVelocity      = 250,
  weaponAcceleration = 230,
  weaponVelocity     = 450,
}


-- Return only the full weapons
