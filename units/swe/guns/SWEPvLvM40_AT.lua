local SWEPvLvM40_AT_Stationary = LightATGun:New{
	name					= "Deployed PvLv m/40 AT Tripod",
	description				= "Deployed AT Autocannon",
	corpse					= "ruszis2_destroyed", -- TODO: change
	buildpic				= "SWEPvLvM40_AT.png",
	stealth						= true,
	cloakCost			= 0,
	cloakTimeout		= 160,
	minCloakDistance	= 220,
	customParams = {
		scriptAnimation	= "pvlvm40",
		normaltex			= "",
	},
	weapons = {
		[1] = { -- AP
			name				= "boforsm40_20mmap", 
			maxAngleDif			= 32,
		},
		[2] = { -- HE
			name				= "boforsm40_20mmhe", 
			maxAngleDif			= 32,
		},
	},
}

local SWEPvLvM40_AA_Stationary = AAGun:New{
	name					= "Deployed PvLv m/40 AA Mount",
	corpse					= "ITABreda20_Destroyed",
	buildpic				= "SWEPvLvM40_AA.png",

	weapons = {
		[1] = { -- AA
			name				= "boforsm40_20mmaa",
		},
		[2] = { -- HE
			name				= "boforsm40_20mmhe",
		},
	},
	customParams = {
		normaltex			= "",
	},
}


return lowerkeys({
	["SWEPvLvM40_AT_Stationary"] = SWEPvLvM40_AT_Stationary,
	["SWEPvLvM40_AA_Stationary"] = SWEPvLvM40_AA_Stationary,
})
