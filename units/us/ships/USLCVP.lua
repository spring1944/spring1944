local US_LCVP = InfantryLandingCraft:New{
	name					= "Landing Craft, Vehicle, Personnel",
	acceleration			= 0.2,
	brakeRate				= 0.14,
	buildCostMetal			= 500,
	maxDamage				= 820,
	maxReverseVelocity		= 0.5,
	maxVelocity				= 4.2,
	transportCapacity		= 25,
	transportMass			= 1275,
	turnRate				= 180,	
	weapons = {	
		[1] = {
			name				= "m1919a4browning",
			maxAngleDif			= 200,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "m1919a4browning",
			maxAngleDif			= 200,
			mainDir				= [[-1 0 0]],
		},
	},
	customparams = {
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
		normaltex			= "",
	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			"custom:MG_MUZZLEFLASH",
		},
	},
}

SWE_LCVP = US_LCVP:New{
	objectName		= "<SIDE>/SWELCVP.s3o",
	corpse			= "uslcvp_dead",
	script			= "uslcvp.cob",
	customparams = {
		soundcategory		= "SWE/Boat",
		normaltex			= "",
	}
}

return lowerkeys({
	["USLCVP"] = US_LCVP,
	["SWELCVP"] = SWE_LCVP,
})
