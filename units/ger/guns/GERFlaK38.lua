local GER_FlaK38_Truck = AAGunTractor:New{
	name					= "Towed 2cm FlaK 38",
	buildCostMetal			= 1250,
	corpse					= "GEROpelBlitz_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "",
	},
}

local GER_FlaK38_Stationary = AAGun:New{
	name					= "Deployed 2cm FlaK 38",
	corpse					= "GERFlaK38_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "flak3820mmaa",
		},
		[2] = { -- HE
			name				= "flak3820mmhe",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["GERFlaK38_Truck"] = GER_FlaK38_Truck,
	["GERFlaK38_Stationary"] = GER_FlaK38_Stationary,
	["GERFlaK38_Stationary_base"] = GER_FlaK38_Stationary:Clone("GERFlaK38_Stationary"),
})
