local RUS_Pr161 = ArmedBoat:New{
	name					= "Pr.161 Armoured Boat",
	description				= "Sea-going armored gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 6500,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	corpse					= "RUSPr161_dead",
	mass					= 16100,
	maxDamage				= 16100, 
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 7, -- 7 x 1fpu turrets
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
			"RUSTurret_45mm_Front",
			"RUSPr161_Turret_85mm_Front",
			"RUSPr161_Turret_DshK",
			"RUSPr161_Turret_DshK",
			"RUSPr161_Turret_85mm_Rear",
			"RUSTurret_45mm_Rear",
			"RUSTurret_37mm_Rear", 
		},
		deathanim = {
			["x"] = {angle = -15, speed = 5},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}


local RUS_Pr161_Turret_DshK = OpenBoatTurret:New{
	name					= "DshK Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "dshk",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 80,
		elevationspeed			= 45,

	},
}

local RUS_Pr161_Turret_85mm_Front = EnclosedBoatTurret:New{
	name					= "85mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/RUSBKA1125_Turret_76mm.s3o", -- temp hack to avoid clipping
  	weapons = {	
		[1] = {
			name				= "S5385mmAP",
			maxAngleDif			= 300,
		},
	},
	customparams = {
		maxammo					= 16,

		barrelrecoildist		= 7.5,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,

    },
}
local RUS_Pr161_Turret_85mm_Rear = RUS_Pr161_Turret_85mm_Front:New{
  	weapons = {	
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,

    },
}

return lowerkeys({
	["RUSPr161"] = RUS_Pr161,
	["RUSPr161_Turret_DshK"] = RUS_Pr161_Turret_DshK,
	["RUSPr161_Turret_85mm_Front"] = RUS_Pr161_Turret_85mm_Front,
	["RUSPr161_Turret_85mm_Rear"] = RUS_Pr161_Turret_85mm_Rear,
})
