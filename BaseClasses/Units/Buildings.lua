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
		blockfear                   = true,
		supplyrange                 = 500,
		wiki_parser                 = "yard",  -- yard.md template
		wiki_subclass_comments      = "",      -- To be override by yard classes
		wiki_comments               = "",      -- To be override by each unit
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
		wiki_subclass_comments = [[The Head Quarters is a fortified building
which may ask for recon air sorties, and recruit engineers and basic infantry
forces.]],
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
		wiki_subclass_comments = [[Barracks is the main building to recruit
infantry squads. This is one of the first yards you should build, because even
with the most advanced armoured vehicles you are probably failing without
infantry support.]],
	},
}

local GunYard = Yard:New{
	name				= "Towed Gun Yard",
	description			= "Towed Artillery Prep. Facility",
	buildCostMetal		= 2000, -- JPN 1800, ITA 1800
	objectName			= "<SIDE>/<SIDE>GunYard.s3o", -- inherited by upgrades
	buildPic			= "<SIDE>GunYard.png", -- inherited by upgrades
	customParams = {
		wiki_subclass_comments = [[This yard is intended to build towed basic
guns. Towed artillery is in general less flexible and effective than
self-propelled guns or armoured vehicles. However they are much cheaper,
becoming a great option to setup a defense line.]],
	},
}

local GunYardSP = GunYard:New{
	name				= "Self-Propelled Gun Yard",
	description			= "Self-Propelled Gun Prep. Facility",
	buildCostMetal		= 2000, -- GBR 1868, GER 2175, ITA 1800, JPN 1800, RUS 5400, US 3600
	workerTime			= 50,
	customParams = {
		wiki_subclass_comments = [[This yard is intended to build the towed
basic guns, as well as self-propelled artillery. Self-propelled artillery is
significantly more expensive than towed artillery guns, but much more effective
as well, since can be quickly moved to avoid counter artillery fire, or even to
get closer to the enemy base to increase the accuracy.]],
	},
}

local GunYardTD = GunYard:New{
	name				= "Tank Destroyer Yard",
	description			= "Tank Destroyer Prep. Facility",
	buildCostMetal		= 2000, -- GBR 1868, GER 2175, ITA 1800, JPN 1800, RUS 5400, US 3600,
	workerTime			= 50,
	customParams = {
		wiki_subclass_comments = [[This yard is intended to build the towed
basic guns, as well as tank-destroyers. Tank destroyers are special armoured
vehicles specifically designed to hunt enemy armoured forces. Tank destroyers
may not even engage enemy infantry or buildings, excepting the assault guns.
Tank destroyers may become a quite efficient way to drive out enemy armoured
forces.]],
	},
}

local GunYardLongRange = GunYard:New{
	name				= "Long Range Artillery Yard",
	description			= "Long Range Cannons Prep. Facility",
	buildCostMetal		= 5000,
	workerTime			= 125,
	customParams = {
		wiki_subclass_comments = [[This yard is intended to build towed
guns, including the long-range artillery units. Long-range artillery can be
deployed at an insane distance from the enemy bases, harrassing them from a
safe position. Watch out of your ammo storage, they will easily emptied by
long-range artillery]],
	},
}

local VehicleYard = Yard:New{
	name				= "Light Vehicle Yard",
	description			= "Light Vehicle Prep. Facility",
	buildCostMetal		= 4600,
	objectName			= "<SIDE>/<SIDE>VehicleYard.s3o", -- inherited by upgrades
	buildPic			= "<SIDE>VehicleYard.png", -- inherited by upgrades
	customParams = {
		wiki_subclass_comments = [[This yard is intended to build light
vehicles. Light vehicles are fast units which may provide a great and cheap
support to infantry. Even thought they cannot be destroyed by rifle or machine
guns, they are extremely vulnerable to all kind of anti-tank units. They are
also vulnerable to infantry grenades, so never let your vehicles run without
infantry scort.]],
	},
}

local VehicleYardArmour = VehicleYard:New{
	name				= "Light Vehicle & Armour Yard",
	description			= "Light Vehicle & Armour Prep. Facility",
	customParams = {
		wiki_subclass_comments = [[This yard is intended to build light
vehicles and light tanks. The light tanks enjoy in general a slight increase of
armour and fire power, which can be used to efficiently hunt large ammounts of
enemy vehicles rushing into your base. They can also eventually survive to
light anti-tank bullet impacts.]],
	},
}

local TankYard = Yard:New{
	name				= "Tank Yard",
	description			= "Basic Armour Prep. Facility",
	buildCostMetal		= 8050, -- ITA 8530, JPN 8530
	workerTime			= 75, -- override Yard
	objectName			= "<SIDE>/<SIDE>TankYard.s3o", -- inherited by upgrades
	buildPic			= "<SIDE>TankYard.png", -- inherited by upgrades
	customParams = {
		wiki_subclass_comments = [[This yard can build basic armoured vehicles.
Tanks may make the difference at the time of pushing enemy lines, since their
large armour allows them to receive some impacts before putting them out of
action, while their weaponry is usually enough to deal big damage on enemy
forces.]],
	},
}

local TankYardAdv = TankYard:New{
	name				= "Advanced Tank Yard",
	description			= "Advanced Armour Prep. Facility",
	customParams = {
		wiki_subclass_comments = [[This yard can build advanced armoured
vehicles. When battle turns into an armoured confrontation, developing the
upgraded weapons of the advanced medium tanks is always a good strategy.
Advanced medium tanks are slightly more expensive than basic tanks, but much
more effective. Unfortunately, they will eventually have a hard time to fight
back heavy tanks.]],
	},
}

local TankYardHeavy = TankYard:New{
	name				= "Heavy Tank Yard",
	description			= "Heavy Armour Prep. Facility",
	customParams = {
		wiki_subclass_comments = [[This yard can build Heavy tanks, as well as
basic armoured vehicles. Heavy tanks are the ultimate armoured mobile weapon.
They are armoured enough to receive frontal impacts of above average weapons
without dealing damage. As drawback, heavy tanks are extremely expensive
units.]],
	},
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
		wiki_subclass_comments = [[This yard can build basic naval units.
If you want to battle at sea, you need one of this shipyards.]],
	},
}

local BoatYardLarge = BoatYard:New{
	name				= "Large Boat Yard",
	description			= "Large Naval Prep. Facility",
	iconType			= "hshipyard", -- TODO: worth it? only upgraded fac with its own icon
	workerTime          = 100,
	maxDamage           = 32500,
	customParams		= {
		wiki_subclass_comments = [[This yard can build large naval units.
If the sea battle ferocity starts increasing, you should consider start
producing large ships, with an upgraded armour and weaponry.]],
	},
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
	customParams		= {
		wiki_subclass_comments = [[This yard can ask for air raids.
You should never underestimate the eventual destructive power of an air
strike, which may easily knock out large armoured squads, or even reduce to
ashes valuable structures.]],
	},
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
		wiki_subclass_comments = [[Even thought this yard may build some units,
its main target is providing a large supply area, where your units may become
constantly resupplied with ammo. You should always try to deploy one of this
structures in a strategical point of the battle theater, such that you can
safely support your front units.]],
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
		wiki_parser             = "storage",  -- storage.md template
		wiki_comments           = "",         -- To be override by each unit
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
		wiki_parser             = "supplies",  -- storage.md template
		wiki_comments           = "",         -- To be override by each unit
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
