local GER_SBoot = ArmedBoat:New{
	name					= "SchnellBoot",
	description				= "Motor Torpedo Boat",
	acceleration			= 0.3,
	brakeRate				= 0.15,
	buildCostMetal			= 2200,
	collisionVolumeOffsets	= [[0.0 -16.0 -15.0]],
	collisionVolumeScales	= [[40.0 20.0 260.0]],
	maxDamage				= 9070,
	maxReverseVelocity		= 3.005,
	maxVelocity				= 4,68, -- 39kn
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 65,	
	weapons = {
		[1] = {
			name				= "flak3820mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory = "GER/Boat",
		children = {
			"GER_SBoot_Turret_20mm_Front",
			"GER_SBoot_Turret_20mm_Rear",
		},
		deathanim = {
			["z"] = {angle = 45, speed = 15},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}

local GER_SBoot_Turret_20mm_Front = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "GER/GERSBoot_Turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 300,
		},
		[2] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 300,
		},
	},
	customparams = {
		maxammo					= 10,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 80,
		aaweapon				= 1,

    },
}

local GER_SBoot_Turret_20mm_Rear = GER_SBoot_Turret_20mm_Front:New{
  	weapons = {	
		[1] = {
			maxAngleDif			= 300,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 300,
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,
		defaultheading1			= math.rad(180),
    },
}
return lowerkeys({
	["GERSBoot"] = GER_SBoot,
	["GER_SBoot_Turret_20mm_Front"] = GER_SBoot_Turret_20mm_Front,
	["GER_SBoot_Turret_20mm_Rear"] = GER_SBoot_Turret_20mm_Rear,
})
