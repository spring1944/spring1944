local RUS_61K_Truck = AAGunTractor:New{
	name					= "Towed 37mm 61-K",
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "",
	},
}

local RUS_61K_Stationary = AAGun:New{
	name					= "Deployed 37mm 61-K",
	corpse					= "RUS61K_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "M1939_61k37mmaa",
		},
		[2] = { -- HE
			name				= "M1939_61k37mmhe",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["RUS61K_Truck"] = RUS_61K_Truck,
	["RUS61K_Stationary"] = RUS_61K_Stationary,
	["RUS61K_Stationary_base"] = RUS_61K_Stationary:Clone("RUS61K_Stationary"),
})
