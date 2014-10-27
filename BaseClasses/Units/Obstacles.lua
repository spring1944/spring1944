-- Obstacles --
local Mine = Unit:New{
	buildingGroundDecalType	= "MineDirt.dds",
	category				= "MINE",
	kamikaze				= true,
	maxDamage				= 10,
	maxWaterDepth			= 50,
	objectName				= "APMine.S3O", -- never seen
	minCloakDistance		= 1e-07,
	script					= "Mine.cob",
	selfDestructCountdown	= 1,
	sightDistance			= 160,
	stealth					= true,
	useBuildingGroundDecal	= true,
	yardmap					= "y",
	
	customparams = {
		hiddenbuilding		= true,
		dontcount			= true,
		ismine				= true,
	}
}

local MineSign = Mine:New{
	buildCostMetal			= 360,
	buildTime				= 360,
	category				= "FLAG",
	minCloakDistance		= 160,
	objectName				= "MineSign.S3O",
	script					= "null.cob",
	sightDistance			= 1,
	yardmap					= "o",
}

local TankObstacle = Unit:New{
	name					= "Tank Obstacle",
	description				= "Blocks Tracked & Wheeled Vehicles",
	buildCostMetal			= 15,
	buildTime				= 15,
	category				= "BUILDING",
	corpse					= "TankObstacle",
	footprintX				= 2,
	footprintZ				= 2,
	isFeature				= true,
	maxDamage				= 8000,
	maxSlope				= 20,
	maxWaterDepth			= 50,
	objectName				= "TankObstacle.S3O",
	script					= "null.cob",
	yardmap					= "yy yy",

  	customparams = {
		hiddenbuilding		= true,
		dontcount			= true,
		isobstacle			= true,
	},
}

return {
	Mine = Mine,
	MineSign = MineSign,
	TankObstacle = TankObstacle,
}