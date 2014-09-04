local JPN_AbTei = BoatMother:New{
	name					= "Armored Boat Ab-Tei",
	description				= "Armoured river gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 1425,
	buildTime				= 1425,
	collisionVolumeOffsets	= [[0.0 -8.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	corpse					= "JPNAbTei_dead",
	mass					= 3000,
	maxDamage				= 3000,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 1.3,
	movementClass			= "BOAT_RiverSmall",
	objectName				= "JPNAbTei.s3o",
	soundCategory			= "JPNBoat",
	transportCapacity		= 3, -- 3 x 1fpu turrets
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Type9757mmHE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    armor_front	= 6,
		armor_rear	= 6,
		armor_side	= 6,
		armor_top	= 6,
		children = {
			"JPN_AbTei_turret_57mm_front",
			"JPN_AbTei_turret_MG",
			"JPN_AbTei_turret_57mm_rear",
		},
		deathanim = {
			["z"] = {angle = -10, speed = 45},
		},
	},
}

local JPN_AbTei_Turret_57mm_Front = BoatChild:New{
	name					= "Ab-Tei 57mm Turret",
	description				= "Primary Turret",
	objectName				= "JPNAbTei_turret_57mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Type9757mmHE",
			maxAngleDif			= 300,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir		= [[0 0 1]],
		},
	},
	customparams = {
		maxammo					= 11,
		weaponcost				= 8,
		weaponswithammo			= 1,
		barrelrecoildist		= 5,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		feartarget				= false, -- fully enclosed
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

local JPN_AbTei_Turret_MG = BoatChild:New{
	name					= "Ab-Tei MG Turret",
	description				= "Heavy Machinegun Turret",
	objectName				= "JPNAbTei_turret_MG.s3o",
	weapons = {	
		[1] = {
			name				= "Type97MG",
			onlyTargetCategory	= "INFANTRY SOFTVEH OPENVEH TURRET",
		},
		[2] = {
			name				= "Type97MG",
			onlyTargetCategory	= "INFANTRY SOFTVEH OPENVEH TURRET",
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 20,
		elevationspeed			= 30,
		feartarget				= false, -- fully enclosed
	},
}


return lowerkeys({
	["JPNAbTei"] = JPN_AbTei,
	["JPN_AbTei_Turret_57mm_Front"] = JPN_AbTei_Turret_57mm_Front,
	["JPN_AbTei_Turret_57mm_Rear"] = JPN_AbTei_Turret_57mm_Rear,
	["JPN_AbTei_Turret_MG"] = JPN_AbTei_Turret_MG,
})