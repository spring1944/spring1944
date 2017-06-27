local US_M5Gun_Truck = ATGunTractor:New{
	name					= "Towed 3-Inch M5",
	buildCostMetal			= 600,
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {

	},
}

local US_M5Gun_Stationary = ATGun:New{
	name					= "Deployed 3-Inch M5",
	corpse					= "usm5gun_destroyed",
	weapons = {
		[1] = { -- AP
			name				= "M7ap",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["USM5Gun_Truck"] = US_M5Gun_Truck,
	["USM5Gun_Stationary"] = US_M5Gun_Stationary,
})
