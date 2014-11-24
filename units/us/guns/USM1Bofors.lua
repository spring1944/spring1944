local US_M1Bofors_Truck = AAGunTractor:New{
	name					= "Towed 40mm M1 Bofors",
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

local US_M1Bofors_Stationary = AAGun:New{
	name					= "Deployed 40mm M1 Bofors",
	corpse					= "USM1Bofors_Destroyed",
	customParams = {
		weaponcost	= 3,
	},
	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
		[3] = { -- Tracer
			name				= "LargeTracer",
		},
	},
}

local US_M1Bofors_Stationary_base = US_M1Bofors_Stationary:New{
	objectName				= "USM1Bofors_Stationary.S3O",
	script					= "USM1Bofors_Stationary.cob",
}

return lowerkeys({
	["USM1Bofors_Truck"] = US_M1Bofors_Truck,
	["US_M1Bofors_Stationary"] = US_M1Bofors_Stationary,
	["US_M1Bofors_Stationary_base"] = US_M1Bofors_Stationary_base,
})
