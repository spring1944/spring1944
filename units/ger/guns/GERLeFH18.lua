local GER_LeFH18_Truck = HGunTractor:New{
	name					= "Towed 10.5cm LeFH 18M",
	corpse					= "GERSdKfz11_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "",
	},
}

local GER_LeFH18_Stationary = HGun:New{
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
		normaltex			= "",
	},
}

return lowerkeys({
	["GERLeFH18_Truck"] = GER_LeFH18_Truck,
	["GERLeFH18_Stationary"] = GER_LeFH18_Stationary,
})
