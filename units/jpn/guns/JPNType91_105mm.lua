local JPN_Type91_105mm_Truck = HGunTractor:New{
	name					= "Towed Type 91 105mm Howitzer",
	buildCostMetal			= 1850, -- TODO: why?
	corpse					= "JPNShiKe_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

local JPN_Type91_105mm_Stationary = HGun:New{
	name					= "Deployed Type 91 105mm Howitzer",
	corpse					= "JPNType91_105mm_Destroyed",
	customParams = {
		weaponcost	= 25,
	},
	weapons = {
		[1] = { -- HE
			name				= "Type91105mmL24HE",
		},
		[2] = { -- Smoke
			name				= "Type91105mmL24smoke",
		},
	},
}

return lowerkeys({
	["JPNType91_105mm_Truck"] = JPN_Type91_105mm_Truck,
	["JPNType91_105mm_Stationary"] = JPN_Type91_105mm_Stationary,
})
