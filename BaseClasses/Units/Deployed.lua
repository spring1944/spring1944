-- Vehicles ----
local Deployed = Unit:New{
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
	maxDamage					= 1500,
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

local DeployedGun = Deployed:New{
	customParams = { -- SandbagMG doesn't use ammo, and can't overwrite with nil (and false doesn't seem to work either)
		maxammo			= 4,
		scriptAnimation	= "gun",
	},
}

local TankShelter = Deployed:New{
	description					= "Tank fortification",
	buildCostMetal				= 450,
	cloakCost					= 0,
	cloakCostMoving				= 0,
	isFirePlatform				= true,
	maxDamage					= 2500,
	minCloakDistance			= 500,
	objectName					= "GEN/<NAME>.s3o",
	cloakTimeout				= 160,
	customParams		= {
		hiddenbuilding		= true,
	},
	releaseHeld					= true,
	script						= "tankshelter.lua",
	transportCapacity			= 1,
	transportSize				= 9, -- mass is used to control size of loadable unit
}

-- Sandbag MG --
local SandbagMG = Deployed:New{
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
	sightDistance				= 900,

	customParams = {
		scriptAnimation		= "hmg",
		turretturnspeed		= 36,
		hiddenbuilding		= true,
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
local AAGun = DeployedGun:New{
	description			= "Deployed Anti-Aircraft Gun",
	airSightDistance			= 2500,
	buildCostMetal		= 1400,
	iconType			= "aaartillery",
	maxDamage			= 1250,
	customParams = {
		maxammo				= 16,
		scriptAnimation		= "aa",
		turretturnspeed		= 60,
		elevationspeed		= 75,
	},
	weapons = {
		[1] = { -- AA
			maxAngleDif			= 360,
			mainDir				= [[0 -1 1]],
		},
	},
}

local ATGun = DeployedGun:New{
	description			= "Deployed Anti-Tank Gun",
	buildCostMetal		= 840,
	iconType			= "atartillery",
	radardistance				= 950,

	customParams		= {
		turretturnspeed		= 24,
		hiddenbuilding		= true,
	},
	
	weapons = {
		[1] = { -- AP
			maxAngleDif			= 70,
		},
	},
}

local LightATGun = ATGun:New{
	buildCostMetal		= 400,
	initCloaked			= true,
	cloakCost			= 0,
	cloakTimeout		= 160,
	minCloakDistance	= 300,

	customParams		= {
		turretturnspeed		= 36,
	},	
}

local FGGun = DeployedGun:New{
	description			= "Deployed Field Gun",
	buildCostMetal		= 1300,
	iconType			= "artillery",

	customParams		= {
		turretturnspeed		= 24,
		hiddenbuilding		= true,
	},

	weapons = {
		[1] = { -- HE
			maxAngleDif			= 60,
		},
		[2] = { -- AP
			maxAngleDif			= 60,
		},
	},	
}

local HGun = DeployedGun:New{
	description			= "Deployed Howitzer",
	buildCostMetal		= 1800,
	iconType			= "artillery",
	customParams = {
		canAreaAttack		= true,
		weapontoggle		= "smoke",
		turretturnspeed		= 12,
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

local RGun = DeployedGun:New{
	description			= "Deployed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "artillery",
	customParams = {
		scriptAnimation		= "rocket",
		turretturnspeed		= 16,
	},
	weapons = {
		[1] = {
			maxAngleDif			= 35,
		},
	},
}

return {
	Deployed = Deployed,
	DeployedGun = DeployedGun,
	TankShelter = TankShelter,
	SandbagMG = SandbagMG,
	-- Trucks
	AAGun = AAGun,
	ATGun = ATGun,
	LightATGun = LightATGun,
	FGGun = FGGun,
	HGun = HGun,
	RGun = RGun,
}
