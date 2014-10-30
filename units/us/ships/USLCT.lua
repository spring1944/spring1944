local US_LCT = Boat:New{
	name					= "LCT Mk. 5",
	description				= "Tank Landing Craft",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 1600,
	buildTime				= 1600,
	collisionVolumeOffsets	= [[0.0 -30.0 0.0]],
	collisionVolumeScales	= [[60.0 50.0 220.0]],
	corpse					= "USLCT_dead",
	iconType				= "transportship",
	mass					= 29100,
	maxDamage				= 29100,
	maxReverseVelocity		= 0.35,
	maxVelocity				= 2,
	movementClass			= "BOAT_LandingCraft",
	objectName				= "USLCT.s3o",
	transportCapacity		= 30,
	transportMass			= 15000,
	transportSize			= 30,
	turnRate				= 140,	
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 240,
			onlyTargetCategory	= "AIR",
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 240,
			onlyTargetCategory	= "AIR",
			mainDir				= [[-1 0 0]],
		},
		[3] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 240,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir				= [[1 0 0]],
		},
		[4] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 240,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir				= [[-1 0 0]],
		},
		[5] = {
			name				= "LargeTracer",
		},
	},
	customparams = {
		soundCategory			= "US/Boat",
		transportsquad			= "us_platoon_lct",
		supplyRange				= 600,
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
}


return lowerkeys({
	["USLCT"] = US_LCT,
})
