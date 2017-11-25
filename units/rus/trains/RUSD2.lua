local RUSD2Base = MediumTank:New{
	corpse				= "RUSD2_Abandoned",
	name				= "MBV D-2",
	description			= "Self-Propelled Armored Railroad Car",
	buildCostMetal		= 2400,
	maxDamage			= 6000,

	movementClass		= "TANK_Goat",
	trackOffset			= 5,
	trackWidth			= 20,

	collisionVolumeType	= "box",
	collisionVolumeOffsets	= [[0.0 0 -2]],
	collisionVolumeScales	= [[2.5 1.0 6.0]],
	
	-- Transport tags
	transportSize		= 1, -- assumes footprint of BoatChild == 1
	isFirePlatform 		= true,
	transportCapacity	= 2,

	turnRate			= 0,
	
	usePieceCollisionVolumes	= true,
	
	objectName			= "RUS/rusd2_base.s3o",
	
	weapons = {
		[1] = {
			name				= "Maxim",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
		[2] = {
			name				= "Maxim",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
		[3] = {
			name				= "Maxim",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
		[4] = {
			name				= "Maxim",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
	},
	customparams = {
		armor_front			= 16,
		armor_rear			= 16,
		armor_side			= 16,
		armor_top			= 10,

		customanims			= 'd2',
		
		maxvelocitykmh		= 75,
		mother				= true,
		children = {
			[1] = "RUS_D2_Turret",
			[2] = "RUS_D2_Turret_Rear",
		},

		maxvelocitykmh		= 0,
		hasturnbutton		= false,
		defaultheading1 = math.rad(90),
		defaultheading2 = math.rad(-90),
		defaultheading3 = math.rad(-90),
		defaultheading4 = math.rad(90),
	},
}

local RUS_D2_Turret = EnclosedBoatTurret:New{
	name					= "76.2mm mod. 1902/30",
	description				= "Primary Turret",
	category				= "MINETRIGGER TURRET HARDVEH",
	objectName				= "RUS/rusd2_turret.s3o",
  	weapons = {	
		[1] = {
			name				= "ZiS376mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "ZiS376mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "DT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
	},
	customparams = {
		maxammo					= 12,

		barrelrecoildist		= 5,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
    },
}

local RUS_D2_Turret_Rear = RUS_D2_Turret:New{
	weapons = {
		[1] = {
			mainDir				= [[0 16 -1]],
		},
	},
	customparams = {
		facing				= 2,
		defaultheading1		= math.rad(180),
	},
}

return lowerkeys({
	["RUSD2Base"] = RUSD2Base,
	["RUS_D2_Turret"] = RUS_D2_Turret,
	["RUS_D2_Turret_Rear"] = RUS_D2_Turret_Rear,
})
