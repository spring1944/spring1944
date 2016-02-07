-- Vehicles ----
AbstractUnit('Vehicle'):Extends('Unit'):Attrs{
	canMove				= true,
	explodeAs			= "Vehicle_Explosion_Sm",
	footprintX			= 3,
	footprintZ			= 3,
	leaveTracks			= true,
	noChaseCategory		= "FLAG AIR MINE",
	reversemult			= 0.5,
	script				= "Vehicle.lua",
	seismicSignature	= 1, -- required, not default
	trackType			= "Stdtank",
	turnInPlace			= false,
	turnRate			= 400,
	
	customParams = {
		damageGroup		= "unarmouredVehicles",
		soundcategory	= "<SIDE>/Vehicle",
		reversemult		= 0.5,
	},
}

-- Armoured Car
AbstractUnit('ArmouredCar'):Extends('Vehicle'):Attrs{
	acceleration		= 0.047,
	brakeRate			= 0.09,
	description			= "Light Armoured Car",
	category			= "MINETRIGGER OPENVEH",
	iconType			= "armoredcar", -- sic
	movementClass		= "TANK_Car",	

	customParams = {
		damageGroup		= "armouredVehicles",
	},
}

AbstractUnit('HeavyArmouredCar'):Extends('ArmouredCar'):Attrs{
	acceleration		= 0.03,
	description			= "Heavy Armoured Car",
	category			= "MINETRIGGER HARDVEH",
}

-- Engineer Vehicles
AbstractUnit('EngineerVehicle'):Extends('Vehicle'):Attrs{
	description			= "Engineer Vehicle",
	acceleration		= 0.25,
	brakeRate			= 0.96,
	buildCostMetal		= 2700,
	category			= "SOFTVEH", -- don't trigger mines
	iconType			= "engineervehicle",
	maxDamage			= 1800,
	maxVelocity			= 3.4,
	movementClass		= "TANK_Truck",
	turnRate			= 180,
	-- builder tags
	buildDistance		= 196,
	builder				= true,
	showNanoSpray		= false,
	terraformSpeed		= 300,
	workerTime			= 30,
}

-- Trucks --
AbstractUnit('Truck'):Extends('Vehicle'):Attrs{ -- Basis of all Trucks e.g. gun tractors, transports
	acceleration		= 0.3,
	brakeRate			= 0.96,
	category			= "MINETRIGGER SOFTVEH",
	mass				= 300,
	maxDamage			= 300,
	maxReverseVelocity	= 2.25,
	maxVelocity			= 4.5,
	movementClass		= "TANK_Truck",
	turnRate			= 440,
	
	customParams = {
		buildOutside	= 1,
	},
}

AbstractUnit('PontoonTruck'):Extends('Truck'):Attrs{
	name				= "Pontoon Carrier", -- appended
	description			= "Deployable Boatyard Vehicle",
	buildCostMetal		= 1400,
	corpse				= "<NAME>_Dead", -- TODO: grumble
	maxWaterDepth		= 70,
	movementClass		= "HOVER_AmphibTruck",
	script				= nil, -- TODO: atm they have individual copies
}

AbstractUnit('Transport'):Attrs{ -- not a full class (role/mixin)
	loadingRadius		= 120,
    releaseHeld         = false,
	transportCapacity	= 15,
	transportMass		= 750,
	transportSize		= 1,
	unloadSpread		= 3,
}

AbstractUnit('Amphibian'):Attrs{ -- not a full class (role/mixin)
	movementClass		= "HOVER_AmphibTruck",
	waterline = 7.5,
}

AbstractUnit('MobileAA'):Attrs{ -- not a full class (role/mixin)
	description			= "Self-Propelled Light Anti-Aircraft",
	iconType			= "aacar",
}

AbstractUnit('TruckAA'):Extends('Truck'):Extends('MobileAA'):Attrs{
	acceleration		= 0.067,
	brakeRate			= 0.195,
}
AbstractUnit('ArmouredCarAA'):Extends('ArmouredCar'):Extends('MobileAA')


AbstractUnit('TransportTruck'):Extends('Truck'):Extends('Transport'):Attrs{ -- Transport Trucks
	description			= "Transport/Supply Truck",
	buildCostMetal		= 510,
	iconType			= "truck",

	customParams = {
		dontCount		= 1,
	},
}

AbstractUnit('HalfTrack'):Extends('ArmouredCar'):Extends('Transport'):Attrs{
	description			= "Transport/Supply Halftrack",
	category			= "MINETRIGGER OPENVEH",
	acceleration		= 0.039,
	brakeRate			= 0.195,
	buildCostMetal		= 1200,
	iconType			= "halftrack",
	movementClass		= "TANK_Light",
	
	customParams = {
		supplyRange			= 200,
	},
}

AbstractUnit('AAGunTractor'):Extends('Truck'):Attrs{
	description			= "Towed Anti-Aircraft Gun",
	buildCostMetal		= 1400,
	iconType			= "aatruck",
}

AbstractUnit('ATGunTractor'):Extends('Truck'):Attrs{
	description			= "Towed Anti-Tank Gun",
	buildCostMetal		= 840,
	iconType			= "attruck",
}

AbstractUnit('FGGunTractor'):Extends('Truck'):Attrs{
	description			= "Towed Field Gun",
	buildCostMetal		= 1300,
	iconType			= "fgtruck",
}

AbstractUnit('HGunTractor'):Extends('Truck'):Attrs{
	description			= "Towed Howitzer",
	buildCostMetal		= 1800,
	iconType			= "htruck",
}

AbstractUnit('RGunTractor'):Extends('Truck'):Attrs{
	description			= "Towed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "rtruck",
}

