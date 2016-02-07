Unit('SWEPvLvM40_AT_Stationary'):Extends('LightATGun'):Attrs{
	name					= "Deployed PvLv m/40 AT Tripod",
	description				= "Deployed AT Autocannon",
	corpse					= "ruszis2_destroyed", -- TODO: change
	customParams = {
		scriptAnimation	= "pvlvm40",
	},
	weapons = {
		[1] = { -- AP
			name				= "flak3820mmap", -- TODO: change
			maxAngleDif			= 20,
		},
		[2] = { -- HE
			name				= "flak3820mmhe", -- TODO: change
			maxAngleDif			= 20,
		},
	},
}

