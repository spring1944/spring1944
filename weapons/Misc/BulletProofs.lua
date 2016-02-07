-- Misc - Bulletproofs

-- Implementations

-- .30cal proof
Weapon('Bounce30cal'):Extends('BulletProofClass'):Attrs{
  shieldInterceptType = 8, -- 001000
  shieldRadius       = 35,
}

-- .50cal proof
Weapon('Bounce50cal'):Extends('BulletProofClass'):Attrs{
  shieldInterceptType = 24, -- 011000
  shieldRadius       = 40,
}

-- Return only the full weapons
