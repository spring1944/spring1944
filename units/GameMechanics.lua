local BinocSpot = Null:New{
	airsightdistance			= 1000,
	sightDistance				= 200,
	yardmap						= "y",
	customParams = {

	},
}

local Flag = Null:New{
	name				= "Flag",
	description			= "Command Flag",
	activateWhenBuilt	= true,
	extractsMetal		= 0.000292,
	hideDamage			= true,
	iconType			= "flag",
	levelGround			= false,
	maxVelocity			= 0,
	objectName			= "GEN/flag.S3O",
	script				= "Flag.lua", -- atm defaults to .cob
	sightDistance		= 0,
	windGenerator		= 0.00001, -- needed for WindChanged callin
	yardmap				= "y",
	customParams = {
		dontCount			= 1,
		flag				= true,

	},
}

local Buoy = Flag:New{ -- One day...
	name				= "Buoy",
	description			= "Naval Spawn Point",
	floater				= true,
	objectName			= "Gen/buoy.S3O",
	canMove 			= false, -- for some reason cannot be true or it won't float?
	customParams = {

	},
}

local SmallTankShelter = TankShelter:New{
	name				= "Tank Shelter (Small)",
	transportMass		= 2100,
	customParams = {

	},
}

local GMToolBox = Fighter:New{ -- TODO: I am a disgusting hack
	name				= "Game Master Toolbox",
	description			= "Allows the game master to do game-mastery things",
	objectName			= "GEN/GMToolbox.S3O",
	maxDamage			= 3.465e+06,
	category			= "FLAG",

	cruiseAlt			= 300,
	airHoverFactor		= 0,
	hoverAttack			= true,

	cloakCost			= 0,
	cloakCostMoving		= 0,
	maxVelocity			= 20,
	minCloakDistance	= 1,

	energyMake			= 1e+06,
	energyStorage		= 1e+10,
	metalMake			= 1e+07,
	metalStorage		= 1e+11,

	builder				= true,
	workertime			= 1000,

	customParams = {
		gm					= 1,

	},
}

return lowerkeys({
	["BinocSpot"] = BinocSpot,
	["Flag"] = Flag,
	["Buoy"] = Buoy,
	["SmallTankShelter"] = SmallTankShelter,
	["GMToolBox"] = GMToolBox,
})
