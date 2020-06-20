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
		wiki_parser                 = "boat",  -- boats.md template
		wiki_subclass_comments      = "",      -- To be override by boat classes
		wiki_comments               = "",      -- To be override by each unit
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
	script				= "BoatMother.lua",
	stealth				= true,
	transportCapacity	= 9,
	transportMass		= 450,
	transportSize		= 1,
	turninplace			= 0,
	turnRate			= 350,
	waterline			= 0.2,
	customParams = {
		compositetransporter	= true,
		wiki_subclass_comments = [[Light infantry transport, meant to unload
a small group of infantry units in a beach. You should never understimate the
power of a small infantry group behind the enemy lines.]],
	},
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
	script				= "BoatMother.lua",
	stealth				= true,
	transportCapacity	= 1,
	transportSize		= 9,
	turnRate			= 200,
	waterline			= 2.5,
	customParams = {
		compositetransporter	= true,
		wiki_subclass_comments = [[Light vehicles transport, meant to transport
a single vehicle trhough the water. Due to its poor armour and velocity, this
unit is usually considered for logistic, but not assault operations.]],
	},
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
		wiki_subclass_comments = [[Large infantry squad transport, meant to
unload a small group of infantry units in a beach. You should never understimate
the power of infantry behind the enemy lines..]],
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
		wiki_subclass_comments = [[Large tanks transport, meant to unload an
armoured task force in the beach.]],
	}
}

-- Composites
local BoatMother = Boat:New{ -- used for combat boats with multiple turrets
	iconType			= "gunboat",
	movementClass		= "BOAT_RiverMedium",
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
		wiki_subclass_comments = [[This is a combat ship. Combat ships are
featured by their turrets. The turrets can be disabled one by one, or depending
on the specific turret, even suppressed by enemy fire. However, the very only
way to destroy a turret is destroying the whole ship. Along this line, a heavy
ship, with all the turrets disabled, is in fact a quite useless unit, and a
great target for the enemy.

This ship can capture buoys, i.e. water flags]],
	}
}

-- Composite version of infantry landing craft
local InfantryLandingCraftComposite = ArmedBoat:New{
	description				= "Infantry Landing Craft",
	iconType				= "landingship",
	movementClass			= "BOAT_LandingCraftSmall",
	transportCapacity		= 20,
	transportMass			= 1000,
	transportSize			= 1,
	customparams = {
		compositetransporter	= true,
		transportsquad			= "<SIDE>_platoon_landing",
		supplyRange				= 350,
		wiki_subclass_comments = [[Large infantry squad transport, meant to
unload a small group of infantry units in a beach. You should never understimate
the power of infantry behind the enemy lines..]],
	},
}

local TankLandingCraftComposite = ArmedBoat:New{
	description				= "Tank Landing Craft",
	iconType				= "transportship",
	movementClass			= "BOAT_LandingCraft",
	transportCapacity		= 30,
	transportSize			= 5,
	customparams = {
		compositetransporter	= true,
		supplyRange				= 600,
		transportsquad			= "<SIDE>_platoon_lct",
		wiki_subclass_comments = [[Large tanks transport, meant to unload an
armoured task force in the beach.]],
	}
}

local BoatChild = Boat:New{ -- a boat turret
	buildCostMetal				= 1500, -- only used for exp
	blocking					= false,
	canMove						= true,
	cantBeTransported			= false,
	canSelfDestruct				= false,
	category					= "SHIP MINETRIGGER TURRET", -- DEPLOYED",
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
	customparams = {
		wiki_subclass_comments = [[Armoured ship turret, which cannot be
suppressed.]],
	}
}

local OpenBoatTurret = BoatChild:New{
	maxDamage			= 800,
	buildCostMetal			= 300,
	customparams = {
		feartarget		= true,
		fearlimit		= 12,
		wiki_subclass_comments = [[Unprotected ship turret, which can be easily
suppresed and destroyed. Keep it away from enemy fire]],
	}
}

-- as durable as a fully enclosed, but still suppressible
local PartiallyEnclosedBoatTurret = OpenBoatTurret:New{
	maxDamage			= 1600,
	buildCostMetal			= 700,
	customparams = {
		wiki_subclass_comments = [[Partially enbclosed ship turret, which enjoys
an armoured frontal protection, but can be easily suppressed or even destroyed
from behind.]],
	}
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
	InfantryLandingCraftComposite = InfantryLandingCraftComposite,
	TankLandingCraftComposite = TankLandingCraftComposite,
}
