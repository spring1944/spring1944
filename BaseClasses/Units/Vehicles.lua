-- Vehicles ----
local Vehicle = Unit:New{
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
		immobilizationresistance = 0,
	},
}

-- Scout car
local ScoutCar = Vehicle:New{
	acceleration		= 0.047,
	brakeRate			= 0.09,
	buildCostMetal		= 1100,
	maxDamage			= 100,
	sightDistance			= 300,
	radarDistance			= 1250,
	description			= "Light Scout Car",
	category			= "MINETRIGGER SOFTVEH",
	iconType			= "jeep",
	movementClass		= "TANK_Car",
	turnRate			= 425,

	weapons = {
		[1] = {
			name				= "binocs2",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 20,
		},
	},
	customParams = {
		maxvelocitykmh		= 85,
		damageGroup		= "unarmouredVehicles",
		turretturnspeed		= 180,
	},
}

-- Armoured Car
local ArmouredCar = Vehicle:New{
	acceleration		= 0.047,
	brakeRate			= 0.09,
	description			= "Light Armoured Car",
	category			= "MINETRIGGER OPENVEH",
	iconType			= "armoredcar", -- sic
	movementClass		= "TANK_Car",

	customParams = {
		damageGroup		= "armouredVehicles",
		turretturnspeed		= 36,	-- more than default tanks
		immobilizationresistance = 0.25,
	},
}

local HeavyArmouredCar = ArmouredCar:New{
	acceleration		= 0.03,
	description			= "Heavy Armoured Car",
	category			= "MINETRIGGER HARDVEH",
	immobilizationresistance = 0.5,
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
local Truck = Vehicle:New{ -- Basis of all Trucks e.g. gun tractors, transports
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

local PontoonTruck = Truck:New{
	name				= "Pontoon Carrier", -- appended
	description			= "Deployable Boatyard Vehicle",
	iconType			= "ptruck",
	buildCostMetal		= 1400,
	maxWaterDepth		= 70,
	acceleration		= 0.2,
	maxReverseVelocity	= 1.25,
	maxVelocity			= 2.5,
	movementClass		= "HOVER_AmphibTruck",
	script				= nil, -- TODO: atm they have individual copies
}

local Transport = Def:New{ -- not a full class (role/mixin)
	loadingRadius		= 120,
    releaseHeld         = false,
	transportCapacity	= 15,
	transportMass		= 750,
	transportSize		= 1,
	unloadSpread		= 3,
}

local Amphibian = Def:New{ -- not a full class (role/mixin)
	movementClass		= "HOVER_AmphibTruck",
	waterline = 7.5,
}

local MobileAA = Def:New{ -- not a full class (role/mixin)
	description			= "Self-Propelled Light Anti-Aircraft",
	iconType			= "aacar",
	customParams		= {
		turretturnspeed		= 80,
		spaa				= 1, -- hack due to unitdef.iconType being nil from engine
	},
}

local TruckAA = Truck:New(MobileAA):New{
	acceleration		= 0.067,
	brakeRate			= 0.195,
}

local ArmouredCarAA = ArmouredCar:New(MobileAA)

local TransportTruck = Truck:New(Transport):New{ -- Transport Trucks
	description			= "Transport/Supply Truck",
	buildCostMetal		= 510,
	iconType			= "truck",

	customParams = {
		dontCount		= 1,
	},
}

local HalfTrack = ArmouredCar:New(Transport):New{
	description			= "Transport/Supply Halftrack",
	category			= "MINETRIGGER OPENVEH",
	acceleration		= 0.039,
	brakeRate			= 0.195,
	buildCostMetal		= 1200,
	iconType			= "halftrack",
	movementClass		= "TANK_Light",

	customParams = {
		supplyRange			= 200,
		immobilizationresistance = 0.5,
	},
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

local LongRangeGunTractor = Truck:New{
	description			= "Towed Long-Range Gun",
	buildCostMetal		= 3200,
	iconType			= "htruck",
	maxVelocity			= 3,
	maxReverseVelocity	= 1.2,
}

local RGunTractor = Truck:New{
	description			= "Towed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "rtruck",
}

return {
	Vehicle = Vehicle,
	-- Roles
	Amphibian = Amphibian,
	MobileAA = MobileAA,
	Transport = Transport,
	-- Base Classes
	ScoutCar = ScoutCar,
	ArmouredCar = ArmouredCar,
	ArmouredCarAA = ArmouredCarAA,
	HeavyArmouredCar = HeavyArmouredCar,
	EngineerVehicle = EngineerVehicle,
	HalfTrack = HalfTrack,
	-- Trucks
	Truck = Truck,
	TruckAA  = TruckAA ,
	PontoonTruck = PontoonTruck,
	TransportTruck = TransportTruck,
	AAGunTractor = AAGunTractor,
	ATGunTractor = ATGunTractor,
	FGGunTractor = FGGunTractor,
	HGunTractor = HGunTractor,
	RGunTractor = RGunTractor,
	LongRangeGunTractor = LongRangeGunTractor,
}
