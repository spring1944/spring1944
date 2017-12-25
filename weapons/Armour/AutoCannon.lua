-- Artillery - Auto Cannon (Light AA Guns)
-- Implementations

-- FlaK 38 20mm (GER)
local FlaK3820mm = AutoCannon:New{
  accuracy           = 255,
  burst              = 4, -- 20 round box mag, 5 bursts
  burstRate          = 0.133, -- cyclic 450rpm
  reloadTime         = 1.3, -- 180rpm practical
  name               = [[2cm FlaK 38]],
  range              = 730,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 1800,
  damage = {
    default            = 110,
  },
  customparams = {
    weaponcost = 1,
  },
}

local FlaK3820mmAA = AutoCannonAA:New(FlaK3820mm, true):New{
  range              = 1560,
}
local FlaK3820mmHE = AutoCannonHE:New(FlaK3820mm, true)
local FlaK3820mmAP = AutoCannonAP:New(FlaK3820mm, true):New{
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 9,
    armor_penetration_100m  = 20,
  },
  damage = {
    default            = 385,
  },
}

-- Flakvierling
-- derives from the above, only with 4x burst (can't have 1/4 the burstrate)
local FlakVierling20mmAA = FlaK3820mmAA:New({
  burst              = 16,
  name               = [[(Quad)]],
}, true)
local FlakVierling20mmHE = FlaK3820mmHE:New({
  burst              = 16,
  name               = [[(Quad)]],
}, true)

-- Oerlikon/Polsten 20mm (GBR)
local Oerlikon20mm = AutoCannon:New{
  accuracy           = 255,
  burst              = 5, -- 15 or 30 round drum
  burstRate          = 0.133, -- cyclic 450rpm
  reloadTime         = 1.2, -- practical 250 rpm
  name               = [[20mm Oerlikon]],
  range              = 750,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 475,
  weaponVelocity     = 1640,
  damage = {
    default            = 110, -- copy from FlaK / TNSh
  },
  customparams = {
    weaponcost = 1,
  },
}

local Oerlikon20mmAA = AutoCannonAA:New(Oerlikon20mm, true):New{
  range              = 1560,
}
local Oerlikon20mmHE = AutoCannonHE:New(Oerlikon20mm, true)
local Twin_Oerlikon20mmAA = Oerlikon20mmAA:New({
  name               = [[(Twin)]],
  reloadTime         = 0.6,
}, true)

-- TNSh 20mm (RUS)
local TNSh20mm = AutoCannon:New{
  accuracy           = 300,
  burst              = 3,
  burstRate          = 0.1,
  name               = [[20mm TNSh]],
  range              = 675,
  reloadTime         = 2,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 444,
  weaponVelocity     = 1600,
  damage = {
    default            = 110,
  },
}

local TNSh20mmHE = AutoCannonHE:New(TNSh20mm, true)
local TNSh20mmAP = AutoCannonAP:New(TNSh20mm, true):New{
  weaponVelocity     = 1500,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m  = 35,
  },
  damage = {
    default            = 310,
  },
}

-- Breda M35 20mm (ITA)
local BredaM3520mm = AutoCannon:New{
  accuracy           = 100, --Why not 255 like the rest?
  burst              = 4,
  burstRate          = 0.261,
  name               = [[Breda Model 35]],
  range              = 730,
  reloadTime         = 1.6,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 300,
  weaponVelocity     = 2000,
  damage = {
    default            = 82,
  },
  customparams = {
    weaponcost = 1,
  },
}

local BredaM3520mmAA = AutoCannonAA:New(BredaM3520mm, true):New{
  range              = 1560,
  sprayAngle         = 475,
}

local TwinBredaM3520mmAA = BredaM3520mmAA:New{
  burst              = 8,
  burstRate          = 0.13,
}

local BredaM3520mmHE = AutoCannonHE:New(BredaM3520mm, true):New{
  customparams = {
    fearaoe            = 30,
  },
}

