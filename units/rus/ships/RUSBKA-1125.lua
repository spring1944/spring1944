local RUS_BKA_1125 = ArmedBoat:New{
	name					= "Pr.1125 Armored Boat",
	description				= "Armoured river gunboat",
	movementClass			= "BOAT_RiverSmall",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 2815,
	collisionVolumeOffsets	= [[0.0 -6.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	mass					= 2930,
	maxDamage				= 2930, 
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.8,
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 55,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "F3476mmHE",
		},
	},
	customparams = {
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		damageGroup			= 'hardships',
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
		normaltex			= "unittextures/rusbka1125_normals.png",
	},
}

local RUS_BKA_1125_Turret_76mm = EnclosedBoatTurret:New{
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
		normaltex			= "unittextures/rusbka1125_normals.png",
    },
}

local RUS_BKA_1125_Turret_DshK = EnclosedBoatTurret:New{
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
		normaltex			= "unittextures/rusbka1125_normals.png",
	},
}

local RUS_BKA_1125_Turret_DshK_Front = RUS_BKA_1125_Turret_DshK:New{
	weapons = {
		[1] = {
			maxAngleDif			= 270,
			mainDir		= [[0 0 1]],
		},
	},
	customParams = {
	},
}

local RUS_BKA_1125_Turret_DshK_Top = RUS_BKA_1125_Turret_DshK:New{
	weapons = {
		[1] = {
			maxAngleDif			= 358,
			mainDir		= [[0 0 1]],
		},
	},
	customParams = {
	},
}

local RUS_BKA_1125_Turret_DshK_Rear = RUS_BKA_1125_Turret_DshK:New{
	weapons = {
		[1] = {
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
		defaultheading1		= math.rad(180),
	},
}

return lowerkeys({
	["RUSBKA1125"] = RUS_BKA_1125,
	["RUSBKA1125_Turret_76mm"] = RUS_BKA_1125_Turret_76mm,
	["RUSBKA1125_Turret_DshK_Front"] = RUS_BKA_1125_Turret_DshK_Front,
	["RUSBKA1125_Turret_DshK_Top"] = RUS_BKA_1125_Turret_DshK_Top,
	["RUSBKA1125_Turret_DshK_Rear"] = RUS_BKA_1125_Turret_DshK_Rear,
})
