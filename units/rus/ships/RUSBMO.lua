local RUS_BMO = ArmedBoat:New{
	name					= "BMO Class Subchaser",
	description				= "Armoured light patrol ship",
	acceleration			= 0.1,
	brakeRate				= 0.05,
	buildCostMetal			= 1700,
	collisionVolumeOffsets	= [[0.0 -9.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	mass					= 5620,
	maxDamage				= 5880, --+10% because it has armor
	maxReverseVelocity		= 1.1,
	maxVelocity				= 2.2,
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 100,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "M1939_61k37mmaa",
		},
	},
	customparams = {
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		children = {
			"RUSTurret_37mm_Front", 
			"RUSTurret_45mm_Rear", 
			"RUSBMO_Turret_DshKAA", 
			"RUSBMO_Turret_Vickers", 
		},
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local RUS_Turret_37mm_Front = PartiallyEnclosedBoatTurret:New{ -- Used on multiple vessels
	name					= "37mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/RUSBMO_Turret_37mm.s3o",
  	weapons = {	
		[1] = {
			name				= "M1939_61k37mmaa",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "M1939_61k37mmhe",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 90,
		aaweapon				= 1,

    },
}
local RUS_Turret_37mm_Rear = RUS_Turret_37mm_Front:New{
  	weapons = {	
		[1] = {
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,

    },
}

local RUS_BMO_Turret_DshKAA = OpenBoatTurret:New{
	name					= "BMO DshK Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = { -- original BMO used twin_dshk but we can use 2 actual weapons here
			name				= "dshk",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 358,
		},
		[2] = {
			name				= "dshk",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 358,
			slaveTo				= 1,
		},
	},
	customparams = {
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 80,
		elevationspeed			= 45,
		facing					= 2,

	},
}

local RUS_BMO_Turret_Vickers = OpenBoatTurret:New{
	name					= "BMO Vickers .50cal Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "dshk", --"twin05calVickers",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "dshk", --"twin05calVickers",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
	},
	customparams = {
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 60,
		elevationspeed			= 35,
		facing					= 2,

	},
}

local RUS_Turret_45mm_Front = OpenBoatTurret:New{ -- Used on multiple vessels
	name					= "45mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/RUSBMO_Turret_45mm.s3o",
  	weapons = {	
		[1] = {
			name				= "M1937_40k45mmhe",
			maxAngleDif			= 300,
		},
	},
	customparams = {
		maxammo					= 16,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 25,
		elevationspeed			= 30,

    },
}
local RUS_Turret_45mm_Rear = RUS_Turret_45mm_Front:New{
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
	["RUSBMO"] = RUS_BMO,
	["RUSTurret_37mm_Front"] = RUS_Turret_37mm_Front,
	["RUSTurret_37mm_Rear"] = RUS_Turret_37mm_Rear,
	["RUSTurret_45mm_Front"] = RUS_Turret_45mm_Front,
	["RUSTurret_45mm_Rear"] = RUS_Turret_45mm_Rear,
	["RUSBMO_Turret_DshKAA"] = RUS_BMO_Turret_DshKAA,
	["RUSBMO_Turret_Vickers"] = RUS_BMO_Turret_Vickers,
})
