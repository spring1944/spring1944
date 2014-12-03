-- Boats ----
local Boat = Unit:New{ -- used for transports as is
	airSightDistance	= 1500,
	canMove				= true,
	category 			= "SHIP MINETRIGGER",
	collisionVolumeType	= "box",
	explodeAs			= "Vehicle_Explosion_Sm",
	floater				= true,
	footprintX			= 4,
	footprintZ 			= 4,
	noChaseCategory		= "FLAG AIR MINE",
	selfDestructAs		= "Vehicle_Explosion_Sm",
	sightDistance		= 840,
	turninplace			= false,
	
	customparams = {
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
	Boat = Boat,
	PontoonRaft = PontoonRaft,
	BoatMother = BoatMother,
	BoatChild = BoatChild,
}