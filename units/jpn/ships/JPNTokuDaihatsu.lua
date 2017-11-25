local JPN_TokuDaihatsu = TankLandingCraft:New{
	name					= "Toku Daihatsu Landing Craft",
	acceleration			= 0.09,
	brakeRate				= 0.5,
	buildCostMetal			= 1000,
	maxDamage				= 3500,
	maxReverseVelocity		= 0.685,
	maxVelocity				= 1.1,
	transportMass			= 2100,
	  transportSize=9,
	turnRate				= 50,	
	weapons = {	
		[1] = {
			name				= "Type9625mmAA",
			maxAngleDif			= 300,
			mainDir				= [[0 0 -1]],
		},
		[2] = {
			name				= "Type9625mmHE",
			maxAngleDif			= 300,
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		supplyrange				= 350, -- overwrite
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]

	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[4] = "custom:SMALL_MUZZLEFLASH",
			[5] = "custom:SMALL_MUZZLEDUST",
			[6] = "custom:XSMALL_MUZZLEFLASH",
			[7] = "custom:XSMALL_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["JPNTokuDaihatsu"] = JPN_TokuDaihatsu,
})
