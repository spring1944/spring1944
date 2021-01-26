local US_M1Bofors_Truck = AAGunTractor:New{
	name					= "Towed 40mm M1 Bofors",
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "unittextures/USM1BoforsTruck_normals.png",
	},
}

local US_M1Bofors_Stationary = AAGun:New{
	name					= "Deployed 40mm M1 Bofors",
	corpse					= "USM1Bofors_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
	customParams = {
		normaltex			= "unittextures/USM1Bofors_normals.png",
	},
}

return lowerkeys({
	["USM1Bofors_Truck"] = US_M1Bofors_Truck,
	["USM1Bofors_Stationary"] = US_M1Bofors_Stationary,
	["USM1Bofors_Stationary_base"] = US_M1Bofors_Stationary:Clone("USM1Bofors_Stationary"),
})
