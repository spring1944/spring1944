-- Vehicles ----
local Vehicle = Unit:New{
	airSightDistance	= 1500,
	canMove				= true,
	explodeAs			= "Vehicle_Explosion_Sm",
	footprintX			= 3,
	footprintZ			= 3,
	leaveTracks			= true,
	noChaseCategory		= "FLAG AIR MINE",
	radardistance		= 950,
	seismicSignature	= 0, -- required, not default
	sightDistance		= 800,
	stealth				= true,
	trackType			= "Stdtank",
	turnInPlace			= false,
	
	customParams = {
		soundcategory = "<SIDE>/Vehicle",
	},
}

-- Armoured Car
local ArmouredCar = Vehicle:New{
	category			= "MINETRIGGER OPENVEH",
	iconType			= "armoredcar", -- sic
	movementClass		= "TANK_Car",
	script				= "Vehicle.lua", -- TODO: Move to root class once ready
	
	customParams = {
		cegpiece = {
			[1] = "flare",
			[2] = "flare",
			[3] = "coaxflare",
		},
	},
}

-- Engineer Vehicles
local EngineerVehicle = Vehicle:New{
	description			= "Engineer Vehicle",
	acceleration		= 0.25,
	brakeRate			= 0.96,
	buildCostMetal		= 2700,
	category			= "SOFTVEH", -- don't trigger mines
	iconType			= "engineervehicle",
	maxDamage			= 1800,
	maxReverseVelocity	= 1.7,
	maxVelocity			= 3.4,
	movementClass		= "TANK_Truck",
	script				= "Vehicle.lua", -- TODO: Move to root class once ready
	turnRate			= 180,
	-- builder tags
	buildDistance		= 196,
	builder				= true,
	showNanoSpray		= false,
	terraformSpeed		= 300,
	workerTime			= 30,
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
	script				= "Vehicle.lua",
	turnRate			= 440,
	
	customParams = {
		buildOutside	= 1,
		dontCount		= 1,
	},
}

local PontoonTruck = Truck:New{
	name				= "Pontoon Carrier", -- appended
	description			= "Deployable Boatyard Vehicle",
	buildCostMetal		= 1400,
	corpse				= "<NAME>_Dead", -- TODO: grumble
	maxWaterDepth		= 70,
	movementClass		= "HOVER_AmphibTruck",
	script				= nil, -- TODO: atm they have individual copies
	
	customParams = {
		dontCount		= false,
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

local AAGunTractor = Truck:New{
	description			= "Towed Anti-Aircraft Gun",
	buildCostMetal		= 1400,
	iconType			= "aatruck",
}

local ATGunTractor = Truck:New{
	description			= "Towed Anti-Tank Gun",
	buildCostMetal		= 840,
	iconType			= "attruck",
}

local FGGunTractor = Truck:New{
	description			= "Towed Field Gun",
	buildCostMetal		= 1300,
	iconType			= "fgtruck",
}

local HGunTractor = Truck:New{
	description			= "Towed Howitzer",
	buildCostMetal		= 1800,
	iconType			= "htruck",
}

local RGunTractor = Truck:New{
	description			= "Towed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "rtruck",
}

return {
	Vehicle = Vehicle,
	ArmouredCar = ArmouredCar,
	EngineerVehicle = EngineerVehicle,
	-- Trucks
	Truck = Truck,
	PontoonTruck = PontoonTruck,
	TransportTruck = TransportTruck,
	AAGunTractor = AAGunTractor,
	ATGunTractor = ATGunTractor,
	FGGunTractor = FGGunTractor,
	HGunTractor = HGunTractor,
	RGunTractor = RGunTractor,
}