-- Vehicles ----
AbstractUnit('Deployed'):Extends('Unit'):Attrs{
	activateWhenBuilt			= true,
	airSightDistance			= 2000,
	buildingGroundDecalSizeX	= 5,
	buildingGroundDecalSizeY	= 5,
	buildingGroundDecalType		= "Dirt2.dds",
	category					= "DEPLOYED",
	flankingBonusMax			= 1.25,
	flankingBonusMin			= 0.75,
	flankingBonusMode			= 1,
	footprintX					= 3,
	footprintZ					= 3,
	maxDamage					= 2500,
	maxSlope					= 15,
	maxWaterDepth				= 0,
	radardistance				= 650,
	script						= "Deployed.lua",
	sightDistance				= 650,
	stealth						= true,
	useBuildingGroundDecal		= true,
	
	customParams = {
		damageGroup		= "guns",
		feartarget		= 1,
		soundcategory	= "<SIDE>/Gun",
	},
}

AbstractUnit('DeployedGun'):Extends('Deployed'):Attrs{
	customParams = { -- SandbagMG doesn't use ammo, and can't overwrite with nil (and false doesn't seem to work either)
		maxammo			= 4,
		scriptAnimation	= "gun",
	},
}

AbstractUnit('TankShelter'):Extends('Deployed'):Attrs{
	description					= "Tank fortification",
	buildCostMetal				= 450,
	cloakCost					= 0,
	cloakCostMoving				= 0,
	isFirePlatform				= true,
	maxDamage					= 2500,
	minCloakDistance			= 500,
	objectName					= "GEN/<NAME>.s3o",
	cloakTimeout				= 160,
	releaseHeld					= true,
	script						= "tankshelter.lua",
	transportCapacity			= 1,
	transportSize				= 9, -- mass is used to control size of loadable unit
}

-- Sandbag MG --
AbstractUnit('SandbagMG'):Extends('Deployed'):Attrs{
	description					= "Dug-in Heavy Infantry Fire Support",
	buildCostMetal				= 800, -- only for power calcs
	buildingGroundDecalSizeX	= 4,
	buildingGroundDecalSizeY	= 4,
	buildPic					= "<SIDE>SandbagMG.png",
	corpse						= "SandbagMG_Destroyed",
	footprintX					= 2,
	footprintZ					= 2,
	iconType					= "lightmg",
	maxDamage					= 1600,
	noChaseCategory				= "OPENVEH AIR FLAG SOFTVEH MINE",
	objectName					= "<SIDE>/<SIDE>SandbagMG.S3O",

	customParams = {
		scriptAnimation		= "hmg",
	},
	
	sfxtypes = {
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[7] = "custom:MG_SHELLCASINGS",
			[8] = "custom:MG_MUZZLEFLASH",
		},
	},

    weapons = {
		[1] = { -- MG
			maxAngleDif					= 120, -- overwritten by MG42 & M1919A4
		},
	},
}

-- Guns --
AbstractUnit('AAGun'):Extends('DeployedGun'):Attrs{
	description			= "Deployed Anti-Aircraft Gun",
	buildCostMetal		= 1400,
	iconType			= "aaartillery",
	maxDamage			= 1250,
	customParams = {
		maxammo				= 16,
		scriptAnimation		= "aa",
		turretturnspeed		= 75,
		elevationspeed		= 60,
	},
}

AbstractUnit('ATGun'):Extends('DeployedGun'):Attrs{
	description			= "Deployed Anti-Tank Gun",
	buildCostMetal		= 840,
	iconType			= "atartillery",

	weapons = {
		[1] = { -- AP
			maxAngleDif			= 70,
		},
	},
}

AbstractUnit('LightATGun'):Extends('ATGun'):Attrs{
	buildCostMetal		= 400,
	initCloaked			= true,
	cloakCost			= 0,
	cloakTimeout		= 160,
	minCloakDistance	= 300,
}

AbstractUnit('FGGun'):Extends('DeployedGun'):Attrs{
	description			= "Deployed Field Gun",
	buildCostMetal		= 1300,
	iconType			= "artillery",

	weapons = {
		[1] = { -- HE
			maxAngleDif			= 60,
		},
		[2] = { -- AP
			maxAngleDif			= 60,
		},
	},	
}

AbstractUnit('HGun'):Extends('DeployedGun'):Attrs{
	description			= "Deployed Howitzer",
	buildCostMetal		= 1800,
	iconType			= "artillery",
	customParams = {
		canAreaAttack		= true,
		weapontoggle		= "smoke",
	},
	weapons = {
		[1] = { -- HE
			maxAngleDif			= 35,
		},
		[2] = { -- Smoke
			maxAngleDif			= 35,
		},
	},
}

AbstractUnit('RGun'):Extends('DeployedGun'):Attrs{
	description			= "Deployed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "artillery",
	customParams = {
		scriptAnimation		= "rocket",
	},
	weapons = {
		[1] = {
			maxAngleDif			= 35,
		},
	},
}

