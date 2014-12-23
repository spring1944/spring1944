-- Aircraft ----
local Aircraft = Unit:New{
	airSightDistance	= 4000,
	brakeRate			= 5,
	canFly				= true,
	canMove				= true,
	category			= "AIR",
	explodeAs			= "Vehicle_Explosion_Med",
	footprintX			= 4,
	footprintZ			= 4,
	idleAutoHeal		= 2,
	idleTime			= 1800,
	myGravity			= 0.6,
	noChaseCategory		= "FLAG MINE",
	radardistance		= 1000,
	repairable			= false,
	sightdistance		= 0,
	stealth				= true,
	
	customParams = {
	    feartarget			= true,
		proptexture			= "prop3.tga",
		soundcategory 		= "<SIDE>/Air",
	},
}

local Recon = Aircraft:New{
	description			= "Recon Plane",
	buildCostMetal		= 1000,
	cruiseAlt			= 720,
	iconType			= "recon",

	maxAcc				= 0.343,
	maxAileron			= 0.005,
	maxBank				= 0.1,
	maxElevator			= 0.005,
	maxFuel				= 60,
	maxPitch			= 1,
	maxRudder			= 0.005,
	maxVelocity			= 11.2,
	radardistance		= 1500,
	sightDistance		= 600,
	turnRate			= 50,
}

local Fighter = Aircraft:New{
	iconType			= "fighter",
	customParams = {
		soundcategory 		= "<SIDE>/Air/Fighter",
	},
	
	sfxTypes = { -- TODO: remove once using LUS
		explosionGenerators = {
			"custom:SMOKEPUFF_GPL_FX",
			"custom:MG_MUZZLEFLASH",
			"custom:XSMALL_MUZZLEFLASH",
			"custom:MG_SHELLCASINGS",
		},
	},
}

local Interceptor = Fighter:New{
	description			= "Interceptor",
	cruiseAlt			= 1500,
	maxFuel				= 120,
	noChaseCategory		= "FLAG MINE HARDVEH BUILDING",
}

local FighterBomber = Fighter:New{
	description			= "Fighter-Bomber",
	iconType			= "bomber",
	cruiseAlt			= 750,
	fireState			= 0,
	maxFuel				= 60,
	
	weapons = {
		[1] = {
			name				= "bomb",
			maxAngleDif			= 20,
			onlyTargetCategory	= "BUILDING HARDVEH OPENVEH INFANTRY SHIP LARGESHIP DEPLOYED",
			mainDir				= [[0 -0.18 1]],
		},
	},
}

local Glider = Aircraft:New{
	airSightDistance	= 0,
	buildCostMetal		= 6000,
	corpse				= "<NAME>_Damaged",
	cruiseAlt			= 1500,
	
	customParams = {
		cruise_missile_accuracy	= 1,
		deposit					= 0,
	},
	explodeAs			= "noweapon",
	iconType			= "transportplane",
	maxAcc				= 0,
	maxAileron			= 0.00465,
	maxBank				= 1,
	maxDamage			= 215,
	maxElevator			= 0.0036,
	maxFuel				= 120,
	maxPitch			= 1,
	maxRudder			= 0.002765,
	maxVelocity			= 9.8,
	sightDistance		= 0,
	turnRate			= 50,
}

return {
	Aircraft = Aircraft,
	Recon = Recon,
	Fighter = Fighter,
	Interceptor = Interceptor,
	FighterBomber = FighterBomber,
	Glider = Glider,
}