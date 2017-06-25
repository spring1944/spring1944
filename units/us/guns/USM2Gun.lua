local US_M2Gun_Truck = HGunTractor:New{
	name					= "Towed 105mm M2",
	corpse					= "USM5Tractor_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "",
	},
}

local US_M2Gun_Stationary = HGun:New{
	name					= "Deployed 105mm M2",
	corpse					= "USM2Gun_Destroyed",

	weapons = {
		[1] = { -- HE
			name				= "M2HE",
			maxAngleDif			= 45,
		},
		[2] = { -- Smoke
			name				= "M2smoke",
			maxAngleDif			= 45,
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["USM2Gun_Truck"] = US_M2Gun_Truck,
	["USM2Gun_Stationary"] = US_M2Gun_Stationary,
})
