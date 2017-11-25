local HUN_LeFH18_Truck = HGunTractor:New{
	name					= "Towed 10.5cm LeFH 18M",
	corpse					= "HUNHansaLloyd_Burning",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local HUN_LeFH18_Stationary = HGun:New{
	name					= "Deployed 10.5cm LeFH 18M",
	corpse					= "gerlefh18_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "leFH18HE",
		},
		[2] = { -- Smoke
			name				= "leFH18smoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["HUNLeFH18_Truck"] = HUN_LeFH18_Truck,
	["HUNLeFH18_Stationary"] = HUN_LeFH18_Stationary,
})
