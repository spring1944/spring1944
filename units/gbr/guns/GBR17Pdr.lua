local GBR_17Pdr_Truck = ATGunTractor:New{
	name					= "Towed Q.F. 17 Pounder",
	corpse					= "gbrmorrisquad_destroyed",
	trackOffset				= 10,
	trackWidth				= 18,
	customParams = {
		normaltex			= "",
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
		normaltex			= "",
	},
}

return lowerkeys({
	["GBR17Pdr_Truck"] = GBR_17Pdr_Truck,
	["GBR17Pdr_Stationary"] = GBR_17Pdr_Stationary,
})
