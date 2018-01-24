local RUS_G5 = ArmedBoat:New{
	name					= "G-5 torpedo boat with M-8 rocket launcher",
	description				= "Rocket artillery boat",
	acceleration			= 0.1,
	brakeRate				= 0.05,
	buildCostMetal			= 1700,
	stealth			= true,
	collisionVolumeOffsets	= [[0.0 -9.0 0.0]],
	collisionVolumeScales	= [[24.0 24.0 110.0]],
	maxDamage				= 1500,
	maxReverseVelocity		= 1.1,
	maxVelocity				= 5.3,
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 100,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "m8rocket82mm",
		},
	},
	customparams = {
		killvoicecategory		= "RUS/Boat/RUS_BOAT_KILL",
		killvoicephasecount		= 3,
		children = {
			"RUSG5_Turret_DshK", 
			"RUSG5_Turret_M-8", 
		},
		deathanim = {
			["z"] = {angle = -15, speed = 10},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local RUS_G5_Turret_M_8 = OpenBoatTurret:New{
	name					= "M-8 Turret",
	description				= "Rocket Launcher",
  	weapons = {	
		[1] = {
			name				= "m8rocket82mm",
			maxAngleDif			= 45,
		},
	},
	customparams = {
		defaultmove				= 1,
	    maxammo					= 1,
		turretturnspeed			= 15,
		elevationspeed			= 5,

    },
}

local RUS_G5_Turret_DshK = OpenBoatTurret:New{
	name					= "DshK Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "dshk",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 60,
		elevationspeed			= 35,

	},
}

return lowerkeys({
	["RUSG5"] = RUS_G5,
	["RUSG5_Turret_M-8"] = RUS_G5_Turret_M_8,
	["RUSG5_Turret_DshK"] = RUS_G5_Turret_DshK,
})
