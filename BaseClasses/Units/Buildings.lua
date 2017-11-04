-- Buildings ----
local Building = Unit:New{
	airSightDistance			= 2000,
	buildingGroundDecalType		= "Dirt2.dds",
	category					= "BUILDING",
	maxSlope					= 15,
	maxWaterDepth				= 0,
	radardistance				= 650,
	sightDistance				= 300,
	script						= "Yard.lua",
	stealth						= true,
	useBuildingGroundDecal		= true,
	
	customParams = {
		damageGroup		= "lightBuildings",
		soundcategory	= "<SIDE>/Yard",
	},
}

-- Yards --
local Yard = Building:New{
	builder 					= true,
	buildingGroundDecalSizeX	= 8,
	buildingGroundDecalSizeY	= 8,
	canBeAssisted				= false,
	canMove						= true, -- required for setting waypoints
	collisionVolumeType			= "box",
	collisionVolumeScales		= "100 17 100",
	footprintX					= 7,
	footprintZ					= 7,
	energyStorage				= 0.01, -- TODO: why?
	iconType					= "factory",
	idleAutoHeal				= 3,
	maxDamage					= 6250,
	maxSlope					= 10,
	reclaimable					= true,
	showNanoSpray				= false,
	workerTime					= 30,
	yardmap						= [[ooooooo 
								    ooooooo 
									occccco 
									oocccco 
									oocccco 
									occccco 
									occccco]],
	customParams = {
		blockfear					= true,
		supplyrange					= 500,
	},
}

local HQ = Yard:New{
	description			= "Command Outpost",
	buildCostMetal		= 2050,
	explodeAs			= "HUGE_Explosion", -- override Yard
	hideDamage			= true,
	iconType			= "<SIDE>hq",
	showPlayerName		= true,
	workerTime			= 20,
	customParams = {
		arrivalgap			= 450,
		flagcaprate			= 10,
		hq					= true,
		refillamount		= 1e+06,
		separatebuildspot	= true,
		soundcategory		= "<SIDE>/Yard/HQ",
	},	
}

local Barracks = Yard:New{
	name				= "Barracks",
	description			= "Infantry Training & Housing Facility",
	buildCostMetal		= 2000, -- (OLD) GBR 2340, GER 2140, ITA 1500, JPN 1500, RUS 1500, US 2300
	explodeAs			= "Med_Explosion", -- override Yard
	iconType			= "barracks", -- override Yard
	idleAutoHeal		= 10, -- engine default, override Yard
	workerTime			= 20,
	customParams = {
		separatebuildspot		= true,
	},
}

local GunYard = Yard:New{
	name				= "Towed Gun Yard",
	description			= "Towed Artillery Prep. Facility",
	buildCostMetal		= 2000, -- JPN 1800, ITA 1800
	objectName			= "<SIDE>/<SIDE>GunYard.s3o", -- inherited by upgrades
	buildPic			= "<SIDE>GunYard.png", -- inherited by upgrades
}

local GunYardSP = GunYard:New{
	name				= "Self-Propelled Gun Yard",
	description			= "Self-Propelled Gun Prep. Facility",
	buildCostMetal		= 2000, -- GBR 1868, GER 2175, ITA 1800, JPN 1800, RUS 5400, US 3600
	workerTime			= 50,
}

local GunYardTD = GunYard:New{
	name				= "Tank Destroyer Yard",
	description			= "Tank Destroyer Prep. Facility",
	buildCostMetal		= 2000, -- GBR 1868, GER 2175, ITA 1800, JPN 1800, RUS 5400, US 3600,
	workerTime			= 50,
}

local GunYardLongRange = GunYard:New{
	name				= "Long Range Artillery Yard",
	description			= "Long Range Cannons Prep. Facility",
	buildCostMetal		= 5000,
	workerTime			= 125,
}

local VehicleYard = Yard:New{
	name				= "Light Vehicle Yard",
	description			= "Light Vehicle Prep. Facility",
	buildCostMetal		= 4600,
	objectName			= "<SIDE>/<SIDE>VehicleYard.s3o", -- inherited by upgrades
	buildPic			= "<SIDE>VehicleYard.png", -- inherited by upgrades
}

local VehicleYardArmour = VehicleYard:New{
	name				= "Light Vehicle & Armour Yard",
	description			= "Light Vehicle & Armour Prep. Facility",
}

local TankYard = Yard:New{
	name				= "Tank Yard",
	description			= "Basic Armour Prep. Facility",
	buildCostMetal		= 8050, -- ITA 8530, JPN 8530
	workerTime			= 75, -- override Yard
	objectName			= "<SIDE>/<SIDE>TankYard.s3o", -- inherited by upgrades
	buildPic			= "<SIDE>TankYard.png", -- inherited by upgrades
}

local TankYardAdv = TankYard:New{
	name				= "Advanced Tank Yard",
	description			= "Advanced Armour Prep. Facility",
}

local TankYardHeavy = TankYard:New{
	name				= "Heavy Tank Yard",
	description			= "Heavy Armour Prep. Facility",
}

