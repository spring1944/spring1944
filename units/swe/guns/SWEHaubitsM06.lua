local SWEHaubitsM06_Truck = HGunTractor:New{
	name					= "Towed Haubits m/06",
	corpse					= "SWEVolvoHBT_Destroyed",
	buildCostMetal			= 2650,
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local SWEHaubitsM06_Stationary = HGun:New{
	name					= "Deployed Haubits m/06",
	corpse					= "swehaubitsm06_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "haubm06150mmL11HE",
		},
		[2] = { -- Smoke
			name				= "haubm06150mmL11Smoke",
		},
	},
	customParams = {
		weapontoggle		= "smoke",
	},
}

return lowerkeys({
	["SWEHaubitsM06_Truck"] = SWEHaubitsM06_Truck,
	["SWEHaubitsM06_Stationary"] = SWEHaubitsM06_Stationary,
})
