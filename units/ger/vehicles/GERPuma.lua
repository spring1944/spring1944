local GERPuma = HeavyArmouredCar:New{
	name				= "Sd.Kfz. 234/2 Puma",
	buildCostMetal		= 1530,
	maxDamage			= 1174,
	acceleration		= 0.052,
	trackOffset			= 10,
	trackWidth			= 13,
	brakeRate			= 0.72,
	turnrate			= 800,
	movementClass		= "TANK_6pluswheels",

	weapons = {
		[1] = {
			name				= "kwk50mml60ap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "kwk50mml60he",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "MG34",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 10,
		armor_side			= 8,
		armor_top			= 5,
		slope_front			= 55,
		slope_rear			= 46,
		slope_side			= 34,
		maxammo				= 10,
		turretturnspeed		= 12, -- manual
		reversemult			= 0.75,
		maxvelocitykmh		= 80,
		normaltex			= "unittextures/GERPuma_normals.dds",
	}
}

return lowerkeys({
	["GERPuma"] = GERPuma,
})
