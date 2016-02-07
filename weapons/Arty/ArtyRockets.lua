-- Artillery - Rocket Artillery

-- Implementations

-- Nebelwerfer 41 150mm (GER)
Weapon('Nebelwerfer41'):Extends('ArtyRocket'):Attrs{
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
Weapon('M13132mm'):Extends('ArtyRocket'):Attrs{
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
Weapon('m8rocket82mm'):Extends('ArtyRocket'):Attrs{
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
	weaponcost         = 22,
  },
}

-- Beach Barrage Rocket
Weapon('BBR_Rack'):Extends('ArtyRocket'):Attrs{
	areaOfEffect	= 100,
	burst		= 12,
	burstrate	= 0.5,
	explosionGenerator = [[custom:HE_Large]],
  	model              = [[Rocket_HVAR.S3O]],
	name               = [[4.5" Beach Barrage Rocket Mk 7 Launcher]],
	range              = 950,
  	startVelocity      = 600,
	tolerance          = 300,
	soundStart         = [[GER_Panzerschrek]],
	wobble             = 500,
	damage = {
		default            = 2500,
	},
}

-- Type 4 200mm rocket mortar (JPN)
Weapon('Type4RocketMortar'):Extends('ArtyRocket'):Attrs{
  name               = "Type 4 200mm unguided artillery rocket",
  reloadtime         = 20,
  range              = 3200,
  soundStart         = [[GER_Nebelwerfer]],
  wobble             = 1300,
  customparams = {
    weaponcost    = 70,
  },  
}

Weapon('Type4RocketMortarHE'):Extends('Type4RocketMortar'):Attrs{
  areaOfEffect       = 203,
  explosionGenerator = [[custom:HE_XLarge]],
  
  damage = {
    default            = 6000,
  },
}

Weapon('Type4RocketMortarSmoke'):Extends('Type4RocketMortar'):Attrs{
  areaOfEffect       = 30,

  customparams = {
    smokeradius        = 350,
    smokeduration      = 50,
    smokeceg           = [[SMOKESHELL_Medium]],
  },
  damage = {
    default            = 100,
  },
}

-- Return only the full weapons
