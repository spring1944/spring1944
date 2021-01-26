local JPN_TypeNo1AuxSC = ArmedBoat:New{
	name					= "Type No.1 Class Auxiliary Subchaser",
	description				= "Patrol boat",
	movementClass			= "BOAT_RiverSmall",
	acceleration			= 0.3,
	brakeRate				= 0.3,
	buildCostMetal			= 1500,
	collisionVolumeOffsets	= [[0.0 -8.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	maxDamage				= 13000,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 1.32,
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 55,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Type9625mmHE",
		},
	},
	customparams = {
		children = {
			"JPNSC_turret_25mm_front",
			"JPNSC_turret_25mm_rear",
		},
		deathanim = {
			["z"] = {angle = 45, speed = 60},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
		normaltex			= "unittextures/JPNTypeNo1AuxSC_normals.png",
	},
}

local JPN_SC_Turret_25mm_Front = OpenBoatTurret:New{
	name					= "SC 25mm Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/JPNTypeNo1AuxSC_turret_25mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Type9625mmAA",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "Type9625mmHE",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 60,
		elevationspeed			= 60,
		aaweapon				= 1,
		normaltex			= "unittextures/JPNTypeNo1AuxSC_normals.png",
    },
}

local JPN_SC_Turret_25mm_Rear = JPN_SC_Turret_25mm_Front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
		defaultheading1		= math.rad(180),
	},
}


return lowerkeys({
	["JPNTypeNo1AuxSC"] = JPN_TypeNo1AuxSC,
	["JPNSC_Turret_25mm_Front"] = JPN_SC_Turret_25mm_Front,
	["JPNSC_Turret_25mm_Rear"] = JPN_SC_Turret_25mm_Rear,
})
