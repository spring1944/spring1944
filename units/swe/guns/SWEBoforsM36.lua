local SWE_BoforsM36_Truck = AAGunTractor:New{
	name					= "Towed 4cm LvAkan m/36",
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

local SWE_BoforsM36_Stationary = AAGun:New{
	name					= "Deployed 4cm LvAkan m/36",
	corpse					= "SWEBoforsM36_Destroyed",
	script					= "USM1Bofors_stationary.cob",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
}

return lowerkeys({
	["SWEBoforsM36_Truck"] = SWE_BoforsM36_Truck,
	["SWEBoforsM36_Stationary"] = SWE_BoforsM36_Stationary,
})
