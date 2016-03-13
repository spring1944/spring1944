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
}

-- Vehicle solothurn as used by Hungary
local Solothurn_36MAP = Solothurn:New{
	range				= 640,
	reloadtime			= 4,	-- faster reload in a tank
}

local Solothurn_36MHE = AutoCannon:New{
	accuracy           = 300,
	burst              = 1,
	burstRate          = 0.1,
	name               = [[Solothurn S-18/100 Anti-Tank Rifle]],
	range              = 640,
	reloadTime         = 4,
	soundStart         = [[ITA_Solothurn]],
	weaponVelocity     = 1600,
	damage = {
		default            = 110,
	},
}

return lowerkeys({
  PTRD = PTRD,
  Solothurn = Solothurn,
  ScopedSolothurn = ScopedSolothurn,
  Solothurn_36MAP = Solothurn_36MAP,
  Solothurn_36MHE = Solothurn_36MHE,
})
