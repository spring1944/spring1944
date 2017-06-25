local HUN_PAM21 = ArmedBoat:New{
	name					= "PAM-21",
	description				= "Armoured river minesweeper",
	corpse					= "HUNPAM21_dead",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 1275,
	collisionVolumeOffsets	= [[0.0 -6.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	mass					= 2800,
	maxDamage				= 3360,
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.6,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 3,
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Solothurn_36MHE",
		},
	},
	customparams = {
		children = {
			"HUNPAM21_turret_20mm", 
			"HUNPAM21_turret_mg_right", 
			"HUNPAM21_turret_mg_left", 
		},
		damageGroup			= 'hardships',
		deathanim = {
			["z"] = {angle = 15, speed = 5},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
		normaltex			= "",
	},
}

local HUN_PM = ArmedBoat:New{
	name					= "PM1",
	description				= "Armoured river patrol boat",
	corpse					= "HUNPM_dead",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 2125,
	collisionVolumeOffsets	= [[0.0 -6.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	mass					= 3800,
	maxDamage				= 4560,
	maxReverseVelocity		= 0.9,
	maxVelocity				= 2.0,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 4,
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Mavag_37_42MHE",
		},
	},
	customparams = {
		children = {
			"HUNPM_turret_40mm_front", 
			"HUNPM_turret_40mm_rear", 
			"HUNPAM21_turret_mg_right", 
			"HUNPAM21_turret_mg_left", 
		},
		damageGroup			= 'hardships',
		deathanim = {
			["z"] = {angle = -30, speed = -15},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",
		normaltex			= "",
	},
}

local HUNPAM21_turret_20mm = EnclosedBoatTurret:New{
	name					= "PAM-21 Solothurn Turret",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "Solothurn_36MHE",
		},
		[2] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
	},
	customparams = {
		maxammo					= 24,
		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		normaltex			= "",
    },
}

local HUNPM_turret_40mm_front = EnclosedBoatTurret:New{
	name					= "PM1 40mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/HUNPM_turret_40mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Mavag_37_42MHE",
		},
		[2] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
		[3] = { -- coax 2
			name				= "gebauer_1934_37m",
		},

	},
	customparams = {
		maxammo					= 18,
		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		normaltex			= "",
    },
}

local HUNPM_turret_40mm_rear = HUNPM_turret_40mm_front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			mainDir		= [[0 0 -1]],
		},

		[3] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing				= 2,
		normaltex			= "",
	}
}

local HUNPAM21_turret_mg = EnclosedBoatTurret:New{
	name					= "PAM-21 Machinegun Turret",
	description				= "Heavy Machinegun Turret",
	objectName				= "<SIDE>/HUNPAM21_turret_mg.s3o",
	weapons = {	
		[1] = {
			name				= "gebauer_1934_37m",
		},
	},
	customparams = {
		barrelrecoildist		= 0,
		turretturnspeed			= 30,
		elevationspeed			= 45,
 		normaltex			= "",
	},
}

local HUNPAM21_turret_mg_left = HUNPAM21_turret_mg:New{
	weapons = {
		[1] = {
			maxAngleDif			= 45,
			mainDir		= [[1 0 1]],
		},
	},
	customParams = {
		normaltex			= "",
	},
}

local HUNPAM21_turret_mg_right = HUNPAM21_turret_mg:New{
	weapons = {
		[1] = {
			maxAngleDif			= 45,
			mainDir		= [[-1 0 1]],
		},
	},
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["HUNPAM21"] = HUN_PAM21,
	["HUNPM"] = HUN_PM,
	["HUNPAM21_turret_20mm"] = HUNPAM21_turret_20mm,
	["HUNPAM21_turret_mg_left"] = HUNPAM21_turret_mg_left,
	["HUNPAM21_turret_mg_right"] = HUNPAM21_turret_mg_right,
	["HUNPM_turret_40mm_front"] = HUNPM_turret_40mm_front,
	["HUNPM_turret_40mm_rear"] = HUNPM_turret_40mm_rear,
})
