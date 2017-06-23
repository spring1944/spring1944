local GBR_LCGM = ArmedBoat:New{
	name					= "LCG(M)",
	description				= "Landing Craft Gun (Medium)",
	acceleration			= 0.001,
	brakeRate				= 0.001,
	buildCostMetal			= 10500,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	iconType			= "artyboat",
	maxDamage				= 30800,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 1.1,
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 32,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "navalqf25pdrhe",
		},
	},
	customparams = {
		children = {
			"GBRLCGM_Turret_25pdr_Left",
			"GBRLCGM_Turret_25pdr_Right",
			"GBRLCSL_Turret_20mm_Left",
			"GBRLCSL_Turret_20mm_Right",
		},
		deathanim = {
			["z"] = {angle = 15, speed = 2.5},
		},
		normaltex			= "",
	},
}

local GBR_LCGM_Turret_25pdr_Left = EnclosedBoatTurret:New{
	name					= "25Pdr Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/GBRLCGM_Turret_25pdr.s3o",
  	weapons = {	
		[1] = {
			name				= "navalqf25pdrhe",
			maxAngleDif			= 270,
			mainDir				= [[1 0 1]],
		},
	},
	customparams = {
		maxammo					= 26,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 17,
		elevationspeed			= 17,
		normaltex			= "",
	},
}
local GBR_LCGM_Turret_25pdr_Right = GBR_LCGM_Turret_25pdr_Left:New{
  	weapons = {	
		[1] = {
			mainDir				= [[-1 0 1]],
		},
	},
	customparams = {
		normaltex			= "",
	},
}


return lowerkeys({
	["GBRLCGM"] = GBR_LCGM,
	["GBRLCGM_Turret_25pdr_Left"] = GBR_LCGM_Turret_25pdr_Left,
	["GBRLCGM_Turret_25pdr_Right"] = GBR_LCGM_Turret_25pdr_Right,
})
