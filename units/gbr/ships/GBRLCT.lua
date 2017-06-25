local GBR_LCT = TankLandingCraft:New{
	name					= "LCT Mk. 4",
	acceleration			= 0.001,
	brakeRate				= 0.001,
	buildCostMetal			= 2100,
	category 				= "LARGESHIP SHIP MINETRIGGER",
	collisionVolumeOffsets	= [[0.0 0.0 0.0]],
	collisionVolumeScales	= [[60.0 100.0 220.0]],
	maxDamage				= 35000,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 2,
	transportMass			= 27000,
	turnRate				= 35,
	weapons = {
		[1] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 240,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 240,
			mainDir				= [[-1 0 0]],
		},
		[3] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 240,
			mainDir				= [[1 0 0]],
		},
		[4] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 240,
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
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:XSMALL_MUZZLEFLASH",
			[9] = "custom:XSMALL_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["GBRLCT"] = GBR_LCT,
})
