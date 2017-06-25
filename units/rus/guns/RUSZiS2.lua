local RUS_ZiS2_Truck = ATGunTractor:New{
	name					= "Towed 57mm ZiS-2",
	buildCostMetal			= 450,
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "",
	},
}

local RUS_ZiS2_Stationary = LightATGun:New{
	name					= "Deployed 57mm ZiS-2",
	corpse					= "ruszis2_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "zis257mmap",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["RUSZiS2_Truck"] = RUS_ZiS2_Truck,
	["RUSZiS2_Stationary"] = RUS_ZiS2_Stationary,
})
