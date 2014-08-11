local ITA_MS = BoatMother:New{
	name					= "MS type CRDA 60 t.",
	description				= "Large Torpedo boat",
	acceleration			= 0.3,
	brakeRate				= 0.3,
	buildCostMetal			= 1500,
	buildTime				= 1500,
	collisionVolumeOffsets	= [[0.0 -16.0 -15.0]],
	collisionVolumeScales	= [[40.0 20.0 260.0]],
	corpse					= "ITAMS_dead",
	mass					= 50000,
	maxDamage				= 50000,
	maxVelocity				= 3.2,
	movementClass			= "BOAT_LightPatrol",
	objectName				= "ITAMS.s3o",
	soundCategory			= "ITABoat",
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 55,	
	weapons = {	
		[1] = {
			name				= "ita450mmtorpedo",
			onlyTargetCategory	= "LARGESHIP",
			maxAngleDif			= 40,
		},
		[2] = {
			name				= "ita450mmtorpedo",
			onlyTargetCategory	= "LARGESHIP",
			maxAngleDif			= 40,
		},
	},
	customparams = {
		maxammo				= 2,
		weaponcost			= 40,
		weaponswithammo		= 2,
		children = {
			"ITA_MS_Turret_20mm_Front", 
			"ITA_MS_Turret_20mm_Rear", 
		},
		deathanim = {
			["z"] = {angle = 20, speed = 20},
		},
	},
}

local ITA_MS_Turret_20mm_Front = BoatChild:New{
	name					= "20mm Turret",
	description				= "AA Turret",
	objectName				= "ITAMS_Turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "breda3520mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "breda3520mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		aaweapon				= 1,
		weaponcost				= 3,
		weaponswithammo			= 2,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		fearlimit				= 25,
    },
}

local ITA_MS_Turret_20mm_Rear = ITA_MS_Turret_20mm_Front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
	},
}

return lowerkeys({
	["ITAMS"] = ITA_MS,
	["ITA_MS_Turret_20mm_Front"] = ITA_MS_Turret_20mm_Front,
	["ITA_MS_Turret_20mm_Rear"] = ITA_MS_Turret_20mm_Rear,
})
