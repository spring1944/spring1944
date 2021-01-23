local ITA_MS = ArmedBoat:New{
	name					= "MS type CRDA 60 t.",
	description				= "Large Torpedo boat",
	movementClass			= "BOAT_RiverMedium",
	acceleration			= 0.3,
	brakeRate				= 0.3,
	buildCostMetal			= 1500,
	collisionVolumeOffsets	= [[0.0 -16.0 -15.0]],
	collisionVolumeScales	= [[40.0 20.0 260.0]],
	maxDamage				= 6600,
	maxVelocity				= 4.2,
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 55,	
	weapons = {	
		[1] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory		= "ITA/Boat",
		children = {
			"ITAMS_Turret_20mm_Front", 
			"ITAMS_Turret_20mm_Rear", 
		},
		deathanim = {
			["z"] = {angle = 20, speed = 20},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

		normaltex			= "unittextures/ITAMS_normals.png",
	},
}

local ITA_MS_Turret_20mm_Front = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/ITAMS_Turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		aaweapon				= 1,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,

		normaltex			= "unittextures/ITAMS_normals.png",
    },
}

local ITA_MS_Turret_20mm_Rear = ITA_MS_Turret_20mm_Front:New{
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
	["ITAMS"] = ITA_MS,
	["ITAMS_Turret_20mm_Front"] = ITA_MS_Turret_20mm_Front,
	["ITAMS_Turret_20mm_Rear"] = ITA_MS_Turret_20mm_Rear,
})
