-- Buildings ----
local Building = Unit:New{
	airSightDistance			= 2000,
	buildingGroundDecalType		= "Dirt2.dds",
	category					= "BUILDING",
	maxSlope					= 10,
	maxWaterDepth				= 0,
	radardistance				= 650,
	sightDistance				= 300,
	stealth						= true,
	useBuildingGroundDecal		= true,
	
	customParams = {
		soundcategory	= "<SIDE>/Yard",
	},
}

-- Yards --
local Yard = Building:New{
	builder 					= true,
	buildingGroundDecalSizeX	= 8,
	buildingGroundDecalSizeY	= 8,
	canBeAssisted				= false,
	canMove						= true, -- required?
	collisionVolumeType			= "box",
	collisionVolumeScales		= "100 17 100",
	footprintX					= 7,
	footprintZ					= 7,
	energyStorage				= 0.01, -- TODO: why?
	iconType					= "factory",
	idleAutoHeal				= 3,
	maxDamage					= 6250,
	showNanoSpray				= false,
	script						= "Yard.cob",
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
	--buildCostMetal		= 2000, -- GBR 2340, GER 2140, ITA 1500, JPN 1500, RUS 1500, US 2300
	explodeAs			= "Med_Explosion", -- override Yard
	iconType			= "barracks", -- override Yard
	idleAutoHeal		= 10, -- engine default, override Yard
	script				= "Barracks.cob",
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
}

local GunYardTD = GunYard:New{
	name				= "Tank Destroyer Yard",
	description			= "Tank Destroyer Prep. Facility",
	buildCostMetal		= 2000, -- GBR 1868, GER 2175, ITA 1800, JPN 1800, RUS 5400, US 3600,
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
	corpse				= "<SIDE>BoatyardLarge_dead",
	iconType			= "shipyard", -- override Yard
	floater				= true,
	footprintX			= 14,
	footprintZ			= 14,
	objectName			= "<SIDE>/<SIDE>BoatYardLarge.3do", -- inherited by upgrades TODO: 3do, ick!
	maxWaterDepth		= 1e+06, -- engine default, override Yard
	minWaterDepth		= 10,
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
}

local BoatYardLarge = BoatYard:New{
	iconType			= "hshipyard", -- TODO: worth it? only upgraded fac with its own icon
}

local Radar = Yard:New{
	description			= "Flight Detection & Control Station",
	buildCostMetal		= 5138,
	iconType			= "radar", -- override Yard
	idleAutoHeal		= 10, -- engine default, override Yard
	footprintX			= 5,
	footprintZ			= 5,
	levelGround			= false,
	script				= "Radar.cob",
	workerTime			= 100, -- override Yard
	yardmap				= [[ooooo 
						    oocoo 
							oocoo 
							oocoo 
							ooooo]],
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
	VehicleYard = VehicleYard,
	VehicleYardArmour = VehicleYardArmour,
	TankYard = TankYard,
	TankYardAdv = TankYardAdv,
	TankYardHeavy = TankYardHeavy,
	BoatYard = BoatYard,
	BoatYardLarge = BoatYardLarge,
	Radar = Radar,
}