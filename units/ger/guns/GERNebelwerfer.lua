local GER_Nebelwerfer_Truck = RGunTractor:New{
	name					= "Towed 15cm Nebelwerfer 41",
	corpse					= "GEROpelBlitz_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local GER_Nebelwerfer_Stationary = RGun:New{
	name					= "Deployed 15cm Nebelwerfer 41",
	corpse					= "gernebelwerfer_destroyed",
	customParams = {
		maxammo		= 1,
	},
	weapons = {
		[1] = {
			name				= "Nebelwerfer41",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["GERNebelwerfer_Truck"] = GER_Nebelwerfer_Truck,
	["GERNebelwerfer_Stationary"] = GER_Nebelwerfer_Stationary,
})
