local ITA_MZ = Boat:New{
	name					= "Motozattera",
	description				= "Tank Landing Craft",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 2000, --5500, why so much cheaper than MFP?
	buildTime				= 2000, --5500, why so much cheaper than MFP?
	corpse					= "ITAMZ_dead",
	iconType				= "transportship",
	mass					= 29300,
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2, -- 1.3 in fbi, all other LCT are 2
	movementClass			= "BOAT_LandingCraft",
	objectName				= "ITAMZ.s3o",
	transportCapacity		= 14,
	transportMass			= 4600,
	transportSize			= 18,
	turnRate				= 35,	
	weapons = {	
		[1] = {
			name				= "Ansaldo76mmL40HE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir				= [[0 0 -1]],
			MaxAngleDif			= 270,
		},
		[2] = {
			name				= "BredaM3520mmAA",
			onlyTargetCategory	= "AIR",
		},
		[3] = {
			name				= "BredaM3520mmHE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[4] = {
			name				= "BredaM3520mmAA",
			onlyTargetCategory	= "AIR",
		},
		[5] = {
			name				= "BredaM3520mmHE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundCategory			= "ITA/Boat",
		transportsquad			= "ita_platoon_mz",
		supplyRange				= 350,
    	maxammo					= 7,
    	weaponcost				= 18,
    	weaponswithammo			= 1,
		-- other LCT don't have armour values currently - not sure what impact this will have on their resilience?
		armor_front				= 6,
    	armor_rear				= 16,
    	armor_side				= 16,
    	armor_top				= 6,
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
			[8] = "custom:MG_MUZZLEFLASH",
			[9] = "custom:MEDIUMLARGE_MUZZLEFLASH",
			[10] = "custom:MEDIUMLARGE_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["ITAMZ"] = ITA_MZ,
})
