local ITA_Breda20_Truck = AAGunTractor:New{
	name					= "Towed Breda 20/65",
	buildCostMetal			= 1100,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/ITABreda20_truck_normals.png",
	},
}

local ITA_Breda20_Stationary = AAGun:New{
	name					= "Deployed Breda 20/65",
	corpse					= "ITABreda20_Destroyed",

	weapons = {
		[1] = { -- AA
			name				= "BredaM3520mmAA",
		},
		[2] = { -- HE
			name				= "BredaM3520mmHE",
		},
	},
	customParams = {
		normaltex			= "unittextures/ITABreda20_Stationary_normals.png",
	},
}

return lowerkeys({
	["ITABreda20_Truck"] = ITA_Breda20_Truck,
	["ITABreda20_Stationary"] = ITA_Breda20_Stationary,
	["ITABreda20_Stationary_base"] = ITA_Breda20_Stationary:Clone("ITABreda20_Stationary"),
})
