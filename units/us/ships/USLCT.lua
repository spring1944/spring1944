local US_LCT = TankLandingCraftComposite:New{
	name					= "LCT Mk. 5",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 1600,
	collisionVolumeOffsets	= [[0.0 -30.0 0.0]],
	collisionVolumeScales	= [[60.0 50.0 220.0]],
	maxDamage				= 29100,
	maxReverseVelocity		= 0.35,
	maxVelocity				= 2,
	transportMass			= 15000,
	turnRate				= 40,	
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
		},
	},
	customparams = {
		children = {
			"us_lct_turret_20mm_left",
			"us_lct_turret_20mm_right",
		},
		customanims = "gbr_lct",
		deathanim = {
			["x"] = {angle = -5, speed = 5},
		},
	},
}

local US_LCT_Turret_20mm_Left = OpenBoatTurret:New{
	name					= "Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "<SIDE>/us_lct_turret_20mm.s3o",
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
local US_LCT_Turret_20mm_Right = US_LCT_Turret_20mm_Left:New{
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

return lowerkeys({
	["USLCT"] = US_LCT,
	["us_lct_turret_20mm_left"] = US_LCT_Turret_20mm_Left,
	["us_lct_turret_20mm_right"] = US_LCT_Turret_20mm_Right,
})
