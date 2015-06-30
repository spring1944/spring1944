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
		damageGroup			= 'ships',
		dontCount			= 1,
		hasturnbutton		= 1,
	}
}

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

local ArmedBoat = BoatMother:New{
	customparams = {
		flagCapRate			= 2,
		flagCapType			= 'buoy',
	}
}

local BoatChild = Boat:New{ -- a boat turret
	buildCostMetal				= 1500, -- only used for exp
	canMove						= true,
	cantBeTransported			= false,
	canSelfDestruct				= false,
	category					= "SHIP MINETRIGGER TURRET DEPLOYED",
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
	maxDamage			= 1600,
}

local OpenBoatTurret = BoatChild:New{
	maxDamage			= 800,
	customparams = {
		feartarget		= true,
		fearlimit		= 12,
	}
}

-- as durable as a fully enclosed, but still suppressible
local PartiallyEnclosedBoatTurret = OpenBoatTurret:New{
	maxDamage			= 1600,
}

return {
	Boat = Boat,
	-- BoatMother and BoatChild deliberately not exported.
	ArmedBoat = ArmedBoat,
	OpenBoatTurret = OpenBoatTurret,
	PartiallyEnclosedBoatTurret = PartiallyEnclosedBoatTurret,
	EnclosedBoatTurret = EnclosedBoatTurret,
}
