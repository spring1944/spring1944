local GER_SchSturmboot = Boat:New{
	name					= "Schwere Sturmboot 42",
	description				= "Infantry Landing Craft",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 400,
	buildTime				= 400,
	corpse					= "GERSchSturmboot_dead",
	iconType				= "landingship",
	mass					= 950,
	maxDamage				= 950,
	maxReverseVelocity		= 0.76,
	maxVelocity				= 1.52,
	movementClass			= "BOAT_LandingCraftSmall",
	objectName				= "GERSchSturmboot.s3o",
	transportCapacity		= 20,
	transportMass			= 1000,
	transportSize			= 1,
	turnRate				= 165,	

	customparams = {
		soundCategory			= "GER/Boat",
		transportsquad			= "ger_platoon_ssb",
		supplyRange				= 350,
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
}


return lowerkeys({
	["GERSchSturmboot"] = GER_SchSturmboot,
})