local BredaM3520mmAP = AutoCannonAP:New(BredaM3520mm, true):New{
  sprayAngle         = 400,
  weaponVelocity     = 1560,
  customparams = {
    armor_penetration_1000m = 6,
    armor_penetration_100m  = 29,
  },
  damage = {
    default            = 345,
  },
}

-- 20 mm maskinkanon M.40 S
local BoforsM40_20mm = AutoCannon:New{
	accuracy           = 255,
	burst              = 4,
	burstRate          = 0.361,
	name               = [[20 mm maskinkanon M.40 S]],
	range              = 740,
	reloadTime         = 2.2,
	soundStart         = [[GER_20mm]],
	sprayAngle         = 300,
	weaponVelocity     = 1900,
	damage = {
		default            = 121,
	},
	customparams = {
		weaponcost = 1,
	},
}

local BoforsM40_20mmAA = AutoCannonAA:New(BoforsM40_20mm, true):New{
	burst = 4,
	burstRate = 0.33,
}

local BoforsM40_20mmHE = AutoCannonHE:New(BoforsM40_20mm, true):New{
	customparams = {
		fearaoe            = 30,
	},
}

local BoforsM40_20mmAP = AutoCannonAP:New(BoforsM40_20mm, true):New{
	sprayAngle         = 200,
	weaponVelocity     = 2060,
	customparams = {	-- data taken from http://www.jaegerplatoon.net/AT_GUNS1.htm
		armor_penetration_1000m = 10,
		armor_penetration_100m  = 32,
	},
	damage = {
		default            = 345,
	},
}

-- Type 98 20mm (JPN)
local Type9820mm = AutoCannon:New{
  accuracy           = 255,
  areaOfEffect       = 15,
  burst              = 4,
  burstRate          = 0.2,
  name               = [[Type 98 20mm]],
  range              = 730,
  reloadTime         = 2,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 2000,
  damage = {
    default            = 102,
  },
}

local Type9820mmAA = AutoCannonAA:New(Type9820mm, true):New{
  range              = 1560,
}

local Type9820mmHE = AutoCannonHE:New(Type9820mm, true)

-- Type 96 25mm (JPN)
local Type9625mm = AutoCannon:New{
  accuracy           = 255,
  areaOfEffect       = 15, --if this is changed, change AA and HE aoe and fearaoe accordingly
  burst              = 5,
  burstRate          = 0.231,
  name               = [[Type 98 20mm]],
  range              = 780,
  reloadTime         = 2.7,
  soundStart         = [[GER_20mm]],
  sprayAngle         = 400,
  weaponVelocity     = 2000,
  damage = {
    default            = 145,
  },
  customparams = {
    weaponcost = 1,
  },
}

local Type9625mmAA = AutoCannonAA:New(Type9625mm, true):New{
  range              = 1620,
  damage = {
    default            = 55,
  },
}

local TwinType9625mmAA = Type9625mmAA:New{
	burst            = 10,
	burstrate        = 0.12,
    reloadtime       = 3.5,
}

local Type9625mmHE = AutoCannonHE:New(Type9625mm, true)

local TwinType9625mmHE = Type9625mmHE:New{
	burst            = 10,
	burstrate        = 0.12,
    reloadtime       = 3.5,
}

-- Vehicle solothurn as used by Hungary
local Solothurn_36MAP = AutoCannonAP:New{
	accuracy           = 300,
	burst              = 3,
	burstRate          = 0.4,
	name               = [[Solothurn S-18/100 Anti-Tank Rifle]],
	range              = 800,
	reloadTime         = 4.4,
	soundStart         = [[ITA_Solothurn]],
	SoundTrigger	= false,
	weaponVelocity     = 1600,
	customparams = {
		armor_penetration_1000m = 16,
		armor_penetration_100m = 35,
		weaponcost				= 1,
		immobilizationchance = 0.5,	-- medium
	},
	damage = {
		default            = 201,
	},
}

