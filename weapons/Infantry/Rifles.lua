-- Smallarms - Infantry Rifles
-- Implementations

-- SMLE No. 4 Mk. I (GBR)
local Enfield = RifleClass:New{
  accuracy           = 50, -- overwrites default
  name               = [[Lee-Enfield No. 4 Mk. I]],
  range              = 680,
  reloadtime         = 2.5,
  soundStart         = [[GBR_Enfield]],
}

-- Karabiner 98K (GER)
local K98k = RifleClass:New{
  name               = [[Karabiner 98k]],
  range              = 665,
  reloadtime         = 2.8,
  soundStart         = [[GER_K98K]],
}

-- M1 Garand (USA)
local M1Garand = RifleClass:New{
  name               = [[M1 Garand]],
  range              = 535,
  reloadtime         = 1.7,
  soundStart         = [[US_M1garand]],
}

-- M1918A2 BAR (USA) (Possibly a little fudged in here)
local BAR = RifleClass:New{
  burst              = 3,
  burstrate          = 0.1,
  movingAccuracy     = 2667,
  name               = [[Browning Automatic Rifle]],
  range              = 710,
  reloadtime         = 2.25,
  soundStart         = [[US_BAR]],
  sprayAngle         = 300,
  customparams = {
    fearaoe            = 45,
    fearid             = 301,
  },
}

-- Mosin Nagant M1890/30 (RUS)
local MosinNagant = RifleClass:New{
  name               = [[Mosin-Nagant]],
  range              = 660,
  reloadtime         = 3,
  rgbColor           = [[0.0 0.7 0.0]], -- overwrites default
  soundStart         = [[RUS_MosinNagant]],
}

-- SVT (USSR)
local SVT = RifleClass:New{
  name               = [[SVT-40]],
  range              = 535,
  reloadtime         = 2,
  rgbColor           = [[0.0 0.7 0.0]], -- overwrites default
  soundStart         = [[RUS_SVT]],
}


-- Carcano 91/38 (ITA)
local Mod91 = RifleClass:New{
  accuracy           = 95, -- overwrites default
  name               = [[Carcano Mod.91/38]],
  range              = 610,
  reloadtime         = 2.6,
  damage = {
    default            = 30,
  },
  soundStart         = [[ITA_CarcanoM91]],
}

-- Carcano 91/41 (ITA)
local Mod91_41 = Mod91:New{
  accuracy           = 65,
  name               = [[Carcano Mod.91/41]],
  range              = 640,
}

-- Arisaka type 99 (JPN)
local Arisaka99 = RifleClass:New{
  accuracy           = 95, -- overwrites default
  name               = [[Arisaka Type 99]],
  range              = 630,
  reloadtime         = 2.5,
  soundStart         = [[JPN_Arisaka_Type99]],
}




-- Sniper Rifle Base Class
local SniperRifleClass = RifleClass:New{
  accuracy           = 0,
  explosionGenerator = [[custom:Bullet]],
  movingAccuracy     = 1777,
  range              = 1040,
  reloadtime         = 10,
  soundTrigger       = false,
  tolerance          = 2000,
  turret             = true,
  weaponType         = [[LaserCannon]],
  customparams = {
    damagetype         = [[smallarm]],
    fearaoe            = 90,
    fearid             = 401,
	scriptanimation    = [[sniper]],
  },
  damage = {
    default              = 625,
    infantry             = 1700,
    sandbags             = 325,
  },
}

-- Implementations

-- SMLE No. 4 Mk. I (T) (GBR)
local Enfield_T = SniperRifleClass:New{
  name               = [[Lee-Enfield No. 4 Mk. I Scoped]],
  reloadtime         = 8.5, -- overwrites default
  soundStart         = [[GBR_Enfield]],
}

-- Karabiner 98K Scope (GER)
local K98kScope = SniperRifleClass:New{
  name               = [[Karabiner 98k Scoped]],
  soundStart         = [[GER_K98K]],
}

-- M1903A4 Springfield (USA)
local M1903Springfield = SniperRifleClass:New{
  movingAccuracy     = 888, -- intended?
  name               = [[M1903A4 Springfield]],
  soundStart         = [[US_Springfield]],
}

-- Mosin Nagant M1890/30 PU (RUS)
local MosinNagantPU = SniperRifleClass:New{
  name               = [[Mosin-Nagant PU Scoped]],
  soundStart         = [[RUS_MosinNagant]],
}


-- Carcano 91 Sniper (ITA)
local Mod91Sniper = SniperRifleClass:New{
  name               = [[Carcano Mod.91 Sniper Model]],
  soundStart         = [[ITA_CarcanoM91]],
}

-- Arisaka type 99 Sniper (JPN)
local Arisaka99Sniper = SniperRifleClass:New{
  name               = [[Arisaka Type 99 Sniper Model]],
  soundStart         = [[JPN_Arisaka_Type99]],
}

-- Return only the full weapons
return lowerkeys({
  Enfield = Enfield,
  K98k = K98k,
  M1Garand = M1Garand,
  BAR = BAR,
  MosinNagant = MosinNagant,
  Mod91 = Mod91,
  Mod91_41 = Mod91_41,
  Arisaka99 = Arisaka99,
  -- sniper weapons
  Enfield_T = Enfield_T,
  K98kScope = K98kScope,
  M1903Springfield = M1903Springfield,
  MosinNagantPU = MosinNagantPU,
  SVT = SVT,
  Mod91Sniper = Mod91Sniper,
  Arisaka99Sniper = Arisaka99Sniper,
})
