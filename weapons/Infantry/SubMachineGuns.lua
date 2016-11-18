-- Smallarms - Infantry Submachineguns

-- Implementations
-- STEN Mk. II (GBR)
local STEN = SMGClass:New{
  burstrate          = 0.1,
  name               = [[STEN Mk. II]],
  range              = 300,
  reloadtime         = 1.8,
  soundStart         = [[GBR_STEN]],
}

-- Commando Silenced STEN Mk. IIS (GBR)
-- derives from the above STEN
local SilencedSten = STEN:New({
  burst              = 3,
  movingAccuracy     = 400,
  name               = [[Silenced]],
  range              = 360,
  reloadtime         = 1.2,
  sprayAngle         = 200,
  damage = {
    default            = 80,
  }
}, true)

-- MP.40 (GER)
local MP40 = SMGClass:New{
  burstRate          = 0.12,
  movingAccuracy     = 1200, 
  name               = [[Maschinenpistole 40]],
  range              = 330,
  reloadtime         = 2,
  soundStart         = [[GER_MP40]],
}

-- M1A1 Thompson (USA)
local Thompson = SMGClass:New{
  burst              = 6,
  burstRate          = 0.086,
  movingAccuracy     = 1170, -- O_o
  name               = [[M1A1 Thompson]],
  range              = 300,
  reloadtime         = 1.7,
  soundStart         = [[US_Thompson]],
  sprayAngle         = 400, -- intended?
}

-- PPSh (RUS)
local PPSh = SMGClass:New{
  burst              = 9,
  burstRate          = 0.05,
  movingAccuracy     = 933,
  name               = [[PPsh-1941]],
  range              = 310,
  reloadtime         = 1.5,
  rgbColor           = [[0.3 0.75 0.4]],
  soundStart         = [[RUS_PPsh]],
  sprayAngle         = 500,
}

-- Beretta M38 (ITA)
local BerettaM38 = SMGClass:New{
  burst              = 8,
  burstRate          = 0.086,
  movingAccuracy     = 1300,
  name               = [[Beretta Model 38]],
  range              = 325,
  reloadtime         = 1.7,
  soundStart         = [[ITA_BerettaM38]],
  sprayAngle         = 380,
}

-- FNAB-43 (ITA)
local FNAB43 = SMGClass:New{
  burst              = 5,
  burstRate          = 0.112,
  movingAccuracy     = 800,
  name               = [[FNAB-43]],
  range              = 340,
  reloadtime         = 1.2,
  soundStart         = [[ITA_Fnab43]],
  sprayAngle         = 300,
}

local Type100SMG = SMGClass:New{
  burst              = 5,
  burstRate          = 0.066,
  movingAccuracy     = 1300,
  name               = [[Type 100 Submachinegun]],
  range              = 325,
  reloadtime         = 1.7,
  soundStart         = [[JPN_Type100_SMG]],
  sprayAngle         = 380,
}

local KPistM3738 = SMGClass:New{
	burst		= 5,
	burstRate	= 0.076,	-- sync with sound sample
	movingAccuracy	= 1300,
	name		= "kpist m/37-39",
	range		= 325,
	reloadtime	= 1.7,
	soundStart	= [[KPist_M_37_39]],
	sprayAngle	= 380,
}

-- Hungary
-- Danuvia 43M
local danuvia43m = SMGClass:New{
	burst              = 8,
	burstRate          = 0.09,
	movingAccuracy     = 1200,
	name               = [[Danuvia 43M]],
	range              = 330,
	reloadtime         = 1.8,
	soundStart         = [[ITA_BerettaM38]],
	sprayAngle         = 380,
}

-- Return only the full weapons
return lowerkeys({
  STEN = STEN,
  SilencedSten = SilencedSten,
  MP40 = MP40,
  Thompson = Thompson,
  PPSh = PPSh,
  BerettaM38 = BerettaM38,
  FNAB43 = FNAB43,
  Type100SMG = Type100SMG,
  KPistM3738 = KPistM3738,
  danuvia43m = danuvia43m,
})
