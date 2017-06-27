local GBR_FairmileD = ArmedBoat:New{
	name					= "Fairmile D",
	description				= "Motor Gun/Torpedo Boat",
	acceleration			= 0.025,
	brakeRate				= 0.01,
	buildCostMetal			= 4000,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	maxDamage				= 10400,
	maxReverseVelocity		= 1.99,
	maxVelocity				= 3.98,
	transportCapacity		= 7, -- 7 x 1fpu turrets
	turnRate				= 240,	
	weapons = {	
		[1] = {
			name				= "QF6Pdr57MkIIAHE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED TURRET",
		},
	},

	customparams = {
		soundcategory		= "GBR/Boat",
		children = {
			"GBRFairmileD_Turret_6pdr_Front",
			"GBRFairmileD_Turret_Vickers50",
			"GBRFairmileD_Turret_Vickers50",
			"GBRFairmileD_Turret_Vickers30_Left",
			"GBRFairmileD_Turret_Vickers30_Right",
			"GBRFairmileD_Turret_20mm",
			"GBRFairmileD_Turret_6pdr_Rear",
		},

		piecehitvols = {
			tower = {
				offset = { 0, 0, 0 },
				scale = { 0.6, 1, 1 }
			}
		},

		deathanim = {
			["x"] = {angle = -20, speed = 5},
			["z"] = {angle = -15, speed = 5}, 
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}


local GBR_FairmileD_Turret_Vickers50 = OpenBoatTurret:New{
	name					= "Vickers 50cal Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "twin05calVickers", -- needs a single version
			maxAngleDif			= 270,
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

	},
}

local GBR_FairmileD_Turret_6pdr_Front = OpenBoatTurret:New{
	name					= "6Pdr Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/GBRFairmileD_Turret_6pdr.s3o",
  	weapons = {	
		[1] = {
			name				= "QF6Pdr57MkIIAHE",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 30,
		elevationspeed			= 20,

    },
}
local GBR_FairmileD_Turret_6pdr_Rear = GBR_FairmileD_Turret_6pdr_Front:New{
  	weapons = {	
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing				= 2,

    },
}

local GBR_FairmileD_Turret_Vickers30_Left = OpenBoatTurret:New{
	name					= "Vickers 30cal Turret",
	description				= "Machinegun Turret",
	objectName				= "<SIDE>/GBRFairmileD_Turret_Vickers30.s3o",
	weapons = {	
		[1] = {
			name				= "vickers",
			maxAngleDif			= 90,
			mainDir				= [[1 0 0]],
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		facing					= 3,

	},
}
local GBR_FairmileD_Turret_Vickers30_Right = GBR_FairmileD_Turret_Vickers30_Left:New{
	weapons = {	
		[1] = {
			mainDir				= [[-1 0 0]],
		},
	},
	customparams = {
		facing					= 1,

	},
}

local GBR_FairmileD_Turret_20mm = OpenBoatTurret:New{
	name					= "Twin Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 300,
		},
		[2] = {
			name				= "Oerlikon20mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 300,
			slaveTo				= 1,
		},
		[3] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 300,
		},
		[4] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 300,
			slaveTo				= 3,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,

	},
}

return lowerkeys({
	["GBRFairmileD"] = GBR_FairmileD,
	["GBRFairmileD_Turret_Vickers50"] = GBR_FairmileD_Turret_Vickers50,
	["GBRFairmileD_Turret_Vickers30_Left"] = GBR_FairmileD_Turret_Vickers30_Left,
	["GBRFairmileD_Turret_Vickers30_Right"] = GBR_FairmileD_Turret_Vickers30_Right,
	["GBRFairmileD_Turret_6pdr_Front"] = GBR_FairmileD_Turret_6pdr_Front,
	["GBRFairmileD_Turret_6pdr_Rear"] = GBR_FairmileD_Turret_6pdr_Rear,
	["GBRFairmileD_Turret_20mm"] = GBR_FairmileD_Turret_20mm,
})
