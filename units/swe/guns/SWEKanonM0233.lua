local SWEKanonM02_33_Truck = FGGunTractor:New{
	name					= "Towed 7,5cm Kanon m/02-33",
	buildCostMetal			= 1125,
	corpse					= "SWEScaniaVabisF11_destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local SWEKanonM02_33_Stationary = FGGun:New{
	name					= "Deployed 7,5cm Kanon m/02-33",
	corpse					= "ITACannone75_Destroyed",

	weapons = {
		[1] = { -- HE
			name	= "SWE75mmL30HE",
		},
		[2] = { -- AP
			name	= "SWE75mmL30AP",
		},
	},	
	customParams = {

	},
}

return lowerkeys({
	["SWEKanonM02_33_Truck"] = SWEKanonM02_33_Truck,
	["SWEKanonM02_33_Stationary"] = SWEKanonM02_33_Stationary,
})
