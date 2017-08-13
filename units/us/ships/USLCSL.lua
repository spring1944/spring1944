local US_LCSL = ArmedBoat:New{
	name					= "LCS(L) Mk. 3",
	description				= "Landing Craft Support (Large)",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 7650,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	maxDamage				= 25400,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_LandingCraft",
	transportCapacity		= 7, -- 7 x 1fpu turrets
	turnRate				= 70,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED TURRET",
		},
	},
	customparams = {
		children = {
			"USSC_Turret_76mm",
			"USLCSL_Turret_TwinBofors_Front",
			"USSC_Turret_20mm_Left",
			"USSC_Turret_20mm_Right",
			"USSC_Turret_20mm_Left",
			"USSC_Turret_20mm_Right",
			"USLCSL_Turret_TwinBofors_Rear",
		},
		deathanim = {
			["z"] = {angle = 15, speed = 3},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}


local US_LCSL_Turret_TwinBofors_Front = OpenBoatTurret:New{
	name					= "40mm Twin Bofors Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/USLCSL_Turret_TwinBofors.s3o",
  	weapons = {	
		[1] = {
			name				= "bofors40mmaa",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
			badTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "bofors40mmaa",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
			badTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			onlyTargetCategory	= "AIR",
			slaveTo				= 1,
		},
		[3] = {
			name				= "bofors40mmhe",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[4] = {
			name				= "bofors40mmhe",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			slaveTo				= 3,
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from RUSBMO 37mm

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 30,
		aaweapon				= 1,

    },
}

local US_LCSL_Turret_TwinBofors_Rear = US_LCSL_Turret_TwinBofors_Front:New{
	weapons = {	
		[1] = {
			mainDir				= [[0 0 -1]],
		},
		[2] = {
			mainDir				= [[0 0 -1]],
		},
		[3] = {
			mainDir				= [[0 0 -1]],
		},
		[4] = {
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		facing 					= 2,

	},
}

local US_SC_Turret_76mm = OpenBoatTurret:New{
	name					= "3in Mk 50 Turret",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			maxAngleDif			= 270,
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,

    },
}


return lowerkeys({
	["USLCSL"] = US_LCSL,
	["USLCSL_Turret_TwinBofors_Front"] = US_LCSL_Turret_TwinBofors_Front,
	["USLCSL_Turret_TwinBofors_Rear"] = US_LCSL_Turret_TwinBofors_Rear,
})
