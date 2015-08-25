-- Smallarms - Infantry Pistols

-- Implementations
-- Enfield No. 2 Mk. I (GBR)
local Webley = PistolClass:New{
  name               = [[Enfield No. 2 Mk. I]], soundStart         = [[GBR_Webley]],
  damage = {
    default            = 35, -- intended?
  },
}

-- Walter P38 (GER)
local WaltherP38 = PistolClass:New{
  name               = [[Walther P38]],
  soundStart         = [[GER_Walther]],
}

-- M1911A1 Colt (USA)
local M1911A1Colt = PistolClass:New{
  name               = [[M1911A1 Colt]],
  reloadtime         = 1, -- intended?
  soundStart         = [[US_Colt]],
  sprayAngle         = 50, -- intended?
}

-- Tokarev TT-33 (RUS)
local TT33 = PistolClass:New{
  name               = [[Tokarev TT-33]],
  reloadtime         = 1.5, -- intended?
  soundStart         = [[RUS_TT33]],
  damage = {
    default            = 41, -- intended?
  },
}

-- Beretta M1934 (ITA)
local BerettaM1934 = PistolClass:New{
  name               = [[Beretta M1934]],
  reloadtime         = 1, -- intended?
  soundStart         = [[ITA_BerettaM34]],
  sprayAngle         = 50, -- intended?
}

local NambuType14 = PistolClass:New{
  name               = [[Nambu Type 14 8mm]],
  reloadtime         = 1, -- intended?
  soundStart         = [[ITA_BerettaM34]],
  sprayAngle         = 50, -- intended?
}

-- Return only the full weapons
return lowerkeys({
  Webley = Webley,
  WaltherP38 = WaltherP38,
  M1911A1Colt = M1911A1Colt,
  TT33 = TT33,
  BerettaM1934 = BerettaM1934,
  NambuType14 = NambuType14,
})
