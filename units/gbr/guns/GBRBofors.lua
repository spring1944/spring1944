local GBR_Bofors_Truck = AAGunTractor:New{
	name					= "Towed Q.F. 40mm Bofors",
	corpse					= "GBRBedfordTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

local GBR_Bofors_Stationary = AAGun:New{
	name					= "Deployed Q.F. 40mm Bofors",
	corpse					= "GBRBofors_Destroyed",
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

local GBR_Bofors_Stationary_base = GBR_Bofors_Stationary:New{
	objectName				= "GBRBofors_Stationary.S3O",
	script					= "GBRBofors_Stationary.cob",
}

return lowerkeys({
	["GBRBofors_Truck"] = GBR_Bofors_Truck,
	["GBRBofors_Stationary"] = GBR_Bofors_Stationary,
	["GBRBofors_Stationary_base"] = GBR_Bofors_Stationary_base,
})
