local GBR_LCA = Boat:New{
	name					= "Landing Craft, Assault",
	description				= "Infantry Landing Craft",
	acceleration			= 0.9,
	brakeRate				= 0.5,
	buildCostMetal			= 700,
	buildTime				= 700,
	corpse					= "GBRLCA_dead",
	iconType				= "landingship",
	mass					= 914,
	maxDamage				= 914,
	maxReverseVelocity		= 0.685,
	maxVelocity				= 2,
	movementClass			= "BOAT_LandingCraftSmall",
	objectName				= "GBRLCA.s3o",
	transportCapacity		= 20,
	transportMass			= 1000,
	transportSize			= 1,
	turnRate				= 100,	
	weapons = {	
		[1] = {
			name				= "bren",
			maxAngleDif			= 90,
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
		},
		--[2] is missing?
		[3] = {
			name				= "Small_Tracer",
		},
	},
	customparams = {
		soundCategory			= "GBR/Boat",
		transportsquad			= "gbr_platoon_lca",
		armor_front				= 28.5, -- 3/8in for doors, + 3/4in? ramp
		armor_rear				= 19,
		armor_side				= 19, -- wiki says 3/4in sides
		armor_top				= 6, -- 1/4in deck
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
	["GBRLCA"] = GBR_LCA,
})
