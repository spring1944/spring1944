-- Flamethrowers

-- Implementations
-- Wasp Flamethrower (GBR)
Weapon('WaspFlamethrower'):Extends('FlamerClass'):Attrs{
  areaOfEffect       = 90,
  burst              = 10,
  name               = [[Wasp Flamethrower]],
  range              = 300,
  customparams = {
    fearaoe            = 75,
  },
}

-- M2 Flamethrower (USA)
Weapon('M2Flamethrower'):Extends('FlamerClass'):Attrs{
  areaOfEffect       = 80,
  burst              = 5,
  name               = [[M2-2 Flamethrower]],
  range              = 260,
  customparams = {
    fearaoe            = 60,
  },
}

-- Model 41 Lanciafiamme
Weapon('Mod41Lanciafiamme'):Extends('FlamerClass'):Attrs{
  areaOfEffect       = 78,
  burst              = 5,
  burstRate          = 0.075,
  name               = [[Model 41 Flamethrower]],
  range              = 208,
  customparams = {
    fearaoe            = 60,
  },
  damage = {
    default            = 20,
  }
}


-- L6 Lanciafiamme (ITA)
Weapon('L6Lanciafiamme'):Extends('FlamerClass'):Attrs{
  areaOfEffect       = 88,
  burst              = 10,
  burstRate          = 0.075,
  name               = [[L6 Lanciafiamme]],
  range              = 300,
  customparams = {
    fearaoe            = 75,
  },
  damage = {
    default            = 22,
  }
}

-- Return only the full weapons
