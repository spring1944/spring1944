-- Aircraft - Parachute Drops

-- Implementations

-- US 101st Paratrooper (USA)
local US_Paratrooper = ParaDropClass:New{
  burst              = 18,
  burstrate          = 0.15,
  name               = [[Paratroops]],
}

-- Partisan Supply Drop (RUS)
local RUS_PartisanDrop = ParaDropClass:New{
  name               = [[Partisan Supply Drop]],
}

-- Return only the full weapons
return lowerkeys({
  US_Paratrooper = US_Paratrooper,
  RUS_PartisanDrop = RUS_PartisanDrop,
})
