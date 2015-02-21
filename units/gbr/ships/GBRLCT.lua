local GBR_LCT = Boat:New{
	name					= "LCT Mk. 4",
	description				= "Tank Landing Craft",
	acceleration			= 0.001,
	brakeRate				= 0.001,
	buildCostMetal			= 2100,
	category 				= "LARGESHIP SHIP MINETRIGGER",
	buildTime				= 2100,
	collisionVolumeOffsets	= [[0.0 0.0 0.0]],
	collisionVolumeScales	= [[60.0 100.0 220.0]],
	corpse					= "GBRLCT_dead",
	iconType				= "transportship",
	loadingRadius			= 350,
	mass					= 35000,
	maxDamage				= 35000,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 2,
	movementClass			= "BOAT_LandingCraft",
	objectName				= "GBRLCT.s3o",
	transportCapacity		= 30,
	transportMass			= 27000,
	transportSize			= 54,
	turnRate				= 35,	
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
			name				= "Large_Tracer",
		},
	},
	customparams = {
		soundCategory			= "GBR/Boat",
		supplyRange				= 600,
		transportsquad			= "gbr_platoon_lct",
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:XSMALL_MUZZLEFLASH",
			[9] = "custom:XSMALL_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["GBRLCT"] = GBR_LCT,
})
