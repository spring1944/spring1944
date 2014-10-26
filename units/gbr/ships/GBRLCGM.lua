local GBR_LCGM = BoatMother:New{
	name					= "LCG(M)",
	description				= "Landing Craft Gun (Medium)",
	acceleration			= 0.001,
	brakeRate				= 0.001,
	buildCostMetal			= 10500,
	buildTime				= 10500,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	corpse					= "GBRLCGM_dead",
	mass					= 30800,
	maxDamage				= 30800,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 1.1,
	movementClass			= "BOAT_LightPatrol",
	objectName				= "GBRLCGM.s3o",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 32,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "qf25pdrhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory		= "GBR/Boat",
		children = {
			"GBR_LCGM_Turret_25pdr_Left",
			"GBR_LCGM_Turret_25pdr_Right",
			"GBR_LCSL_Turret_20mm_Left",
			"GBR_LCSL_Turret_20mm_Right",
		},
		deathanim = {
			["z"] = {angle = 15, speed = 2.5},
		},
	},
}

local GBR_LCGM_Turret_25pdr_Left = BoatChild:New{
	name					= "25Pdr Turret",
	description				= "Primary Turret",
	objectName				= "GBRLCGM_Turret_25pdr.s3o",
  	weapons = {	
		[1] = {
			name				= "qf25pdrhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH SHIP LARGESHIP DEPLOYED",
			mainDir				= [[1 0 1]],
		},
	},
	customparams = {
		maxammo					= 26,
		weaponcost				= 18,
		weaponswithammo			= 1,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 17,
		elevationspeed			= 17,
		feartarget				= false, -- fully enclosed
    },
}
local GBR_LCGM_Turret_25pdr_Right = GBR_LCGM_Turret_25pdr_Left:New{
  	weapons = {	
		[1] = {
			mainDir				= [[-1 0 1]],
		},
	},
}


return lowerkeys({
	["GBRLCGM"] = GBR_LCGM,
	["GBR_LCGM_Turret_25pdr_Left"] = GBR_LCGM_Turret_25pdr_Left,
	["GBR_LCGM_Turret_25pdr_Right"] = GBR_LCGM_Turret_25pdr_Right,
})
