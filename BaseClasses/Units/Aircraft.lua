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
	script				= "Aircraft.lua",
	sightdistance		= 0,
	stealth				= true,
	turnRate			= 50,
	
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
}

local Fighter = Aircraft:New{
	description			= "Air-Superiority Fighter",
	cruiseAlt			= 1500,
	iconType			= "fighter",
	maxFuel				= 180,
	
	customParams = {
		soundcategory 		= "<SIDE>/Air/Fighter",
	},
	
	-- sfxTypes = { -- TODO: remove once using LUS
		-- explosionGenerators = {
			-- "custom:SMOKEPUFF_GPL_FX",
			-- "custom:MG_MUZZLEFLASH",
			-- "custom:XSMALL_MUZZLEFLASH",
			-- "custom:MG_SHELLCASINGS",
		-- },
	-- },
}

local Interceptor = Fighter:New{
	description			= "Interceptor",
	cruiseAlt			= 1500,
	maxFuel				= 120,
	noChaseCategory		= "FLAG MINE HARDVEH BUILDING",
}

local AttackFighter = Fighter:New{
	description			= "Attack Fighter",
	cruiseAlt			= 900,
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
			mainDir				= [[0 -0.18 1]],
		},
	},
}

local CruiseMissile = Aircraft:New{
	buildCostMetal				= 6000,
	cruiseAlt					= 1500,
	iconType					= "fighter",
	maxAcc						= 0,
	maxAileron					= 0.00465,
	maxBank						= 1,
	maxElevator					= 0.0036,
	maxFuel						= 120,
	maxPitch					= 1,
	maxRudder					= 0.002765,
	maxVelocity					= 18.2,
	
    customParams = {
		cruise_missile_accuracy		= 400,
		enginesound					= "v1-",
		enginesoundnr				= 19,
		enginevolume				= 8,
		deposit						= 0,
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
}

local ParaTransport = Aircraft:New{
	description			= "Paratroop Transport Plane",
	buildCostMetal		= 3000,
	cruiseAlt			= 1800,
	
	footprintX			= 6,
	footprintZ			= 6,
	iconType			= "transportplane",

	maxAcc				= 0.309,
	maxAileron			= 0.003,
	maxBank				= 0.25,
	maxElevator			= 0.0025,
	maxFuel				= 180,
	maxPitch			= 1,
	maxRudder			= 0.002,
	maxVelocity			= 11.2,
	refuelTime			= 10,

	customParams = {
		troopdropper	= 1,
		deposit			= 0,
	},
	weapons = {
		[1] = {
			name			= "<SIDE>_paratrooper",
		},
	}
}

return {
	Aircraft = Aircraft,
	Recon = Recon,
	Fighter = Fighter,
	Interceptor = Interceptor,
	AttackFighter = AttackFighter,
	FighterBomber = FighterBomber,
	CruiseMissile = CruiseMissile,
	Glider = Glider,
	ParaTransport = ParaTransport,
}