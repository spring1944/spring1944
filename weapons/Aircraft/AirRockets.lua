-- Aircraft - Air Launched Rockets

-- Implementations

-- British rocket, typhoon currently uses HVAR

-- HVAR Rocket (USA)
local HVARRocket = AirRocket:New{
  areaOfEffect       = 18,
  name               = [[5-Inch HVAR Rocket]],
  range              = 900,
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
local RS82Rocket = AirRocket:New{
  areaOfEffect       = 78,
  name               = [[high-explosive RS82 Rocket]],
  range              = 800,
  wobble             = 2100,
  soundStart         = [[RUS_RS82]],
  size		     = 0.5,
  reloadtime         = 1.8,
  customparams = {
    damagetype         = [[explosive]],
    onlyTargetCategory = "HARDVEH OPENVEH SHIP LARGESHIP BUILDING DEPLOYED INFANTRY TURRET",
  },
  damage = {
    default            = 1700,
  },
}

-- Air-based nebelwerfer
local AirNebelwerfer41 = AirRocket:New{
	accuracy	= 2000,
	areaOfEffect       = 184,
	burst	= 3,
	burstRate          = 0.233,
	explosionGenerator = [[custom:HE_XLarge]],
	reloadtime			= 12,
	name               = [[Nebelwerfer 41 150mm unguided artillery rocket]],
	range              = 1250,
	soundStart         = [[GER_Nebelwerfer]],
	wobble             = 2800,
	customparams = {
		damagetype			= [[explosive]],
	},
	damage = {
		default            = 5525,
	},
}

-- Return only the full weapons
return lowerkeys({
  HVARRocket = HVARRocket,
  RS82Rocket = RS82Rocket,
  NebelAir = AirNebelwerfer41,
})
