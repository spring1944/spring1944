-- Infantry Anti-Tank Launchers

-- Implementations
-- RCL & Spigot Mortar
-- PIAT(GBR)
local PIAT = RCL_ATLClass:New{
  areaOfEffect       = 46,
  edgeEffectiveness  = 0.8,
  name               = [[P.I.A.T.]],
  range              = 245,
  soundStart         = [[GBR_PIAT]],
  customparams = {
    armor_penetration  = 100,
  },
  damage = {
    default            = 6800,
  },
}

-- Panzerfasut 60 (GER)
local Panzerfaust = RCL_ATLClass:New{
  areaOfEffect       = 55,
  edgeEffectiveness  = 0.01, -- ?
  name               = [[Panzerfaust 60]],
  range              = 235,
  soundStart         = [[GER_Panzerfaust]],
  customparams = {
    armor_penetration  = 170, -- wiki says 200?
  },
  damage = {
    default            = 6400, -- less than PIAT?
  }, 
}

-- Rocket Launchers
local Panzerschrek = Rocket_ATLClass:New{
  name               = [[RPzB 54/1 Panzerschrek]],
  range              = 360,
  soundStart         = [[GER_Panzerschrek]],
  customparams = {
    armor_penetration  = 200,
  },
  damage = {
    default            = 6280, -- same as bazooka?
  },
}

-- M9A1 Bazooka (USA)
local M9A1Bazooka = Rocket_ATLClass:New{
  name               = [[M9A1 Bazooka]],
  range              = 270,
  soundStart         = [[US_Bazooka]],
  customparams = {
    armor_penetration  = 108,
  },
  damage = {
    default            = 5280,
  },
}

-- Type 4 Rocket Launcher (JPN)
local Type4AT = Rocket_ATLClass:New{
  name               = [[Type 4 Rocket Launcher]],
  range              = 270,
  soundStart         = [[US_Bazooka]],
  targetMoveError    = 0.05,
  customparams = {
    armor_penetration  = 104,
  },
  damage = {
    default            = 5820,
  },
}

-- 44M kézi rakétavetõ
local Raketaveto44M = Rocket_ATLClass:New{
  name               = [[44M kézi rakétavetőkén]],
  range              = 260,
  soundStart         = [[GER_Panzerschrek]],
  targetMoveError    = 0.01,
  customparams = {
    armor_penetration  = 101,
  },
  damage = {
    default            = 5320,
  },
}

-- 44M Buzoganyveto
local Buzoganyveto44MHEAT = Rocket_ATLClass:New{
	name			= [[215mm 44M Buzogány]],
	range			= 740,
	burst			= 2,
	startVelocity     = 420,
	burstRate		= 0.8,
	soundStart		= [[GER_Panzerschrek]],
	customparams = {
		armor_penetration  = 300,
		weaponCost			= 50,
	},
	damage = {
		default            = 8000,
	},	
}

-- Return only the full weapons
return lowerkeys({
  -- RCL / Spigot Mortar
  PIAT = PIAT,
  Panzerfaust = Panzerfaust,
  -- Rockets
  Panzerschrek = Panzerschrek,
  M9A1Bazooka = M9A1Bazooka,
  Type4AT = Type4AT,
  Buzoganyveto44MHEAT = Buzoganyveto44MHEAT,
  Raketaveto44M = Raketaveto44M,
})
