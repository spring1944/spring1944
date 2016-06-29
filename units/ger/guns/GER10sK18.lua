local GER_10sK18_Truck = HGunTractor:New{
	name					= "Towed 10cm sK 18",
	corpse					= "GERSdKfz7_Destroyed",
	trackOffset				= 10,
	trackWidth				= 19,
}

local GER_10sK18_Stationary = HGun:New{
	name					= "Deployed 10cm sK 18",
	corpse					= "ger10sk18_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "GER10sK18HE",
		},
		[2] = { -- Smoke
			name				= "GER10sK18Smoke",
		},
	},
}

return lowerkeys({
	["GER10sK18_Truck"] = GER_10sK18_Truck,
	["GER10sK18_Stationary"] = GER_10sK18_Stationary,
})
