local RUS_BKA_1125 = BoatMother:New{
	name					= "Pr.1125 Armored Boat",
	description				= "Armoured river gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 2125,
	buildTime				= 2125,
	collisionVolumeOffsets	= [[0.0 -6.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	corpse					= "RUSBKA-1125_dead",
	mass					= 2660,
	maxDamage				= 3060, --+15% because it has armor
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_RiverSmall",
	objectName				= "RUSBKA1125.s3o",
	soundCategory			= "RUSBoat",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "F3476mmHE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
}

local RUS_BKA_1125_Turret_76mm = BoatChild:New{
	name					= "Pr.1125 76mm Turret",
	description				= "Primary Turret",
	objectName				= "RUSBKA1125_76mm.s3o",
  	weapons = {	
		[1] = {
			name				= "F3476mmHE",
			maxAngleDif			= 300,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			weaponMainDir		= [[0 0 1]],
		},
	},
	customparams = {
		maxammo					= 19,
		weaponcost				= 12,
		weaponswithammo			= 1,
		child					= true,
    },
}

return lowerkeys({
	["RUSBKA-1125"] = RUS_BKA_1125,
	["RUSBKA-1125_Turret_76mm"] = RUS_BKA_1125_Turret_76mm,
})