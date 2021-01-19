local GBR_Bofors_Truck = AAGunTractor:New{
	name					= "Towed Q.F. 40mm Bofors",
	corpse					= "GBRBedfordTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/GBRBoforsTruck_normals.png",
	},
}

local GBR_Bofors_Stationary = AAGun:New{
	name					= "Deployed Q.F. 40mm Bofors",
	corpse					= "GBRBofors_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
	customParams = {
		normaltex			= "unittextures/GBRBofors_normals.png",
	},
}

return lowerkeys({
	["GBRBofors_Truck"] = GBR_Bofors_Truck,
	["GBRBofors_Stationary"] = GBR_Bofors_Stationary,
	["GBRBofors_Stationary_base"] = GBR_Bofors_Stationary:Clone("GBRBofors_Stationary"),
})
