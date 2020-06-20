local HUN_44M_HeavyAT_Truck = ATGunTractor:New{
	name					= "Kfz.69 with 44M Buzogányvető",
	corpse					= "HUNKfz69_destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {

	},
}

local HUN_44MHeavyAT_Stationary = LightATGun:New{
	name					= "Deployed 44M Buzogányvető",
	corpse					= "hun44mbuzoganyveto_destroyed",
	cloakCost			= 0,
	cloakCostMoving		= 0,
	decloakOnFire		= true,
	minCloakDistance	= 220,
	customParams = {
		maxammo		= 2,
	},

	weapons = {
		[1] = { -- AP
			name				= "Buzoganyveto44MHEAT",
			maxAngleDif			= 360,	-- this has full rotation
		},
	},
	customParams = {

	},
}
	
return lowerkeys({
	["hun44mbuzoganyveto_truck"] = HUN_44M_HeavyAT_Truck,
	["hun44mbuzoganyveto_stationary"] = HUN_44MHeavyAT_Stationary,
})
