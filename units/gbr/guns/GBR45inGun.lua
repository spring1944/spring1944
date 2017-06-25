local GBR_4_5in_Truck = LongRangeGunTractor:New{
	name					= "Towed BL 4.5 inch Medium Gun",
	corpse					= "gbrmatador_destroyed",
	trackOffset				= 10,
	trackWidth				= 18,
	customParams = {
		normaltex			= "",
	},
}

local GBR_4_5in_Stationary = HGun:New{
	name					= "Deployed BL 4.5 inch Medium Gun",
	corpse					= "gbr45ingun_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "BL45inGunHE",
		},
		[2] = { -- Smoke
			name				= "BL45inGunSmoke",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["GBR45inGun_Truck"] = GBR_4_5in_Truck,
	["GBR45inGun_Stationary"] = GBR_4_5in_Stationary,
})
