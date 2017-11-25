local SWE_Vedettbat = ArmedBoat:New{
	name					= "Vedettbat",
	description				= "Sea-going patrol vessel",
	acceleration			= 0.025,
	brakeRate				= 0.01,
	buildCostMetal			= 3035,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 10.0 240.0]],
	maxDamage				= 10400,
	maxReverseVelocity		= 1.79,
	maxVelocity				= 3.59,
	transportCapacity		= 3,
	turnRate				= 70,	
	weapons = {	
		[1] = {
			name				= "SWE_57mmM95",
		},
	},

	customparams = {
		soundcategory		= "SWE/Boat",
		children = {
			"SWEVedettbat_turret_57mm_front",
			"SWEVedettbat_turret_57mm_rear",
			"SWEVedettbat_turret_25mm_rear",
		},

		deathanim = {
			["z"] = {angle = 15, speed = 5}, 
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local SWEVedettbat_turret_57mm_front = OpenBoatTurret:New{
	name					= "57mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/SWEVedettbat_Turret_57mm.s3o",
  	weapons = {	
		[1] = {
			name				= "SWE_57mmM95",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 3,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 30,
		elevationspeed			= 20,

    },
}
local SWEVedettbat_turret_57mm_rear = SWEVedettbat_turret_57mm_front:New{
  	weapons = {	
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing				= 2,
		defaultheading1		= math.rad(180),
    },
}

local SWEVedettbat_turret_25mm_rear = OpenBoatTurret:New{
	name					= "25mm Bofors Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/SWEVedettbat_turret_25mm.s3o",
  	weapons = {	
		[1] = {
			name				= "bofors25mm_aa",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "bofors25mm_he",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
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


return lowerkeys({
	["SWEVedettbat"] = SWE_Vedettbat,
	["SWEVedettbat_turret_57mm_front"] = SWEVedettbat_turret_57mm_front,
	["SWEVedettbat_turret_57mm_rear"] = SWEVedettbat_turret_57mm_rear,
	["SWEVedettbat_turret_25mm_rear"] = SWEVedettbat_turret_25mm_rear,
})
