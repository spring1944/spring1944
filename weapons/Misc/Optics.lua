-- Misc - Optics

-- Implementations

-- Binoculars
local Binocs = OpticClass:New{
  name               = [[Binoculars]],
  range              = 2000,
}
local Binocs2 = OpticClass:New{
  name               = [[Advanced Binoculars]],
  range              = 2250,
}

-- Return only the full weapons
return lowerkeys({
  Binocs = Binocs,
  Binocs2 = Binocs2,
})
