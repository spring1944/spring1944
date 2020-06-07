local ITALibliM42Base = MediumTank:New{
	corpse				= "ITALibli_m42_Abandoned",
	name				= "Littorino Blindato M42",
	description			= "Self-Propelled Armored Railroad Car, model 1942",
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
	transportCapacity	= 4,

	turnRate			= 0,
	
	usePieceCollisionVolumes	= true,
	
	objectName			= "ITA/ITALibli_Base.s3o",
	
	weapons = {
		[1] = {
			name				= "BredaM38",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
		[2] = {
			name				= "BredaM38",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
		[3] = {
			name				= "BredaM38",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
		[4] = {
			name				= "BredaM38",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
		[5] = {
			name				= "BredaM38",
			mainDir				= [[-1 1 0]],
			maxAngleDif			= 90,
		},
		[6] = {
			name				= "BredaM38",
			mainDir				= [[1 1 0]],
			maxAngleDif			= 90,
		},
	},
	customparams = {
		armour = {
			base = {
				front = {
					thickness		= 13,
				},
				rear = {
					thickness		= 13,
				},
				side = {
					thickness 		= 13,
				},
				top = {
					thickness		= 13,
				},
			},
		},

		customanims			= 'libli',
		
		maxvelocitykmh		= 28,
		mother				= true,
		children = {
			[1] = "ITA_47mm32_Turret_Rear",
			[2] = "ITA_81mmMortar_Turret_Rear",
			[3] = "ITA_81mmMortar_Turret",
			[4] = "ITA_47mm32_Turret",
		},
		normaltex			= "unittextures/ITALibli_m42_normals.dds",
		maxvelocitykmh		= 0,
		hasturnbutton		= false,
		defaultheading1 = math.rad(90),
		defaultheading2 = math.rad(-90),
		defaultheading3 = math.rad(90),
		defaultheading4 = math.rad(-90),
		defaultheading5 = math.rad(90),
		defaultheading6 = math.rad(-90),
		defaultpitch5 = math.rad(-45),
		defaultpitch6 = math.rad(-45),
	},
}

local ITA_47mm32_Turret = EnclosedBoatTurret:New{
	name					= "Cannone da 47/32 M35",
	description				= "Primary Turret",
	category				= "MINETRIGGER TURRET HARDVEH",
	objectName				= "ITA/ITALibli_47mm_Turret.s3o",
  	weapons = {	
		[1] = {
			name				= "CannoneDa47mml40HEAT",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "CannoneDa47mml40AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "CannoneDa47mml40HE",
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

local ITA_47mm32_Turret_Rear = ITA_47mm32_Turret:New{
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

local ITA_81mmMortar_Turret = EnclosedBoatTurret:New{
	name					= "81/14 Mortar",
	description				= "Mortar Turret",
	category				= "MINETRIGGER TURRET HARDVEH",
	objectName				= "ITA/ITALibli_Mortar_Turret.s3o",
	highTrajectory			= 1,	-- since it's a mortar
  	weapons = {	
		[1] = { -- HE
			name				= "M1_81mmMortar",
		},
	},
	customparams = {
		maxammo					= 12,

		barrelrecoildist		= 0,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,
		defaultpitch1			= math.rad(-45),
    },
}

local ITA_81mmMortar_Turret_Rear = ITA_81mmMortar_Turret:New{
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
	["ITALibliM42Base"] = ITALibliM42Base,
	["ITA_47mm32_Turret"] = ITA_47mm32_Turret,
	["ITA_47mm32_Turret_Rear"] = ITA_47mm32_Turret_Rear,
	["ITA_81mmMortar_Turret"] = ITA_81mmMortar_Turret,
	["ITA_81mmMortar_Turret_Rear"] = ITA_81mmMortar_Turret_Rear,
})
