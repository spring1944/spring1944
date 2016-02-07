-- Boats ----
AbstractUnit('Boat'):Extends('Unit'):Attrs{ -- used for transports as is
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
		damageGroup			= 'ships',
		dontCount			= 1,
		hasturnbutton		= 1,
		reversemult			= 0.5,
	}
}

-- Engineer Built
AbstractUnit('AssaultBoat'):Extends('Boat'):Attrs{
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
	transportMass		= 450,
	transportSize		= 1,
	turninplace			= 0,
	turnRate			= 350,
	waterline			= 0.2,
}

AbstractUnit('PontoonRaft'):Extends('Boat'):Attrs{
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

-- Landing Craft
AbstractUnit('InfantryLandingCraft'):Extends('Boat'):Attrs{
	description				= "Infantry Landing Craft",
	iconType				= "landingship",
	movementClass			= "BOAT_LandingCraftSmall",
	transportCapacity		= 20,
	transportMass			= 1000,
	transportSize			= 1,
	customparams = {
		transportsquad			= "<SIDE>_platoon_landing",
		supplyRange				= 350,
	},
}

AbstractUnit('TankLandingCraft'):Extends('Boat'):Attrs{
	description				= "Tank Landing Craft",
	iconType				= "transportship",
	movementClass			= "BOAT_LandingCraft",
	transportCapacity		= 30,
	transportSize			= 5,
	customparams = {
		supplyRange				= 600,
		transportsquad			= "<SIDE>_platoon_lct",
	}
}

-- Composites
AbstractUnit('BoatMother'):Extends('Boat'):Attrs{ -- used for combat boats with multiple turrets
	iconType			= "gunboat",
	movementClass		= "BOAT_LightPatrol",
	script				= "BoatMother.lua",
	usePieceCollisionVolumes	= true,

	-- Transport tags
	transportSize		= 1, -- assumes footprint of BoatChild == 1
	isFirePlatform 		= true,

	customparams = {
		mother				= true,
	}
}

AbstractUnit('ArmedBoat'):Extends('BoatMother'):Attrs{
	customparams = {
		flagCapRate			= 2,
		flagCapType			= 'buoy',
	}
}

AbstractUnit('BoatChild'):Extends('Boat'):Attrs{ -- a boat turret
	buildCostMetal				= 1500, -- only used for exp
	canMove						= true,
	cantBeTransported			= false,
	canSelfDestruct				= false,
	category					= "SHIP MINETRIGGER TURRET DEPLOYED",
	corpse						= '',
	footprintX					= 1,
	footprintZ					= 1,
	iconType					= "turret",
	mass						= 10,
	maxDamage					= 1000,
	maxVelocity					= 1,
	movementClass				= "KBOT_Infantry", -- needed!
	power						= 20,
	script						= "BoatChild.lua",

	customparams = {
		child				= true,
		damageGroup			= 'shipturrets',
	}
}

AbstractUnit('EnclosedBoatTurret'):Extends('BoatChild'):Attrs{
	maxDamage			= 1600,
}

AbstractUnit('OpenBoatTurret'):Extends('BoatChild'):Attrs{
	maxDamage			= 800,
	customparams = {
		feartarget		= true,
		fearlimit		= 12,
	}
}

-- as durable as a fully enclosed, but still suppressible
AbstractUnit('PartiallyEnclosedBoatTurret'):Extends('OpenBoatTurret'):Attrs{
	maxDamage			= 1600,
}

