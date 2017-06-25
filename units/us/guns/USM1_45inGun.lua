local US_M1_45inGun_Truck = LongRangeGunTractor:New{
	name					= "Towed 4.5 inch Gun M1",
	corpse					= "USM5Tractor_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
	customParams = {
		normaltex			= "",
	},
}

local US_M1_45inGun_Stationary = HGun:New{
	name					= "Deployed 4.5 inch Gun M1",
	corpse					= "USM1_45inGun_Destroyed",

	customparams = {
		guncylinderinverse2	= 1,
	},

	weapons = {
		[1] = { -- HE
			name				= "M1_45in_GunHE",
		},
		[2] = { -- Smoke
			name				= "M1_45in_GunSmoke",
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["USM1_45inGun_Truck"] = US_M1_45inGun_Truck,
	["USM1_45inGun_Stationary"] = US_M1_45inGun_Stationary,
})
