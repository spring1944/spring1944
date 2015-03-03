local RUSBM13N = Truck:New{
	name				= "BM-13N Katyusha",
	description			= "Self-Propelled Rocket Artillery",
	buildCostMetal		= 6800,
	iconType			= "RocketTruck",
	maxDamage			= 573,
	maxReverseVelocity	= 2.45,
	maxVelocity			= 4.9,
	trackOffset			= 4,
	trackWidth			= 11,
	script				= "<NAME>.cob", -- TODO: vehicle.lua

	weapons = {
		[1] = {
			name				= "M13132mm",
			maxAngleDif			= 20,
		},
	},
	customParams = {
		maxammo				= 1,
		weaponcost			= 940,
		weaponswithammo		= 1,
	},
}

return lowerkeys({
	["RUSBM13N"] = RUSBM13N,
})
