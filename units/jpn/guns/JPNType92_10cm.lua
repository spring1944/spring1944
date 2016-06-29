local JPN_Type92_10cm_Truck = HGunTractor:New{
	name					= "Towed Type 92 10cm Cannon",
	buildCostMetal			= 3000,
	corpse					= "JPNType98_RoKe_Destroyed", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 17,
}

local JPN_Type92_10cm_Stationary = HGun:New{
	name					= "Deployed Type 92 10cm Cannon",
	corpse					= "JPNType92_10cm_Destroyed",
	weapons = {
		[1] = { -- HE
			name				= "Type92_10cmHE",
		},
		[2] = { -- Smoke
			name				= "Type92_10cmSmoke",
		},
	},
}

return lowerkeys({
	["JPNType92_10cm_Truck"] = JPN_Type92_10cm_Truck,
	["JPNType92_10cm_Stationary"] = JPN_Type92_10cm_Stationary,
})
