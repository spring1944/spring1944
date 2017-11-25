local GER_SiebelFahre = Boat:New{
	name					= "Siebel Fahre",
	description				= "Infantry Ferry",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 1200,
	iconType				= "pontoon",
	maxDamage				= 10000,
	maxReverseVelocity		= 0.325,
	maxVelocity				= 1.7,
	movementClass			= "BOAT_LandingCraft",
	transportCapacity		= 48,
	transportMass			= 4000,
	transportSize			= 2,
	turnRate				= 30,	
	weapons = {	
		[1] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 320,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 320,
			mainDir				= [[-1 0 0]],
		},
		[3] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
		[4] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 320,
			mainDir				= [[1 0 0]],
		},
		[5] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 320,
			mainDir				= [[-1 0 0]],
		},
		[6] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		supplyRange				= 400,
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]

	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[2] = "custom:PLACEHOLDER_EFFECT01",
			[3] = "custom:PLACEHOLDER_EFFECT02",
			[4] = "custom:PLACEHOLDER_EFFECT03",
			[5] = "custom:PLACEHOLDER_EFFECT04",
			[6] = "custom:XSMALL_MUZZLEFLASH",
			[7] = "custom:XSMALL_MUZZLEDUST",
			[8] = "custom:MG_MUZZLEFLASH",
			[9] = "custom:SMALL_MUZZLEFLASH",
			[10] = "custom:SMALL_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["GERSiebelFahre"] = GER_SiebelFahre,
})
