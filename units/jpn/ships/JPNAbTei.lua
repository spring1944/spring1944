local JPN_AbTei = ArmedBoat:New{
	name					= "Armored Boat Ab-Tei",
	description				= "Armoured river gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 1425,
	collisionVolumeOffsets	= [[0.0 -8.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	maxDamage				= 3000,
	maxReverseVelocity		= 0.8,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 3, -- 3 x 1fpu turrets
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Type9757mmHE",
		},
	},
	customparams = {
	    armor_front	= 6,
		armor_rear	= 6,
		armor_side	= 6,
		armor_top	= 6,
		children = {
			"JPNAbTei_turret_57mm_front",
			"JPNAbTei_turret_MG",
			"JPNAbTei_turret_57mm_rear",
		},
		deathanim = {
			["z"] = {angle = -10, speed = 45},
		},
	},
}

local JPN_AbTei_Turret_57mm_Front = EnclosedBoatTurret:New{
	name					= "Ab-Tei 57mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/JPNAbTei_turret_57mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Type9757mmHE",
			maxAngleDif			= 300,
			mainDir		= [[0 0 1]],
		},
	},
	customparams = {
		maxammo					= 10,

		barrelrecoildist		= 5,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
    },
}

local JPN_AbTei_Turret_57mm_Rear = JPN_AbTei_Turret_57mm_Front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
	},
}

local JPN_AbTei_Turret_MG = EnclosedBoatTurret:New{
	name					= "Ab-Tei MG Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "Type97MG",
		},
		[2] = {
			name				= "Type97MG",
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 20,
		elevationspeed			= 30,
	},
}


return lowerkeys({
	["JPNAbTei"] = JPN_AbTei,
	["JPNAbTei_Turret_57mm_Front"] = JPN_AbTei_Turret_57mm_Front,
	["JPNAbTei_Turret_57mm_Rear"] = JPN_AbTei_Turret_57mm_Rear,
	["JPNAbTei_Turret_MG"] = JPN_AbTei_Turret_MG,
})
