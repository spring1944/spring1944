-- Artillery - Rocket Artillery

-- Implementations

-- Nebelwerfer 41 150mm (GER)
local Nebelwerfer41 = ArtyRocketClass:New{
  areaOfEffect       = 184,
  burst              = 6,
  burstrate          = 0.8,
  explosionGenerator = [[custom:HE_XLarge]],
  name               = [[Nebelwerfer 41 150mm unguided artillery rocket]],
  range              = 4770,
  soundStart         = [[GER_Nebelwerfer]],
  wobble             = 1300,
  damage = {
    default            = 5525,
  },
}

-- M-13 132mm (RUS)
local M13132mm = ArtyRocketClass:New{
  areaOfEffect       = 122,
  burst              = 16,
  burstrate          = 0.6,
  explosionGenerator = [[custom:HE_Large]],
  name               = [[M-13 132mm unguided artillery rocket]],
  range              = 4555,
  soundStart         = [[RUS_Katyusha]],
  wobble             = 1500,
  damage = {
    default            = 5525,
  },
}

-- M-8 82mm (RUS)
local m8rocket82mm = ArtyRocketClass:New{
  areaOfEffect       = 60,
  burst              = 8,
  burstrate          = 0.3,
  explosionGenerator = [[custom:HE_Large]],
  name               = [[M-8 82mm unguided artillery rocket]],
  range              = 2965,
  soundStart         = [[RUS_Katyusha]],
  wobble             = 1618,
  damage = {
    default            = 680,
  },
}

-- Beach Barrage Rocket
local BBR_Rack = ArtyRocketClass:New{
	areaOfEffect	= 100,
	burst		= 12,
	burstrate	= 0.5,
	explosionGenerator = [[custom:HE_Large]],
	name               = [[4.5" Beach Barrage Rocket Mk 7 Launcher]],
	range              = 800,
	soundStart         = [[RUS_Katyusha]],
	wobble             = 2500,
	damage = {
		default            = 3500,
	},
}

-- Type 4 200mm rocket mortar (JPN)
local Type4RocketMortarHE = ArtyRocketClass:New{
  areaOfEffect       = 203,
  reloadtime         = 20,
  explosionGenerator = [[custom:HE_XLarge]],
  name               = [[Type 4 200mm unguided artillery rocket]],
  range              = 3200,
  soundStart         = [[GER_Nebelwerfer]],
  wobble             = 1300,
  damage = {
    default            = 6000,
  },
}

local Type4RocketMortarSmoke = ArtyRocketClass:New{
  areaOfEffect       = 30,
  reloadtime         = 20,
  customparams = {
    smokeradius        = 350,
    smokeduration      = 50,
    smokeceg           = [[SMOKESHELL_Medium]],
  },
  name               = [[Type 4 200mm unguided artillery smoke rocket]],
  range              = 3200,
  soundStart         = [[GER_Nebelwerfer]],
  wobble             = 1300,
  damage = {
    default            = 100,
  },
}

-- Return only the full weapons
return lowerkeys({
  Nebelwerfer41 = Nebelwerfer41,
  M13132mm = M13132mm,
  m8rocket82mm = m8rocket82mm,
  BBR_Rack = BBR_Rack,
  Type4RocketMortarHE = Type4RocketMortarHE,
  Type4RocketMortarSmoke = Type4RocketMortarSmoke,
})