local BoatYard = Yard:New{
	name				= "Boat Yard",
	description			= "Light Naval Prep. Facility",
	buildCostMetal		= 5445,
	buildPic			= "<SIDE>BoatYard.png", -- inherited by upgrades
	corpse				= "Boatyard_Large_dead",
	iconType			= "shipyard", -- override Yard
	floater				= true,
	footprintX			= 14,
	footprintZ			= 14,
	objectName			= "Boatyard_large.s3o", -- inherited by upgrades TODO: 3do, ick!
    maxDamage           = 16250,
	maxWaterDepth		= 1e+06, -- engine default, override Yard
	minWaterDepth		= 10,
	script				= "Yard.lua",
	workerTime			= 75, -- override Yard
	yardmap				= [[ooccccccccccoo 
						    ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo 
							ooccccccccccoo]],
	customParams		= {
		customanims		= "boatyard",
	},
}

local BoatYardLarge = BoatYard:New{
	name				= "Large Boat Yard",
	description			= "Large Naval Prep. Facility",
	iconType			= "hshipyard", -- TODO: worth it? only upgraded fac with its own icon
	workerTime          = 100,
	maxDamage           = 32500,
}

local Radar = Yard:New{
	description			= "Flight Detection & Control Station",
	buildCostMetal		= 5138,
	iconType			= "radar", -- override Yard
	idleAutoHeal		= 10, -- engine default, override Yard
	footprintX			= 5,
	footprintZ			= 5,
	levelGround			= false,
	workerTime			= 100, -- override Yard
	yardmap				= [[ooooo 
						    oocoo 
							oocoo 
							oocoo 
							ooooo]],
}

-- Bunkers
local Bunker = Def:New{ -- not a full class (role/mixin)
	customParams = {
		damageGroup		= "bunkers",
	},
}

-- Supply Depots
local SupplyDepot = Yard:New{
	name					= "Large Supply Depot",
	description				= "Supplies An Extended Area",
	buildCostMetal			= 3600,
	collisionVolumeScales	= [[96 15 76]],
	collisionVolumeOffsets	= [[14 0 5]],
	corpse					= "BuildingDebris_Large",
	explodeAs				= "massive_explosion",
	footprintX				= 6,
	footprintZ				= 6,
	iconType				= "ammo2",
	maxDamage				= 3750,
	objectName				= "GEN/SupplyDepot.S3O",
	yardmap					= [[occcco 
							    occcco 
								occcco 
								occcco 
								occcco 
								occcco]],
	customparams = {
		supplyrange				= 2000,
	},
}

-- Logistics

-- Storages
local Storage = Building:New{
	name					= "Storage Shed",
	description				= "General Logistics & Ammunition Stockpile",
	buildCostMetal			= 4500,
	buildingGroundDecalSizeX= 4,
	buildingGroundDecalSizeY= 6,
	collisionVolumeScales	= [[39 40 64]],
	collisionVolumeOffsets	= [[-1 -7 1]],
	collisionVolumeType		= "CylZ",
	corpse					= "Debris_Large",
	energyStorage			= 1040,
	explodeAs				= "Massive_Explosion",
	footprintX				= 4,
	footprintZ				= 6,
	iconType				= "stockpile",
	maxDamage				= 1800,
	reclaimable				= true,
	yardmap					= [[oooo oooo oooo oooo oooo oooo]],
	customparams = {
		armor_front				= 0,
		armor_rear				= 0,
		armor_side				= 15,
		armor_top				= 30,
		dontcount				= 1,
	},
}
-- Truck Supplies
local Supplies = Building:New{
	name						= "Unloaded Truck Supplies",
	description					= "Supplies A Small Area",
	activateWhenBuilt			= true,
	buildCostMetal				= 720,
	buildingGroundDecalSizeX	= 4,
	buildingGroundDecalSizeY	= 4,
	corpse						= "Debris_Large",
	customparams = {
		dontCount					= 1,
		supplyRange					= 560,
	},
	explodeAs					= "ResourceBoom",
	footprintX					= 4,
	footprintZ					= 4,
	iconType					= "ammo",
	maxDamage					= 400,
}

local SuppliesSmall = Supplies:New{
	name						= "Small Supply Dump",
	description					= "Supplies A Small Area",
	corpse						= "Debris_Small",
	customparams = {
		hiddenbuilding				= true, -- TODO: remove this
		supplyRange					= 275,
	},
	footprintX					= 3,
	footprintZ					= 3,
	objectName					= "GEN/SuppliesSmall.S3O",
	yardmap						= [[yyy yyy yyy]],
}

return {
	Building = Building,
	-- Yards
	Yard = Yard,
	HQ = HQ,
	Barracks = Barracks,
	GunYard = GunYard,
	GunYardSP = GunYardSP,
	GunYardTD = GunYardTD,
	GunYardLongRange = GunYardLongRange,
	VehicleYard = VehicleYard,
	VehicleYardArmour = VehicleYardArmour,
	TankYard = TankYard,
	TankYardAdv = TankYardAdv,
	TankYardHeavy = TankYardHeavy,
	BoatYard = BoatYard,
	BoatYardLarge = BoatYardLarge,
	Radar = Radar,
	Bunker = Bunker,
	SupplyDepot = SupplyDepot,
	-- Logistics
	Storage = Storage,
	Supplies = Supplies,
	SuppliesSmall = SuppliesSmall,
}
