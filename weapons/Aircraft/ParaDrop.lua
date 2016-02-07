-- Aircraft - Parachute Drops

-- Implementations

-- US 101st Paratrooper (USA)
Weapon('US_Paratrooper_Trigger'):Extends('ParaDropClass'):Attrs{
  burst              = 18,
  burstrate          = 0.15,
  name               = [[Paratroops]],
}

-- Partisan Supply Drop (RUS)
Weapon('RUS_PartisanDrop'):Extends('ParaDropClass'):Attrs{
  name               = [[Partisan Supply Drop]],
}

-- Return only the full weapons
