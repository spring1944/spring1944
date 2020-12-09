local GBR_17Pdr = InfantryGun:New{
	name					= "CQ.F. 17 Pounder",
	corpse					= "gbr17pdr_destroyed",
	buildCostMetal			= 840,

	collisionVolumeType		= "box",
	collisionVolumeScales	= {17.0, 8.0, 6.0},
	collisionVolumeOffsets	= {0.0, 7.0, 6.0},

	weapons = {
		[1] = { -- AP
			name				= "qf17pdrap",
		},
	},
	customParams = {

	},
}

local GBR_17Pdr_Stationary = ATGun:New{
	name					= "Deployed Q.F. 17 Pounder",
	corpse					= "gbr17pdr_destroyed",

	weapons = {
		[1] = { -- AP
			name				= "qf17pdrap",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["GBR17Pdr"] = GBR_17Pdr,
	["GBR17Pdr_Stationary"] = GBR_17Pdr_Stationary,
})
