local RUS_A19_Truck = LongRangeGunTractor:New{
	name					= "Towed 122mm A-19",
	buildCostMetal			= 3500,
	corpse					= "RUSYa12_abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "",
	},
}

local RUS_A19_Stationary = HGun:New{
	name					= "Deployed 122mm A-19",
	corpse					= "RUSM30_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "A19HE",
		},
		[2] = { -- Smoke
			name				= "A19Smoke",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["RUSA19_Truck"] = RUS_A19_Truck,
	["RUSA19_Stationary"] = RUS_A19_Stationary,
})
