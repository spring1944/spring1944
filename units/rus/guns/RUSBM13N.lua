local RUSBM13N = Truck:New{
	name				= "BM-13N Katyusha",
	description			= "Self-Propelled Rocket Artillery",
	buildCostMetal		= 6800,
	iconType			= "rockettruck",
	maxDamage			= 573,
	trackOffset			= 4,
	trackWidth			= 11,
	fireState			= 0,
	script				= "<NAME>.lua", -- TODO: vehicle.lua

	weapons = {
		[1] = {
			name				= "M13132mm",
			maxAngleDif			= 20,
		},
	},
	customParams = {
		maxammo				= 1,
		maxvelocitykmh		= 69,

	},
}

return lowerkeys({
	["RUSBM13N"] = RUSBM13N,
})
