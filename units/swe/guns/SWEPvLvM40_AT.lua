local SWEPvLvM40_AT_Stationary = LightATGun:New{
	name					= "Deployed PvLv m/40 AT Tripod",
	description				= "Deployed AT Autocannon",
	corpse					= "ruszis2_destroyed", -- TODO: change
	customParams = {
		weaponcost	= 10,
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

return lowerkeys({
	["SWEPvLvM40_AT_Stationary"] = SWEPvLvM40_AT_Stationary,
})
