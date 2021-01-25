local RUS_Pr165_PB = ArmedBoat:New{
	name					= "Pr.165 PB Floating Battery",
	description				= "Mobile Fire Support Platrofm",
	movementClass			= "BOAT_RiverSmall",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 4500,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	corpse					= "RUSPr165_dead",
	iconType			= "artyboat",
	mass					= 3300,
	maxDamage				= 3300, 
	maxReverseVelocity		= 0.35,
	maxVelocity				= 0.5,
	transportCapacity		= 3,
	turnRate				= 150,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "S5385mmAP",
		},
	},
	customparams = {
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		damageGroup			= 'hardships',
		children = {
			"RUSPr165_turret_B24",
			"RUSPr165_turret_DshK_Left",
			"RUSPr165_turret_DshK_Right",
		},
		deathanim = {
			["x"] = {angle = 15, speed = 5},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
		normaltex			= "unittextures/RUSPr165PB_normals.png",
	},
}

local RUSPr165_Turret_B24 = PartiallyEnclosedBoatTurret:New{ --
	name					= "B-24 100mm Gun Mount",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "b24_100mmhe",
			maxAngleDif			= 300,
		},
	},
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 5,
		turretturnspeed			= 5,    -- real turn rates: 5 degrees/sec, taken from Wiki
		elevationspeed			= 5,    -- same thing
		normaltex			= "unittextures/RUSPr165PB_normals.png",
    },
}

local RUS_Pr165_Turret_DshK = OpenBoatTurret:New{
	name					= "DshK Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "dshk",
			maxAngleDif			= 260,
		},
	},
	customparams = {
		turretturnspeed			= 80,
		elevationspeed			= 45,
		normaltex			= "unittextures/RUSPr165PB_normals.png",
	},
}

local RUS_Pr165_Turret_DshK_Left = RUS_Pr165_Turret_DshK:New{
    objectName				= "<SIDE>/RUSPr165_turret_DshK.s3o",

	customparams = {
        facing                  = 3,
	defaultheading1		= math.rad(-90),
	},
}

local RUS_Pr165_Turret_DshK_Right = RUS_Pr165_Turret_DshK:New{
    objectName				= "<SIDE>/RUSPr165_turret_DshK.s3o",

	customparams = {
        facing                  = 1,
	defaultheading1		= math.rad(90),
	},
}

RUS_Pr165_Turret_DshK_Left.weapons[1].mainDir		= [[1 0 -1]]
RUS_Pr165_Turret_DshK_Right.weapons[1].mainDir		= [[-1 0 -1]]

return lowerkeys({
	["RUSPr165PB"] = RUS_Pr165_PB,
	["RUSPr165_turret_DshK_Left"] = RUS_Pr165_Turret_DshK_Left,
    ["RUSPr165_turret_DshK_Right"] = RUS_Pr165_Turret_DshK_Right,
	["RUSPr165_turret_B24"] = RUSPr165_Turret_B24,
})
