-- Boats ----
local Boat = Unit:New{ -- used for transports as is
	airSightDistance	= 1500,
	canMove				= true,
	category 			= "SHIP MINETRIGGER",
	collisionVolumeType	= "box",
	corpse				= "<NAME>_dead", -- TODO: grumble
	explodeAs			= "Vehicle_Explosion_Sm",
	floater				= true,
	footprintX			= 4,
	footprintZ 			= 4,
	noChaseCategory		= "FLAG AIR MINE",
	selfDestructAs		= "Vehicle_Explosion_Sm",
	sightDistance		= 840,
	turninplace			= false,
	
	customparams = {
		soundCategory		= "<SIDE>/Boat",
		dontCount			= 1,
		hasturnbutton		= 1,
	}
}

-- Pontoon Raft
local PontoonRaft = Boat:New{
	name				= "Pontoon Raft",
	description			= "Heavy Equipment Transport",
	acceleration		= 0.15,
	brakeRate			= 0.1,
	buildCostMetal		= 200,
	category			= "SHIP MINETRIGGER SOFTVEH",
	iconType			= "raft",
	mass				= 1000,
	maxDamage			= 1000,
	maxVelocity			= 1.28,
	minTransportSize	= 1,
	movementClass		= "BOAT_Medium",
	objectName			= "US/USPontoonRaft.S3O", -- TODO: per side models
	script				= "PontoonRaft.cob",
	stealth				= true,
	transportCapacity	= 1,
	transportSize		= 9,
	turnRate			= 200,
	waterline			= 2.5,
}

local InfantryLandingCraft = Boat:New{
	description				= "Infantry Landing Craft",
	iconType				= "landingship",
	movementClass			= "BOAT_LandingCraftSmall",
	transportCapacity		= 20,
	transportMass			= 1000,
	transportSize			= 1,
	customparams = {
		transportsquad			= "<SIDE>_platoon_landing",
		supplyRange				= 350, --
	},
}

local AssaultBoat = Boat:New{
	name				= "Rubber Dingy", -- will be overwritten by e.g. sturmboot
	description			= "Infantry Water Transport",
	acceleration		= 0.3,
	brakeRate			= 0.2,
	buildCostMetal		= 200,
	category			= "SHIP MINETRIGGER SOFTVEH",
	footprintX			= 3,
	footprintZ			= 3,
	iconType			= "lttrans",--rubber",
	mass				= 145,
	maxDamage			= 145,
	maxVelocity			= 3.55,
	movementClass		= "BOAT_Small",
	objectName			= "GEN/RubberDingy.S3O",
	script				= "RubberDingy.cob",
	stealth				= true,
	transportCapacity	= 9,
	transportMass		= 750,
	transportSize		= 1,
	turninplace			= 0,
	turnRate			= 350,
	waterline			= 0.2,
}

-- Composites
local BoatMother = Boat:New{ -- used for combat boats with multiple turrets
	iconType			= "gunboat",
	script				= "BoatMother.lua",
	usePieceCollisionVolumes	= true,
		
	-- Transport tags
	transportSize		= 1, -- assumes footprint of BoatChild == 1
	isFirePlatform 		= true,

	customparams = {
		mother				= true,
	}
}

local BoatChild = Boat:New{ -- a boat turret
	canMove				= false,
	cantBeTransported	= false,
	canSelfDestruct 	= false,
	category 			= "SHIP MINETRIGGER TURRET DEPLOYED",
	collisionVolumeType	= "", -- default to ellipsoid
	corpse				= nil, -- turrets can't die except with parent, so no corpse
	footprintX			= 1,
	footprintZ 			= 1,
	iconType			= "turret",
	idleAutoHeal		= 1,
	mass				= 10,
	maxDamage			= 1000,
	maxVelocity			= 1,
	movementClass		= "KBOT_Infantry", -- needed!
	power		        = 20,
	script				= "BoatChild.lua",
	
	customparams = {
		child				= true,
		feartarget			= true,
		fearlimit			= 50, -- default to double inf, open mounts should be 25
	}
}


return {
	-- Basic class
	Boat = Boat,
	-- Engineer built raft & boat
	PontoonRaft = PontoonRaft,
	AssaultBoat = AssaultBoat,
	-- Landing Craft
	InfantryLandingCraft = InfantryLandingCraft,
	-- Composites
	BoatMother = BoatMother,
	BoatChild = BoatChild,
}