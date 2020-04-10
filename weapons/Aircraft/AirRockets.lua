-- Aircraft - Air Launched Rockets

-- Implementations

-- British rocket, typhoon currently uses HVAR

-- HVAR Rocket (USA)
local HVARRocket = AirRocket:New{
  accuracy	= 50,
  edgeEffectiveness  = 0.5,
  targetBorder	   = 0,
  areaOfEffect       = 28,
  name               = [[5-Inch HVAR Rocket]],
  range              = 900,
  wobble             = 50,
  reloadtime         = 2.5,
  canAttackGround    = false,
  customparams = {
    damagetype         = [[explosive]],
  },
  damage = {
    default            = 7000,
  },
}
-- RP3 Rocket (GBR)
local RP3Rocket = AirRocket:New{
  accuracy	= 150,
  edgeEffectiveness  = 0.9,
  targetBorder	   = 0,
  areaOfEffect       = 34,
  name               = [[RP3 Rocket]],
  range              = 700,
  wobble             = 80,
  reloadtime         = 2.5,
  soundHitDry        = "GEN_Explo_4",
  canAttackGround    = false,
  customparams = {
    damagetype         = [[explosive]],
  },
  damage = {
    default            = 9000,
  },
}
-- RS 82 Rocket (RUS)
local RS82Rocket = AirRocket:New{
  areaOfEffect       = 78,
  cegTag             = "RocketTrail",
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
	accuracy	= 500,
	areaOfEffect       = 184,
	--burst	= 3,
	--burstRate          = 0.233,
	explosionGenerator = [[custom:HE_XLarge]],
	reloadtime			= 20,
	name               = [[Nebelwerfer 41 150mm unguided artillery rocket]],
	range              = 950,
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
  RP3Rocket = RP3Rocket,
  RS82Rocket = RS82Rocket,
  NebelAir = AirNebelwerfer41,
})