local Solothurn_36MHE = AutoCannonHE:New{
	accuracy           = 300,
	burst              = 3,
	burstRate          = 0.4,
	name               = [[Solothurn S-18/100 Anti-Tank Rifle]],
	range              = 800,
	reloadTime         = 4.4,
	soundStart         = [[ITA_Solothurn]],
	SoundTrigger	= false,
	weaponVelocity     = 1600,
	customparams = {
		weaponcost				= 1,
	},
	damage = {
		default            = 110,
	},
}

-- French guns
local Canon_25_SA_35 = AutoCannon:New{
	accuracy           = 255,
	burst              = 2,
	name               = [[Canon de 25 SA 35]],
	range              = 740,
	reloadTime         = 3,
	soundStart         = [[GER_20mm]],
	weaponVelocity     = 2100,
	damage = {
		default            = 121,
	},
	customparams = {
		weaponcost = 1,
	},
}

local Canon_25_SA_35_AP = AutoCannonAP:New(Canon_25_SA_35, true):New{
	customparams = {	-- data taken from http://www.littlewars.se/french1940/gundata.html
		armor_penetration_1000m = 30,
		armor_penetration_100m  = 47,	-- note: this is the short tank version, towed gun is longer = even more penetration. Crazy for just a 25mm
	},
	damage = {
		default            = 540,
	},
}

local Canon_25_SA_35_HE = AutoCannonHE:New(Canon_25_SA_35, true):New{
	customparams = {
		fearaoe            = 35,
	},
}

local Canon_25_SA_34_AP = AutoCannonAP:New(Canon_25_SA_35, true):New{
	customparams = {	-- data taken from http://www.littlewars.se/french1940/gundata.html
		armor_penetration_1000m = 30,
		armor_penetration_100m  = 54,	-- longer towed version
	},
	damage = {
		default            = 540,
	},
}

-- Return only the full weapons
return lowerkeys({
  -- FlaK 38
  FlaK3820mmAA = FlaK3820mmAA,
  FlaK3820mmHE = FlaK3820mmHE,
  FlaK3820mmAP = FlaK3820mmAP,
  FlakVierling20mmAA = FlakVierling20mmAA,
  FlakVierling20mmHE = FlakVierling20mmHE,
  -- Oerlikon
  Oerlikon20mmAA = Oerlikon20mmAA,
  Oerlikon20mmHE = Oerlikon20mmHE,
  Twin_Oerlikon20mmAA = Twin_Oerlikon20mmAA,
  -- TNSh
  TNSh20mmHE = TNSh20mmHE,
  TNSh20mmAP = TNSh20mmAP,
  -- Breda M30
  BredaM3520mmAA = BredaM3520mmAA,
  TwinBredaM3520mmAA = TwinBredaM3520mmAA,
  BredaM3520mmHE = BredaM3520mmHE,
  BredaM3520mmAP = BredaM3520mmAP,
  -- Type 98
  Type9820mmAA = Type9820mmAA,
  Type9820mmHE = Type9820mmHE,
  -- Type 96
  Type9625mmAA = Type9625mmAA,
  TwinType9625mmAA = TwinType9625mmAA,
  Type9625mmHE = Type9625mmHE,
  TwinType9625mmHE = TwinType9625mmHE,
  -- Bofors 20mm
  BoforsM40_20mmHE = BoforsM40_20mmHE,
  BoforsM40_20mmAP = BoforsM40_20mmAP,
  BoforsM40_20mmAA = BoforsM40_20mmAA,
  -- Hungarian AT rifle used as vehicle weapon, had to move it here as it is AP/HE like a cannon
  Solothurn_36MAP = Solothurn_36MAP,
  Solothurn_36MHE = Solothurn_36MHE,
  -- French tank version of 25mm
  Canon_25_SA_35_AP = Canon_25_SA_35_AP,
  Canon_25_SA_35_HE = Canon_25_SA_35_HE,
  Canon_25_SA_34_AP = Canon_25_SA_34_AP,
})
