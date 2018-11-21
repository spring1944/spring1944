local RUS_LCT = TankLandingCraftComposite:New{
	name					= "LCT Mk. 6",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 1600,
	collisionVolumeOffsets	= [[0.0 -30.0 0.0]],
	collisionVolumeScales	= [[60.0 50.0 220.0]],
	loadingRadius			= 350,
	unloadSpread			= 10,
	maxDamage				= 29100,
	maxReverseVelocity		= 0.35,
	maxVelocity				= 2,
	transportMass			= 15000,
	turnRate				= 170,	
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
		},
	},
	customparams = {
		children = {
			"rus_lct_turret_20mm_left",
			"rus_lct_turret_20mm_right",
		},
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},
		customanims = "gbr_lct",
	},
}

local RUS_LCT_Turret_20mm_Left = OpenBoatTurret:New{
	name					= "Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "<SIDE>/rus_lct_turret_20mm.s3o",
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 180,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 150,
			mainDir				= [[1 0 0]],
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
		facing 					= 3,
		defaultheading1			= math.rad(-90),
	},
}
local RUS_LCT_Turret_20mm_Right = RUS_LCT_Turret_20mm_Left:New{
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

local SWE_LCT = RUS_LCT:New{
	corpse		= "SWELCT_dead",
	customparams	= {
		soundcategory		= "SWE/Boat",
		killvoicephasecount	= 0,
		children = {
			"swe_lct_turret_20mm_left",
			"swe_lct_turret_20mm_right",
		},
	},
}

local SWE_LCT_Turret_20mm_Left = RUS_LCT_Turret_20mm_Left:New{
	objectName				= "<SIDE>/swe_lct_turret_20mm.s3o",
}

local SWE_LCT_Turret_20mm_Right = RUS_LCT_Turret_20mm_Right:New{
	objectName				= "<SIDE>/swe_lct_turret_20mm.s3o",
}

return lowerkeys({
	["RUSLCT"] = RUS_LCT,
	["rus_lct_turret_20mm_left"] = RUS_LCT_Turret_20mm_Left,
	["rus_lct_turret_20mm_right"] = RUS_LCT_Turret_20mm_Right,
	["SWELCT"] = SWE_LCT,
	["swe_lct_turret_20mm_left"] = SWE_LCT_Turret_20mm_Left,
	["swe_lct_turret_20mm_right"] = SWE_LCT_Turret_20mm_Right,
})
