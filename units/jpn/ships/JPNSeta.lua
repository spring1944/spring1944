local JPN_Seta = ArmedBoat:New{
	name					= "Seta-class Gunboat",
	description				= "Large river gunboat",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 9000,
	collisionVolumeOffsets	= [[0.0 -8.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	maxDamage				= 30800,
	maxReverseVelocity		= 0.7,
	maxVelocity				= 1.6,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Type376mmL40HE",
		},
	},
	customparams = {
		children = {
			"JPN_Seta_turret_76mm_front",
			"JPN_Seta_turret_25mm",
			"JPN_Seta_turret_25mm",
			"JPN_Seta_turret_76mm_rear",
		},
		--[[deathanim = {
			["z"] = {angle = -10, speed = 45},
		},]]
	},
}

local JPN_Seta_Turret_76mm_Front = PartiallyEnclosedBoatTurret:New{
	name					= "Seta 76mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/JPNSeta_turret_76mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Type376mmL40HE",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 16,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,
    },
}

local JPN_Seta_Turret_76mm_Rear = JPN_Seta_Turret_76mm_Front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing = 2,
	},
}

local JPN_Seta_Turret_25mm = OpenBoatTurret:New{
	name					= "Seta 25mm Turret",
	description				= "AA Turret",
  	weapons = {	
		[1] = {
			name				= "Type9625mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "Type9625mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
			slaveTo				= 1,
		},
		[3] = {
			name				= "Type9625mmHE",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
		[4] = {
			name				= "Type9625mmHE",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
			slaveTo				= 3,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 60,
		elevationspeed			= 60,
		aaweapon				= 1,
    },
}


return lowerkeys({
	["JPNSeta"] = JPN_Seta,
	["JPNSeta_Turret_76mm_Front"] = JPN_Seta_Turret_76mm_Front,
	["JPNSeta_Turret_76mm_Rear"] = JPN_Seta_Turret_76mm_Rear,
	["JPNSeta_Turret_25mm"] = JPN_Seta_Turret_25mm,
})
