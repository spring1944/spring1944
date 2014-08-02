local US_LCSL = BoatMother:New{
	name					= "LCS(L) Mk. 3",
	description				= "Landing Craft Support (Large)",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 9000,
	buildTime				= 9000,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	corpse					= "USLCSL_dead",
	mass					= 25400,
	maxDamage				= 25400,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 1.8,
	movementClass			= "BOAT_LandingCraft",
	objectName				= "USLCSL.s3o",
	soundCategory			= "USBoat",
	transportCapacity		= 7, -- 7 x 1fpu turrets
	turnRate				= 140,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"US_SC_Turret_76mm",
			"US_LCSL_Turret_TwinBofors_Front",
			"US_SC_Turret_20mm_Left",
			"US_SC_Turret_20mm_Right",
			"US_SC_Turret_20mm_Left",
			"US_SC_Turret_20mm_Right",
			"US_LCSL_Turret_TwinBofors_Rear",
		},
		deathanim = {
			["z"] = {angle = 15, speed = 3},
		},
	},
}


local US_LCSL_Turret_TwinBofors_Front = BoatChild:New{
	name					= "40mm Twin Bofors Turret",
	description				= "Primary Turret",
	objectName				= "USLCSL_Turret_TwinBofors.s3o",
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
		weaponcost				= 3,
		weaponswithammo			= 4,
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

local US_SC_Turret_76mm = BoatChild:New{
	name					= "3in Mk 50 Turret",
	description				= "Primary Turret",
	objectName				= "USSC_Turret_76mm.s3o",
  	weapons = {	
		[1] = {
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 26,
		weaponcost				= 8,
		weaponswithammo			= 1,
		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,
    },
}


return lowerkeys({
	["USLCSL"] = US_LCSL,
	["US_LCSL_Turret_TwinBofors_Front"] = US_LCSL_Turret_TwinBofors_Front,
	["US_LCSL_Turret_TwinBofors_Rear"] = US_LCSL_Turret_TwinBofors_Rear,
})