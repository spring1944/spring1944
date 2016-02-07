Unit('JPN_Seta'):Extends('ArmedBoat'):Attrs{
	name					= "Seta-class Gunboat",
	description				= "Large river gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 9000,
	collisionVolumeOffsets	= [[0.0 -8.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	maxDamage				= 30800,
	maxReverseVelocity		= 0.7,
	maxVelocity				= 1.6,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Type376mmL40HE",
		},
	},
	customparams = {
		children = {
			"JPN_Seta_turret_76mm_front",
			"JPN_Seta_turret_25mm",
			"JPN_Seta_turret_25mm",
			"JPN_Seta_turret_76mm_rear",
		},
		piecehitvols = {
			tower = {
				offset = { 0, 0, 10 },
				scale = { 1, 1, 0.65 }
			}
		}
		--[[deathanim = {
			["z"] = {angle = -10, speed = 45},
		},]]
	},
}

Unit('JPN_Seta_Turret_76mm_Front'):Extends('PartiallyEnclosedBoatTurret'):Attrs{
	name					= "Seta 76mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/JPNSeta_turret_76mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Type376mmL40HE",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 16,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,
    },
}

Unit('JPN_Seta_Turret_76mm_Rear'):Extends('JPN_Seta_Turret_76mm_Front'):Attrs{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
	},
}

Unit('JPN_Seta_Turret_25mm'):Extends('OpenBoatTurret'):Attrs{
	name					= "Seta 25mm Turret",
	description				= "AA Turret",
  	weapons = {	
		[1] = {
			name				= "Type9625mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "Type9625mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
			slaveTo				= 1,
		},
		[3] = {
			name				= "Type9625mmHE",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
		[4] = {
			name				= "Type9625mmHE",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
			slaveTo				= 3,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 60,
		elevationspeed			= 60,
		aaweapon				= 1,
    },
}


