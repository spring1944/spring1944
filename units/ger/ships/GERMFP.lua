local GER_MFP = TankLandingCraftComposite:New{
	name					= "Marinefahrprahm",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 2300,
	collisionVolumeOffsets	= [[0.0 0.0 0.0]],
	collisionVolumeScales	= [[60.0 100.0 220.0]],
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2,
	transportMass			= 9000,
	turnRate				= 35,	
	loadingRadius			= 350,
	unloadSpread			= 10,
	weapons = {	
		[1] = {
			name				= "flak4337mmhe",
		},
	},
	customparams = {
		children = {
			"germfp_turret_37mm",
			"germfp_turret_37mm_rear",
			"germfp_turret_20mm_left",
			"germfp_turret_20mm_right",
			"germfp_turret_20mm_rear",
		},
		deathanim = {
			["x"] = {angle = 10, speed = 3},
		},
		customanims = "ger_mfp",
		normaltex			= "unittextures/GERMFP_normals.png",
	},
}

local germfp_turret_37mm = OpenBoatTurret:New{
	name					= "37mm Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/ger_mfp_turret_37mm.s3o",
	weapons = {	
		[1] = {
			name				= "flak4337mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 270,
			mainDir1			= [[0 0 1]],
		},
		[2] = {
			name				= "flak4337mmhe",
			maxAngleDif			= 270,
			mainDir				= [[0 0 1]],
		},	
	},
	customparams = {
		maxammo					= 10,
		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
		normaltex			= "unittextures/GERMFP_normals.png",
    },
}

local germfp_turret_37mm_rear = germfp_turret_37mm:New{
	weapons = {	
		[1] = {
			mainDir				= [[0 0 -1]],
		},
		[2] = {
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		facing 					= 2,
		defaultheading1				= math.rad(180),
	},
}

local germfp_turret_20mm_left = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "<SIDE>/ger_mfp_turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			mainDir		= [[1 0 0]],
		},
		[2] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			mainDir		= [[1 0 0]],
		},
	},
	customparams = {
		maxammo					= 14,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 80,
		aaweapon				= 1,
		facing					= 3,
		defaultheading1			= math.rad(-90),
		normaltex				= "unittextures/GERMFP_normals.png",
    },
}

local germfp_turret_20mm_right = germfp_turret_20mm_left:New{
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
		defaultheading1				= math.rad(90),
	},
}

local germfp_turret_20mm_rear = germfp_turret_20mm_left:New{
	weapons = {	
		[1] = {
			mainDir				= [[0 0 -1]],
		},
		[2] = {
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		facing 					= 2,
		defaultheading1				= math.rad(180),
	},
}

return lowerkeys({
	["GERMFP"] = GER_MFP,
	["germfp_turret_37mm"] = germfp_turret_37mm,
	["germfp_turret_37mm_rear"] = germfp_turret_37mm_rear,
	["germfp_turret_20mm_left"] = germfp_turret_20mm_left,
	["germfp_turret_20mm_right"] = germfp_turret_20mm_right,
	["germfp_turret_20mm_rear"] = germfp_turret_20mm_rear,
})
