local HUN_Debrecen = ArmedBoat:New{
	name					= "Armored river gunboat",
	description				= "Large patrol ship",
	corpse					= "HUNGunboat_dead",
	acceleration			= 0.05,
	brakeRate				= 0.025,
	buildCostMetal			= 4250,
	collisionVolumeOffsets	= [[0.0 -6.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	mass					= 14400,
	maxDamage				= 15000,
	maxReverseVelocity		= 0.9,
	maxVelocity				= 1.6,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 3,
	turnRate				= 250,	
	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Mavag_75_43MHE",
		},
	},
	customparams = {
		children = {
			"HUNGunboat_turret_75mm_front", 
			"HUNGunboat_turret_75mm_rear", 
			"HUNGunboat_turret_flak_rear", 
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

local HUNGunboat_turret_75mm_front = EnclosedBoatTurret:New{
	name					= "Gunboat 75mm Turret",
	description				= "Primary Turret",
	objectName				= "<SIDE>/HUNGunboat_turret_75mm.s3o",
  	weapons = {	
		[1] = {
			name				= "Mavag_75_43MHE",
		},

	},
	customparams = {
		maxammo					= 6,
		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		normaltex			= "",
    },
}

local HUNGunboat_turret_75mm_rear = HUNGunboat_turret_75mm_front:New{
	weapons = {
		[1] = {
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing				= 2,
		normaltex			= "",
	}
}

local HUNGunboat_turret_flak_rear = OpenBoatTurret:New{
	name					= "Flakvierling 20mm Turret",
	description				= "Quad 20mm AA Turret",
	objectName				= "<SIDE>/HUNGunboat_turret_flak.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
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
			mainDir		= [[0 0 -1]],
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
		facing				= 2,
		normaltex			= "",
    },
}


return lowerkeys({
	["HUNGunboat"] = HUN_Debrecen,
	["HUNGunboat_turret_flak_rear"] = HUNGunboat_turret_flak_rear,
	["HUNGunboat_turret_75mm_front"] = HUNGunboat_turret_75mm_front,
	["HUNGunboat_turret_75mm_rear"] = HUNGunboat_turret_75mm_rear,
})
