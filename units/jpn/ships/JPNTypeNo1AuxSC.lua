local JPN_TypeNo1AuxSC = BoatMother:New{
	name					= "Type No.1 Class Auxiliary Subchaser",
	description				= "Patrol boat",
	acceleration			= 0.3,
	brakeRate				= 0.3,
	buildCostMetal			= 1500,
	buildTime				= 1500,
	collisionVolumeOffsets	= [[0.0 -8.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	corpse					= "JPNTypeNo1AuxSC_dead",
	mass					= 130000,
	maxDamage				= 130000,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 1.1,
	movementClass			= "BOAT_LightPatrol",
	objectName				= "JPNTypeNo1AuxSC.s3o",
	soundCategory			= "JPNBoat",
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 55,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "jpntype96_25mm60_he",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"JPN_SC_turret_25mm_front",
			"JPN_SC_turret_25mm_rear",
		},
		deathanim = {
			["z"] = {angle = 45, speed = 60},
		},
	},
}

local JPN_SC_Turret_25mm_Front = BoatChild:New{
	name					= "SC 25mm Turret",
	description				= "AA Turret",
	objectName				= "JPNTypeNo1AuxSC_turret_25mm.s3o",
  	weapons = {	
		[1] = {
			name				= "jpntype96_25mm60_aa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "jpntype96_25mm60_he",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		weaponcost				= 3,
		weaponswithammo			= 2,
		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 60,
		elevationspeed			= 60,
		aaweapon				= 1,
		fearlimit				= 25,
    },
}

local JPN_SC_Turret_25mm_Rear = JPN_SC_Turret_25mm_Front:New{
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
	["JPNTypeNo1AuxSC"] = JPN_TypeNo1AuxSC,
	["JPN_SC_Turret_25mm_Front"] = JPN_SC_Turret_25mm_Front,
	["JPN_SC_Turret_25mm_Rear"] = JPN_SC_Turret_25mm_Rear,
})