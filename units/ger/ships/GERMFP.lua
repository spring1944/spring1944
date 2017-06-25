local GER_MFP = TankLandingCraft:New{
	name					= "Marinefahrprahm",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 3300,
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2,
	transportMass			= 9000,
	turnRate				= 35,	
	weapons = {	
		[1] = {
			name				= "flak4337mmhe",
			maxAngleDif			= 270,
			mainDir1			= [[0 0 1]],
		},
		[2] = {
			name				= "flak4337mmhe",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
		[3] = {
			name				= "flak4337mmaa",
			maxAngleDif			= 270,
			mainDir				= [[0 0 1]],
		},
		[4] = {
			name				= "flak4337mmaa",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
		[5] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[1 0 0]],
		},
		[6] = {
			name 				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[-1 0 0]],
		},
		[7] = {
			name 				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
		[8] = {
			name 				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[1 0 0]],
		},
		[9] = {
			name 				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[-1 0 0]],
		},
		[10] = {
			name 				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
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
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[4] = "custom:SMALL_MUZZLEFLASH",
			[5] = "custom:SMALL_MUZZLEDUST",
			[6] = "custom:XSMALL_MUZZLEFLASH",
			[7] = "custom:XSMALL_MUZZLEDUST",
			[8] = "custom:MG_MUZZLEFLASH",
			[9] = "custom:MEDIUMLARGE_MUZZLEFLASH",
			[10] = "custom:MEDIUMLARGE_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["GERMFP"] = GER_MFP,
})
