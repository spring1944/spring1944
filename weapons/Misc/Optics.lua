-- Misc - Optics

-- Implementations

-- Binoculars
local Binocs = OpticClass:New{
  name               = [[Binoculars]],
  range              = 2000,
}


-- Return only the full weapons
return lowerkeys({
  Binocs = Binocs,
})
