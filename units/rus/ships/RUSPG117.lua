local RUS_PG117 = Boat:New{
	name					= "PG-117",
	description				= "Infantry Water Transport",
	acceleration			= 0.3,
	brakeRate				= 0.15,
	buildCostMetal			= 300,
	buildTime				= 300,
	--collisionVolumeOffsets	= [[0.0 -30.0 0.0]],
	--collisionVolumeScales	= [[60.0 50.0 220.0]],
	--corpse					= "RUSPG117_dead",
	iconType				= "lttrans",
	mass					= 145,
	maxDamage				= 145,
	maxReverseVelocity		= 3.7,
	maxVelocity				= 7.4,
	movementClass			= "BOAT_Small",
	objectName				= "RUSPG117.s3o",
	transportCapacity		= 9,
	transportMass			= 450,
	transportSize			= 1,
	turnRate				= 350,	

	customparams = {
		soundCategory			= "RUS/Boat",
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
}


return lowerkeys({
	["RUSPG117"] = RUS_PG117,
})
