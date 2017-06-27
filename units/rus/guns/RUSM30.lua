local RUS_M30_Truck = HGunTractor:New{
	name					= "Towed 122mm M-30",
	buildCostMetal			= 2000,
	corpse					= "RUSYa12_abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local RUS_M30_Stationary = HGun:New{
	name					= "Deployed 122mm M-30",
	corpse					= "RUSM30_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "m30122mmHE",
		},
		[2] = { -- Smoke
			name				= "m30122mmSmoke",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["RUSM30_Truck"] = RUS_M30_Truck,
	["RUSM30_Stationary"] = RUS_M30_Stationary,
})
