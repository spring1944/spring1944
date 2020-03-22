local SWE_Arholma = ArmedBoat:New{
	name					= "Arholma class",
	description				= "Minesweeper",
	movementClass			= "BOAT_RiverLarge",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 12850,
	category				= "LARGESHIP SHIP MINETRIGGER",
	collisionVolumeOffsets	= [[0.0 -60.0 0.0]],
	collisionVolumeScales	= [[24.0 11.0 150.0]],
	maxDamage				= 39000,
	maxVelocity				= 1.7,
	transportCapacity		= 4,
	turnRate				= 25,	
	weapons = {	
		[1] = {
			name				= "Mod105mm1936HE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED TURRET",
		},
	},
	customparams = {
		soundcategory		= "SWE/Boat",
		children = {
			"SWEArholma_Turret_105mm_front", 
			"SWEArholma_Turret_105mm_rear", 
			"SWEArholma_Turret_40mm_rear", 
			"SWEArholma_Turret_40mm_rear", 
		},
		piecehitvols = {
			superstructure = {
				offset = { 0, 0, 0 },
				scale = { 0.6, 1, 1 }
			},
			base2 = {
				offset = { 0, 0, 0 },
				scale = { 0.6, 1, 1 }
			},
		},
		deathanim = {
			["z"] = {angle = 20, speed = 10},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local SWEArholma_Turret_105mm_front = PartiallyEnclosedBoatTurret:New{
	name					= "105mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/SWEArholma_turret_105mm.s3o",
	weapons = {	
		[1] = {
			name				= "Mod105mm1936HE",
			maxAngleDif			= 270,		},
	},
	customparams = {
		maxammo					= 15,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 25,
		elevationspeed			= 25,

	},
}

local SWEArholma_Turret_105mm_rear = SWEArholma_Turret_105mm_front:New{
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

local SWEArholma_turret_40mm_rear = OpenBoatTurret:New{
	name					= "Bofors Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/SWEArholma_turret_40mm.s3o",
  	weapons = {	
		[1] = {
			name				= "bofors40mmaa",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "bofors40mmhe",
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
	["SWEArholma"] = SWE_Arholma,
	["SWEArholma_Turret_105mm_front"] = SWEArholma_Turret_105mm_front,
	["SWEArholma_Turret_105mm_rear"] = SWEArholma_Turret_105mm_rear,
	["SWEArholma_turret_40mm_rear"] = SWEArholma_turret_40mm_rear,
})
