local GBR_LCSL = ArmedBoat:New{
	name					= "LCS(L) Mk. 2",
	description				= "Landing Craft Support",
	acceleration			= 0.025,
	brakeRate				= 0.01,
	buildCostMetal			= 1900,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	maxDamage				= 8400,
	maxVelocity             = 1.776, -- 14.8 knots, see Fairmile definition for formula
	maxReverseVelocity      = 0.888, -- let it be half, no data
	transportCapacity		= 5, -- 5 x 1fpu turrets
	turnRate				= 40,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "qf6pdr57mmap",
		},
	},
	customparams = {
		children = {
			"GBRLCSL_Turret_4inMortar",
			"GBRLCSL_Turret_6pdr",
			"GBRLCSL_Turret_20mm_Left",
			"GBRLCSL_Turret_20mm_Right",
			"GBRLCSL_Turret_Vickers50",
		},
		deathanim = {
			["z"] = {angle = 30, speed = 15},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local GBR_LCSL_Turret_4inMortar = OpenBoatTurret:New{
	name					= "4in Smoke Mortar",
	description				= "Smoke Launcher",
  	weapons = {	
		[1] = {
			name				= "BL4inMortarSmoke",
			maxAngleDif			= 270,
			onlyTargetCategory	= "NIL", -- commandfire only
		},
	},
	customparams = {
		maxammo					= 4,
		turretturnspeed			= 30,
		elevationspeed			= 20,

	},
}


local GBR_LCSL_Turret_Vickers50 = OpenBoatTurret:New{
	name					= "Vickers 50cal Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "twin05calVickers", -- needs a single version
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
		[2] = {
			name				= "twin05calVickers", -- needs a single version
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		facing 					= 2,

	},
}

local GBR_LCSL_Turret_6pdr = EnclosedBoatTurret:New{
	name					= "6Pdr Turret",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "qf6pdr57mmap",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "qf6pdr57mmhe",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 10,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 21, -- 16.9s for 360
		elevationspeed			= 20,
		aaweapon				= 2, -- TODO: rename to something more generic e.g. masterweapon

    },
}


local GBR_LCSL_Turret_20mm_Left = OpenBoatTurret:New{
	name					= "Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "<SIDE>/GBRLCSL_Turret_20mm.s3o",
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 180,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 150,
			mainDir				= [[1 0 0]],
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
		facing 					= 3,
		defaultheading1			= math.rad(-90),
	},
}
local GBR_LCSL_Turret_20mm_Right = GBR_LCSL_Turret_20mm_Left:New{
	weapons = {	
		[1] = {
			mainDir				= [[-1 0 0]],
		},
		[2] = {
			mainDir				= [[-1 0 0]],
		},
	},
	customparams = {
		facing 					= 1,
		defaultheading1				= math.rad(90),
	},
}


return lowerkeys({
	["GBRLCSL"] = GBR_LCSL,
	["GBRLCSL_Turret_4inMortar"] = GBR_LCSL_Turret_4inMortar,
	["GBRLCSL_Turret_Vickers50"] = GBR_LCSL_Turret_Vickers50,
	["GBRLCSL_Turret_6pdr"] = GBR_LCSL_Turret_6pdr,
	["GBRLCSL_Turret_20mm_Left"] = GBR_LCSL_Turret_20mm_Left,
	["GBRLCSL_Turret_20mm_Right"] = GBR_LCSL_Turret_20mm_Right,
})
