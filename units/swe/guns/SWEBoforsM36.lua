local SWE_BoforsM36_Truck = AAGunTractor:New{
	name					= "Towed 4cm LvAkan m/36",
	corpse					= "SWEScaniaVabisF11_destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
	customParams = {
		normaltex			= "unittextures/SWEBoforsM36_Truck_normals.png",
	},
}

local SWE_BoforsM36_Stationary = AAGun:New{
	name					= "Deployed 4cm LvAkan m/36",
	corpse					= "USM1Bofors_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "bofors40mmaa",
		},
		[2] = { -- HE
			name				= "bofors40mmhe",
		},
	},
	customParams = {
		normaltex			= "unittextures/SWEBoforsM36_normals.png",
	},
}

return lowerkeys({
	["SWEBoforsM36_Truck"] = SWE_BoforsM36_Truck,
	["SWEBoforsM36_Stationary"] = SWE_BoforsM36_Stationary,
})
