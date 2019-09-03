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
		wiki_parser                 = "vehicle",  -- vehicles.md template
		wiki_subclass_comments      = "",      -- To be override by inf classes
		wiki_comments               = "",      -- To be override by each unit
	},
}

-- Motorcycle
local Motorcycle = Vehicle:New{
    acceleration        = 0.3,
    brakeRate           = 0.4,
    buildCostMetal      = 800,
    footprintX          = 2,
    footprintZ          = 2,
    maxDamage           = 50,
    sightDistance           = 300,
    radarDistance           = 1250,
    description         = "Motorcycle",
    category            = "MINETRIGGER SOFTVEH",
    iconType            = "jeep",
    movementClass       = "TANK_Motorcycle",
    turnRate            = 425,

    customParams = {
	buildOutside	= 1,
        maxvelocitykmh      = 85,
        damageGroup     = "unarmouredVehicles",
        turretturnspeed     = 180,
        wiki_subclass_comments = [[This specific vehicle has been designed
to offer a good line of sight, which can be conveniently used to support other
armoured vehicles to engage enemy units.
This vehicle is poorly armoured, so it should not be excesivelly exposed to
enemy fire.]],
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
		wiki_subclass_comments = [[This specific vehicle has been designed
to offer a good line of sight, which can be conveniently used to support other
armoured vehicles to engage enemy units.
This vehicle is poorly armoured, so it should not be excesivelly exposed to
enemy fire.]],
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
		weapontoggle		= "priorityAPHE",
		wiki_subclass_comments = [[Light vehicles are fast vehicles specifically
aimed to provide infatry skirmish support. They are fast enough to quickly take
position at front, or even to run away just in case.
Maybe this vehicles cannot be applied in a heavy armour encounteer, but they
are cheap enough to worth making a couple of them.]],
	},
}

local HeavyArmouredCar = ArmouredCar:New{
	acceleration		= 0.03,
	description			= "Heavy Armoured Car",
	category			= "MINETRIGGER HARDVEH",
	immobilizationresistance = 0.5,
	customParams = {
		wiki_subclass_comments = [[When the enemy is preparing a large army of
light vehicles, building a couple of light armoured vehicles can be a great
way to fight back them. By a slightly increased cost, this vehicles enjoy
an armour upgrade which make their tiny guns simply useless, and upgraded guns
which make them an easy prey.]],
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
	maxVelocity			= 3.4,
	movementClass		= "TANK_Truck",
	turnRate			= 180,
	-- builder tags
	buildDistance		= 196,
	builder				= true,
	showNanoSpray		= false,
	terraformSpeed		= 300,
	workerTime			= 30,
	customParams = {
		wiki_subclass_comments = [[This vehicle is the second tier of building
staff of your army, able to build faster than engineers, and with a wider
catalogue of structures, like basic armour prep. facilities. This vehicle is
significantly expensive and vulnerable, keep it safe!]],
	},
}

-- Trucks --
local Truck = Vehicle:New{ -- Basis of all Trucks e.g. gun tractors, transports
	acceleration		= 0.24,
	brakeRate			= 0.96,
	category			= "MINETRIGGER SOFTVEH",
	mass				= 300,
	maxDamage			= 300,
	maxReverseVelocity	= 2.25,
	maxVelocity			= 3.6,
	movementClass		= "TANK_Truck",
	turnRate			= 220,

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
	maxReverseVelocity	= 0.5,
	maxVelocity			= 1,
	movementClass		= "HOVER_AmphibTruck",
	script				= nil, -- TODO: atm they have individual copies
	customParams = {
		wiki_subclass_comments = [[This vehicle has the very only objective of
deploying as a shipyard in water. Along this line, it is unarmed at all, and can
be engaged by almost every weapon of the game, becoming a very good target.]],
	},
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
	customParams = {
		wiki_subclass_comments = [[Self-Propelled Anti-Aircraft truck. In
general, AA trucks are less efficient that AA deployed guns. However, they can
be a good alternative to protect you armoured column while moving, since towed
AA guns require some time to become deployed.]],
	},
}

local ArmouredCarAA = ArmouredCar:New(MobileAA)

local TransportTruck = Truck:New(Transport):New{ -- Transport Trucks
	description			= "Transport/Supply Truck",
	buildCostMetal		= 510,
	iconType			= "truck",

	customParams = {
		dontCount		= 1,
		wiki_subclass_comments = [[This unit has 2 main objectives: Fast
transport of infantry, which might be helpful to provide fast support, and
resupply ammo. To resupply units, this truck should be deployed.]],
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
		wiki_subclass_comments = [[This unit has 2 main objectives: Fast
transport of infantry, which might be helpful to provide fast support, and
resupply ammo. Even thought this unit does not require to be deployed in order
to supply ammo, it's supply radius is quite small. Hence, if you are planning
to statically feed your weapons, then you should consider a supply truck
instead.]],
	},
}

local AAGunTractor = Truck:New{
	description			= "Towed Anti-Aircraft Gun",
	buildCostMetal		= 1400,
	iconType			= "aatruck",
	customParams = {
		wiki_subclass_comments = [[This unit is a towed Anti-Aircraft gun.
This unit is unarmed until it is not deployed.]],
	},
}

local ATGunTractor = Truck:New{
	description			= "Towed Anti-Tank Gun",
	buildCostMetal		= 840,
	iconType			= "attruck",
	customParams = {
		wiki_subclass_comments = [[This unit is a towed Anti-Tank gun.
This unit is unarmed until it is not deployed.]],
	},
}

local FGGunTractor = Truck:New{
	description			= "Towed Field Gun",
	buildCostMetal		= 1300,
	iconType			= "fgtruck",
	customParams = {
		wiki_subclass_comments = [[This unit is a towed Field gun.
This unit is unarmed until it is not deployed.]],
	},
}

local HGunTractor = Truck:New{
	description			= "Towed Howitzer",
	buildCostMetal		= 1800,
	iconType			= "htruck",
	customParams = {
		wiki_subclass_comments = [[This unit is a towed Howitzer gun.
This unit is unarmed until it is not deployed.]],
	},
}

local LongRangeGunTractor = Truck:New{
	description			= "Towed Long-Range Gun",
	buildCostMetal		= 3200,
	iconType			= "htruck",
	maxVelocity			= 3,
	maxReverseVelocity	= 1.2,
	customParams = {
		wiki_subclass_comments = [[This unit is a towed Long-Range Howitzer gun.
This unit is unarmed until it is not deployed.]],
	},
}

local RGunTractor = Truck:New{
	description			= "Towed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "rtruck",
	customParams = {
		wiki_subclass_comments = [[This unit is a towed rocket launcher.
This unit is unarmed until it is not deployed.]],
	},
}

return {
	Vehicle = Vehicle,
	-- Roles
	Amphibian = Amphibian,
	MobileAA = MobileAA,
	Transport = Transport,
	-- Base Classes
	Motorcycle = Motorcycle,
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
