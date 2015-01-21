-- Aircraft - Air Launched Rockets

-- Implementations

-- British rocket, typhoon currently uses HVAR

-- HVAR Rocket (USA)
local HVARRocket = AirRocketClass:New{
  areaOfEffect       = 18,
  name               = [[5-Inch HVAR Rocket]],
  range              = 1500,
  reloadtime         = 2.5,
  customparams = {
    armor_penetration  = 38,
    armor_hit_side     = [[top]],
    damagetype         = [[shapedcharge]],
  },
  damage = {
    default            = 7000,
  },
}
-- RS 82 Rocket (RUS)
local RS82Rocket = AirRocketClass:New{
  areaOfEffect       = 78,
  name               = [[high-explosive RS82 Rocket]],
  range              = 1400,
  wobble             = 2100,
  soundStart         = [[RUS_RS82]],
  size		     = 0.5,
  leadLimit	     = 500,
  reloadtime         = 1.8,
  customparams = {
    damagetype         = [[explosive]],
  },
  damage = {
    default            = 1700,
  },
}

-- Return only the full weapons
return lowerkeys({
  HVARRocket = HVARRocket,
  RS82Rocket = RS82Rocket,
})
