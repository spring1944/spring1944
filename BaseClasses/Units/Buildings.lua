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

local Barracks = Yard:New{
	description			= "Infantry Training & Housing Facility",
	explodeAs			= "Med_Explosion", -- override Yard
	iconType			= "barracks", -- override Yard
	idleAutoHeal		= 10, -- engine default, override Yard
	script				= "Barracks.cob",
	workerTime			= 20, -- TODO: why? override Yard
	customParams = {
		separatebuildspot		= true,
	},
}

local GunYard = Yard:New{
	name				= "Towed Gun Yard",
	description			= "Towed Artillery Prep. Facility",
	buildCostMetal		= 2000,
}

local SPYard = Yard:New{
	name				= "Self-Propelled Gun Yard",
	description			= "Self-Propelled Gun Prep. Facility",
}

local VehicleYard = Yard:New{
	name				= "Light Vehicle Yard",
	description			= "Light Vehicle Prep. Facility",
	buildCostMetal		= 4600,
}

local TankYard = Yard:New{
	name				= "Tank Yard",
	description			= "Basic Armour Prep. Facility",
	buildCostMetal		= 8050,
	workerTime			= 75, -- override Yard
}

local BoatYard = Yard:New{
	name				= "Boat Yard",
	description			= "Light Naval Prep. Facility",
	buildCostMetal		= 5445,
	iconType			= "shipyard", -- override Yard
	floater				= true,
	footprintX			= 14,
	footprintZ			= 14,
	maxWaterDepth		= 10e6, -- engine default, override Yard
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
	Barracks = Barracks,
	GunYard = GunYard,
	SPYard = SPYard,
	VehicleYard = VehicleYard,
	TankYard = TankYard,
	BoatYard = BoatYard,
	Radar = Radar,
}