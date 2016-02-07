Unit('RUS_BKA_1125'):Extends('ArmedBoat'):Attrs{
	name					= "Pr.1125 Armored Boat",
	description				= "Armoured river gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 3200,
	collisionVolumeOffsets	= [[0.0 -6.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	mass					= 2660,
	maxDamage				= 3060, --+15% because it has armor
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "F3476mmHE",
		},
	},
	customparams = {
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		children = {
			"RUSBKA1125_turret_76mm", 
			"RUSBKA1125_Turret_DshK_Front", 
			"RUSBKA1125_Turret_DshK_Top", 
			"RUSBKA1125_Turret_DshK_Rear"
		},
		deathanim = {
			["x"] = {angle = 5, speed = 5},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
	},
}

Unit('RUS_BKA_1125_Turret_76mm'):Extends('EnclosedBoatTurret'):Attrs{
	name					= "Pr.1125 76mm Turret",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "F3476mmHE",
			maxAngleDif			= 300,
			mainDir				= [[0 0 1]],
		},
	},
	customparams = {
		maxammo					= 12,

		barrelrecoildist		= 5,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
    },
}

Unit('RUS_BKA_1125_Turret_DshK'):Extends('EnclosedBoatTurret'):Attrs{
	name					= "Pr.1125 DshK Turret",
	description				= "Heavy Machinegun Turret",
	objectName				= "<SIDE>/RUSBKA1125_Turret_DshK.s3o",
	weapons = {	
		[1] = {
			name				= "dshk",
		},
	},
	customparams = {
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 30,
		elevationspeed			= 45,
	},
}

Unit('RUS_BKA_1125_Turret_DshK_Front'):Extends('RUS_BKA_1125_Turret_DshK'):Attrs{
	weapons = {
		[1] = {
			maxAngleDif			= 270,
			mainDir		= [[0 0 1]],
		},
	},
}

Unit('RUS_BKA_1125_Turret_DshK_Top'):Extends('RUS_BKA_1125_Turret_DshK'):Attrs{
	weapons = {
		[1] = {
			maxAngleDif			= 358,
			mainDir		= [[0 0 1]],
		},
	},
}

Unit('RUS_BKA_1125_Turret_DshK_Rear'):Extends('RUS_BKA_1125_Turret_DshK'):Attrs{
	weapons = {
		[1] = {
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
	},
}

