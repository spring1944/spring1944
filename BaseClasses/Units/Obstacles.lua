-- Obstacles --
local Mine = Unit:New{
	buildingGroundDecalType	= "MineDirt.dds",
	category				= "MINE",
	kamikaze				= true,
	maxDamage				= 10,
	maxWaterDepth			= 50,
	objectName				= "GEN/APMine.S3O", -- never seen
	minCloakDistance		= 3,
	script					= "Mine.cob",
	selfDestructCountdown	= 1,
	sightDistance			= 160,
	stealth					= true,
	useBuildingGroundDecal	= false,
	yardmap					= "y",

	customparams = {
		damageGroup			= "mines",
		hiddenbuilding		= true,
		dontcount			= 1,
		ismine				= true,
	}
}

local MineSign = Mine:New{
	buildCostMetal			= 360,
	buildingGroundDecalType	= "",
	category				= "FLAG",
	minCloakDistance		= 160,
	objectName				= "GEN/MineSign.S3O",
	script					= "null.lua",
	sightDistance			= 1,
	yardmap					= "o",
	useBuildingGroundDecal	= false,
}

local TankObstacle = Unit:New{
	name					= "Tank Obstacle",
	description				= "Blocks Tracked & Wheeled Vehicles",
	buildCostMetal			= 10,
	category				= "BUILDING",
	corpse					= "TankObstacle",
	footprintX				= 2,
	footprintZ				= 2,
	isFeature				= true,
	maxDamage				= 8000,
	maxSlope				= 20,
	maxWaterDepth			= 50,
	objectName				= "GEN/TankObstacle.S3O",
	script					= "null.lua",
	yardmap					= "yy yy",

  	customparams = {
		damageGroup			= "heavyTanks",
		hiddenbuilding		= true,
		dontcount			= 1,
		isobstacle			= true,
	},
}

return {
	Mine = Mine,
	MineSign = MineSign,
	TankObstacle = TankObstacle,
}
