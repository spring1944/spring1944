-- Smallarms - Anti-Tank Rifles
 
-- Implementations
-- PTRD (RUS)
local PTRD = ATRifleClass:New{
  accuracy           = 225,
  name               = [[PTRD]],
  range              = 655,
  reloadtime         = 12,
  rgbColor           = [[0.0 0.7 0.0]],
  soundStart         = [[RUS_PTRD]],
  weaponVelocity     = 2024,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m = 35,
	immobilizationchance = 0.5,
  },
  damage = {
    default            = 254,
  },
}

-- Solothurn (ITA)
local Solothurn = ATRifleClass:New{
  accuracy           = 300,
  name               = [[Solothurn S-18/100 Anti-Tank Rifle]],
  range              = 640,
  reloadtime         = 12,
  rgbColor           = [[0.0 0.7 0.0]],
  soundStart         = [[ITA_Solothurn]],
  weaponVelocity     = 1240,
  customparams = {
    armor_penetration_1000m = 16,
    armor_penetration_100m = 35,
	immobilizationchance = 0.5,
  },
  damage = {
    default            = 402,
  },
}

-- Scoped Solothurn (ITA)
local ScopedSolothurn = Solothurn:New{
  accuracy           = 150,
  name               = [[Solothurn S-18/1000 Anti-Tank Rifle]],
  range              = 1010,
  customparams = {
	immobilizationchance = 0.75,	-- aimed shots - more effective at that
  },
}

-- Swedish PvGM42
local SWE_PvGM42 = ATRifleClass:New{
	name			= "Pansarvдrnsgevдr m/42",
	soundStart		= "SWE_PvGM42",
	accuracy           = 300,
	range              = 640,
	reloadtime         = 12,
	rgbColor           = [[0.0 0.7 0.0]],
	weaponVelocity     = 1240,
	customparams = {
		armor_penetration_1000m = 17,
		armor_penetration_100m = 40,
		-- this is shoulder-fired, unlike all the other AT rifles
		scriptanimation    = "atlauncher",
		immobilizationchance = 0.5,
	},
	damage = {
		default            = 402,
	},
}

return lowerkeys({
  PTRD = PTRD,
  Solothurn = Solothurn,
  ScopedSolothurn = ScopedSolothurn,
  pvgm42 = SWE_PvGM42,
})
