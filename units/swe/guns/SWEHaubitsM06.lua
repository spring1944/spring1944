local SWEHaubitsM06_Truck = HGunTractor:New{
	name					= "Towed Haubits m/06",
	corpse					= "SWEVolvoHBT_Destroyed",
	buildCostMetal			= 2650,
	trackOffset				= 10,
	trackWidth				= 13,
}

local SWEHaubitsM06_Stationary = HGun:New{
	name					= "Deployed Haubits m/06",
	corpse					= "swehaubitsm06_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "Type38150mmL11HE",
		},
		[2] = { -- Smoke
			name				= "Type38150mmL11Smoke",
		},
	},
}

return lowerkeys({
	["SWEHaubitsM06_Truck"] = SWEHaubitsM06_Truck,
	["SWEHaubitsM06_Stationary"] = SWEHaubitsM06_Stationary,
})
