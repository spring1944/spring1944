local GBR_25Pdr_Truck = HGunTractor:New{
	name					= "Towed Q.F. 25 Pounder",
	corpse					= "gbrmorrisquad_destroyed",
	trackOffset				= 10,
	trackWidth				= 18,
	customParams = {
		normaltex			= "",
	},
}

local GBR_25Pdr_Stationary = HGun:New{
	name					= "Deployed Q.F. 25 Pounder",
	corpse					= "gbr25pdr_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "qf25pdrhe",
			maxAngleDif			= 50,
		},
		[2] = { -- Smoke
			name				= "qf25pdrsmoke",
			maxAngleDif			= 50,
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["GBR25Pdr_Truck"] = GBR_25Pdr_Truck,
	["GBR25Pdr_Stationary"] = GBR_25Pdr_Stationary,
})
