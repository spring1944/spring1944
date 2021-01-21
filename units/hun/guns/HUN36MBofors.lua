local HUN_BoforsM36_Truck = AAGunTractor:New{
	name					= "Towed 36M Bofors",
	corpse					= "HUN38MBotond_Abandoned",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "unittextures/HUN36MBofors_normals.png",
	},
}

local HUN_BoforsM36_Stationary = AAGun:New{
	name					= "Deployed 36M Bofors",
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
		normaltex			= "unittextures/HUN36MBofors_normals.png",
	},
}

return lowerkeys({
	["HUN36MBofors_Truck"] = HUN_BoforsM36_Truck,
	["HUN36MBofors_Stationary"] = HUN_BoforsM36_Stationary,
	["HUN36MBofors_Stationary_base"] = HUN_BoforsM36_Stationary:Clone("HUN36MBofors_Stationary"),
})
