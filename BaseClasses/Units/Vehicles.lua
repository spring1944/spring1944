-- Vehicles ----
local Vehicle = Unit:New{
	airSightDistance	= 1500,
	canMove				= true,
	explodeAs			= "Vehicle_Explosion_Sm",
	footprintX			= 3,
	footprintZ			= 3,
	leaveTracks			= true,
	noChaseCategory		= "AIR MINE",
	radardistance		= 950,
	seismicSignature	= 0, -- required, not default
	sightDistance		= 800,
	stealth				= true,
	turnInPlace			= false,
}

-- Trucks --
local Truck = Vehicle:New{ -- Basis of all Trucks e.g. gun tractors, transports
	acceleration		= 0.3,
	brakeRate			= 0.96,
	category			= "MINETRIGGER SOFTVEH",
	mass				= 300,
	maxDamage			= 300,
	maxReverseVelocity	= 2.25,
	maxVelocity			= 4.5,
	movementClass		= "TANK_Truck",
	trackType			= "Stdtank",
	turnRate			= 440,
	
	customParams = {
		buildOutside	= 1,
		dontCount		= 1,
	},
}

local TransportTruck = Truck:New{ -- Transport Trucks
	description			= "Transport/Supply Truck",
	buildCostMetal		= 510,
	iconType			= "truck",
	loadingRadius		= 120,
	script				= "TransportTruck.cob",
	transportCapacity	= 15,
	transportMass		= 750,
	transportSize		= 1,
	unloadSpread		= 3,
}
	
return {
	Vehicle = Vehicle,
	TransportTruck = TransportTruck,
}