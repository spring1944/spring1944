local GER_T196 = ArmedBoat:New{
	name					= "T196",
	description				= "Training Torpedo Boat",
	movementClass			= "BOAT_RiverLarge",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 15000,
	category				= "LARGESHIP SHIP MINETRIGGER",
	collisionVolumeOffsets	= [[0.0 -12.5 0.0]],
	collisionVolumeScales	= [[24.0 11.0 150.0]],
	maxDamage				= 67000,
	maxVelocity				= 2.8, -- 25kn
	transportCapacity		= 4,
	turnRate				= 35,	
	weapons = {	
		[1] = {
			name				= "sk105_42c06",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED TURRET",
		},
	},
	customparams = {
		soundcategory		= "GER/Boat",
		children = {
			"GERT196_Turret_105", 
			"GERT196_Turret_105_rear", 
			"GERRBoot_Turret_20mm", 
			"GERRBoot_Turret_20mm", 
		},
		deathanim = {
			["z"] = {angle = -45, speed = 10},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local GERT196_Turret_105 = PartiallyEnclosedBoatTurret:New{
	name					= "105mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/GERT196_Turret_105.s3o",
	weapons = {	
		[1] = {
			name				= "sk105_42c06",
			maxAngleDif			= 270,
			},
	},
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 28,
		elevationspeed			= 28,

	},
}

local GERT196_Turret_105_rear = GERT196_Turret_105:New{
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

return lowerkeys({
	["GERT196"] = GER_T196,
	["GERT196_Turret_105"] = GERT196_Turret_105,
	["GERT196_Turret_105_rear"] = GERT196_Turret_105_rear,
})
