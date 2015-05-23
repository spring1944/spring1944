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
		damageGroup			= 'guns',
		feartarget			= true,
		fearlimit			= 50, -- default to double inf, open mounts should be 25
	}
}

return {
	Boat = Boat,
	BoatMother = BoatMother,
	BoatChild = BoatChild,
}