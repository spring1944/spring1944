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
		damageGroup			= 'ships',
		dontCount			= 1,
		hasturnbutton		= 1,
		reversemult			= 0.5,
	}
}

-- Engineer Built
local AssaultBoat = Boat:New{
	name				= "Rubber Dingy", -- will be overwritten by e.g. sturmboot
	description			= "Infantry Water Transport",
	acceleration		= 0.1,
	brakeRate			= 0.2,
	buildCostMetal		= 200,
	category			= "SHIP MINETRIGGER SOFTVEH",
	footprintX			= 3,
	footprintZ			= 3,
	iconType			= "lttrans",--rubber",
	mass				= 145,
	maxDamage			= 145,
	maxVelocity			= 2.66,
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

-- Landing Craft
local InfantryLandingCraft = Boat:New{
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

local TankLandingCraft = Boat:New{
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
local BoatMother = Boat:New{ -- used for combat boats with multiple turrets
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

local ArmedBoat = BoatMother:New{
	customparams = {
		flagCapRate			= 2,
		flagCapType			= 'buoy',
	}
}

local BoatChild = Boat:New{ -- a boat turret
	buildCostMetal				= 1500, -- only used for exp
	blocking					= false,
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

local EnclosedBoatTurret = BoatChild:New{
	maxDamage			= 2500,
	buildCostMetal			= 1000,
}

local OpenBoatTurret = BoatChild:New{
	maxDamage			= 800,
	buildCostMetal			= 300,
	customparams = {
		feartarget		= true,
		fearlimit		= 12,
	}
}

-- as durable as a fully enclosed, but still suppressible
local PartiallyEnclosedBoatTurret = OpenBoatTurret:New{
	maxDamage			= 1600,
	buildCostMetal			= 700,
}

return {
	-- Basic class
	Boat = Boat,
	-- BoatMother and BoatChild deliberately not exported.
	ArmedBoat = ArmedBoat,
	OpenBoatTurret = OpenBoatTurret,
	PartiallyEnclosedBoatTurret = PartiallyEnclosedBoatTurret,
	EnclosedBoatTurret = EnclosedBoatTurret,
	-- Engineer built raft & boat
	PontoonRaft = PontoonRaft,
	AssaultBoat = AssaultBoat,
	-- Landing Craft
	InfantryLandingCraft = InfantryLandingCraft,
	TankLandingCraft = TankLandingCraft,
}
