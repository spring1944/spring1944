local US_LCVP = Boat:New{
	name					= "Landing Craft, Vehicle, Personnel",
	description				= "Infantry Landing Craft",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 800,
	buildTime				= 800,
	corpse					= "USLCVP_dead",
	iconType				= "landingship",
	mass					= 820,
	maxDamage				= 820,
	maxReverseVelocity		= 0.5,
	maxVelocity				= 2,
	movementClass			= "BOAT_LandingCraftSmall",
	transportCapacity		= 25,
	transportMass			= 1500,
	transportSize			= 1,
	turnRate				= 180,	
	weapons = {	
		[1] = {
			name				= "m1919a4browning",
			maxAngleDif			= 200,
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "m1919a4browning",
			maxAngleDif			= 200,
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
			mainDir				= [[-1 0 0]],
		},
		[3] = {
			name				= "Small_Tracer",
		},
	},
	customparams = {
		soundCategory			= "US/Boat",
		transportsquad			= "us_platoon_lcvp",
		supplyRange				= 350,
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			"custom:MG_MUZZLEFLASH",
		},
	},
}


return lowerkeys({
	["USLCVP"] = US_LCVP,
})
