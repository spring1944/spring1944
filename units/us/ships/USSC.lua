local US_SC = ArmedBoat:New{
	name					= "SC-497 Submarine Chaser",
	description				= "Patrol Gunboat",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 2975,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	maxDamage				= 9800,
	maxReverseVelocity		= 0.7,
	maxVelocity				= 1.56,
	movementClass			= "BOAT_Medium",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 300,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED TURRET",
		},
	},
	customparams = {
		children = {
			"USSC_Turret_76mm",
			"USSC_Turret_20mm_Right",
			"USSC_Turret_20mm_Left",
			"USSC_Turret_20mm_Rear",
		},
		deathanim = {
			["z"] = {angle = 30, speed = 20},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
	},
}


local US_SC_Turret_20mm_Left = OpenBoatTurret:New{
	name					= "Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "<SIDE>/USSC_Turret_20mm.s3o",
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 180,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 150,
			mainDir				= [[1 0 0]],
		},
	},
	customparams = {
		maxammo					= 10,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
		facing 					= 3,
	},
}
local US_SC_Turret_20mm_Right = US_SC_Turret_20mm_Left:New{
	weapons = {	
		[1] = {
			mainDir				= [[-1 0 0]],
		},
		[2] = {
			mainDir				= [[-1 0 0]],
		},
	},
	customparams = {
		facing 					= 1,
	},
}
local US_SC_Turret_20mm_Rear = US_SC_Turret_20mm_Left:New{
	weapons = {	
		[1] = {
			mainDir				= [[0 0 1]],
			maxAngleDif			= 270,
		},
		[2] = {
			mainDir				= [[0 0 1]],
			maxAngleDif			= 270,
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
		maxammo					= 12,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,
    },
}


return lowerkeys({
	["USSC"] = US_SC,
	["USSC_Turret_76mm"] = US_SC_Turret_76mm,
	["USSC_Turret_20mm_Left"] = US_SC_Turret_20mm_Left,
	["USSC_Turret_20mm_Right"] = US_SC_Turret_20mm_Right,
	["USSC_Turret_20mm_Rear"] = US_SC_Turret_20mm_Rear,
})
