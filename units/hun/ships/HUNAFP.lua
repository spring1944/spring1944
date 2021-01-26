local HUN_AFP = ArmedBoat:New{
	name					= "Artilleriefahrprahm",
	description				= "Landing Fire Support Ship",
	corpse					= "HUNAFP_dead",
	movementClass			= "BOAT_RiverLarge",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 7200,
	collisionVolumeOffsets	= [[0.0 -24.0 80.0]],
	collisionVolumeScales	= [[60.0 20.0 230.0]],
	iconType				= "artyboat",
	maxDamage				= 24480,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 1.6,
	transportCapacity		= 7,
	turnRate				= 50,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "sk88mmc30",
		},
	},
	customparams = {
		children = {
			"HUNAFP_Turret_88mm_front", 
			"HUNAFP_Turret_88mm_rear", 
			"HUNAFP_Turret_37mm",
			"HUNAFP_turret_flak_front",
			"HUNAFP_turret_flak_rear",
			"HUNAFP_turret_20mm_left",
			"HUNAFP_turret_20mm_right",
		},
		deathanim = {
			["z"] = {angle = -10, speed = 5},
		},
		normaltex			= "unittextures/HUNAFP_normals.png",
	},
}

local HUNAFP_Turret_88mm_front = PartiallyEnclosedBoatTurret:New{ --
	name					= "88mm Turret", -- TODO: should be for MAL 2?
	description				= "Primary Turret",
	objectName				= "<SIDE>/HUNAFP_turret_88mm.s3o",
  	weapons = {	
		[1] = {
			name				= "sk88mmc30",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 5,
		turretturnspeed			= 12,
		elevationspeed			= 15,
		normaltex			= "unittextures/HUNAFP_normals.png",
    },
}

local HUNAFP_Turret_88mm_rear = HUNAFP_Turret_88mm_front:New{ --
  	weapons = {	
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing		= 2,
		defaultheading1		= math.rad(180),
    },
}


local HUNAFP_turret_flak_front = OpenBoatTurret:New{
	name					= "Flakvierling 20mm Turret",
	description				= "Quad 20mm AA Turret",
	objectName				= "<SIDE>/HUNAFP_turret_flak.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
		[3] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
		[4] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
		[5] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
		},
		[6] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			slaveTo				= 5,
		},
		[7] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			slaveTo				= 5,
		},
		[8] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			slaveTo				= 5,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon			= 1,
		normaltex			= "unittextures/HUNAFP_normals.png",
    },
}

local HUNAFP_turret_flak_rear = HUNAFP_turret_flak_front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
		[5] = {
			mainDir		= [[0 0 -1]],
		},		
	},
	customparams = {
		facing			= 2,
		defaultheading1		= math.rad(180),
	},
}

local HUNAFP_Turret_37mm = OpenBoatTurret:New{
	name					= "37mm Turret",
	description				= "37mm AA Turret",
  	weapons = {	
		[1] = {
			name				= "flak4337mmaa",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "flak4337mmhe",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 30,
		aaweapon				= 1,
		normaltex			= "unittextures/HUNAFP_normals.png",
    },
}

local HUNAFP_turret_20mm_left = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "<SIDE>/HUNAFP_turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			mainDir		= [[1 0 -1]],
		},
		[2] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir		= [[1 0 -1]],
		},
	},
	customparams = {
		maxammo					= 19,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 30,
		aaweapon				= 1,
		facing					= 2,
		defaultheading1			= math.rad(180),
		normaltex			= "unittextures/HUNAFP_normals.png",
	},
}

local HUNAFP_turret_20mm_right = HUNAFP_turret_20mm_left:New{
	weapons = {
		[1] = {
			mainDir		= [[-1 0 -1]],
		},
		[2] = {
			mainDir		= [[-1 0 -1]],
		},		
	},
	customparams = {

	},
}

return lowerkeys({
	["HUNAFP"] = HUN_AFP,
	["HUNAFP_Turret_88mm_front"] = HUNAFP_Turret_88mm_front,
	["HUNAFP_Turret_88mm_rear"] = HUNAFP_Turret_88mm_rear,
	["HUNAFP_Turret_37mm"] = HUNAFP_Turret_37mm,
	["HUNAFP_turret_flak_front"] = HUNAFP_turret_flak_front,
	["HUNAFP_turret_flak_rear"] = HUNAFP_turret_flak_rear,
	["HUNAFP_turret_20mm_right"] = HUNAFP_turret_20mm_right,
	["HUNAFP_turret_20mm_left"] = HUNAFP_turret_20mm_left,
})
