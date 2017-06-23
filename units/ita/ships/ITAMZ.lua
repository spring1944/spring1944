local ITA_MZ = TankLandingCraft:New{
	name					= "Motozattera",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 2000, --5500, why so much cheaper than MFP?
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2, -- 1.3 in fbi, all other LCT are 2
	transportMass			= 4600,
	turnRate				= 35,	
	weapons = {	
		[1] = {
			name				= "Ansaldo76mmL40HE",
			mainDir				= [[0 0 -1]],
			MaxAngleDif			= 270,
		},
		[2] = {
			name				= "BredaM3520mmAA",
		},
		[3] = {
			name				= "BredaM3520mmHE",
		},
		[4] = {
			name				= "BredaM3520mmAA",
		},
		[5] = {
			name				= "BredaM3520mmHE",
		},
	},
	customparams = {
		supplyRange				= 350, -- override, smaller radius as armed
    	--maxammo					= 7,
		-- other LCT don't have armour values currently - not sure what impact this will have on their resilience?
		armor_front				= 6,
    	armor_rear				= 16,
    	armor_side				= 16,
    	armor_top				= 6,
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
	["ITAMZ"] = ITA_MZ,
})
