local moveDefs 	=	 {
	{
		name				=	"KBOT_Infantry",
		footprintX			=	1,
		maxWaterDepth		=	10,
		maxSlope			=	36,
		crushStrength		=	0,
		heatmapping			=	true,
		heatProduced		=	3,
		allowRawMovement	= true,
	},
	{
		name				=	"KBOT_alpini",
		footprintX			=	1,
		maxWaterDepth		=	10,
		maxSlope			=	48,
		crushStrength		=	0,
		heatmapping			=	true,
		heatProduced		=	5,
	},
	{
		name				=	"KBOT_Gun",
		footprintX			=	2,
		maxWaterDepth		=	5,
		maxSlope			=	24,
		heatmapping			=	false,
	},
	{
		name			=	"TANK_Truck",
		footprintX		=	3,
		maxWaterDepth	=	5,
		maxSlope		=	17,
		slopeMod		=	52,
		heatmapping		=	true,
		heatMod			=	0.1,
	},
	{
		name			=	"TANK_Car",
		footprintX		=	2,
		maxWaterDepth	=	8,
		maxSlope		=	18,
		slopeMod		=	48,
		speedModClass	=	0,
		heatmapping		=	true,
		heatProduced	=	20,
		heatMod			=	0.35,
	},
	{
		name			=	"TANK_Motorcycle",
		footprintX		=	2,
		maxWaterDepth	=	8,
		maxSlope		=	22,
		slopeMod		=	36,
		speedModClass	=	0,
		heatmapping		=	true,
		heatProduced	=	8,
	},
	{
		name			=	"TANK_6pluswheels",
		footprintX		=	2,
		maxWaterDepth	=	8,
		maxSlope		=	19,
		slopeMod		=	42,
		crushStrength	=	13,
		heatmapping		=	true,
		speedModClass	=	0,
		heatProduced	=	25,
		heatMod			=	0.25, 
	},
	{
		name				=	"TANK_Light",
		footprintX			=	2,
		maxWaterDepth		=	8,
		maxSlope			=	22,
		crushStrength		=	15,
		heatmapping			=	false,
		heatProduced		=	25,
		allowRawMovement	=	true,
	},
	{
		name				=	"TANK_Medium",
		footprintX			=	3,
		maxWaterDepth		=	10,
		maxSlope			=	21,
		crushStrength		=	20,
		heatmapping			=	false,
		heatProduced		=	60,
		allowRawMovement	=	true,
	},
	{
		name				=	"TANK_Heavy",
		footprintX			=	3,
		maxWaterDepth		=	15,
		maxSlope			=	20,
		crushStrength		=	30,
		heatmapping			=	false,
		heatProduced		=	70,
		allowRawMovement	=	true,
	},
	{
		name				=	"TANK_Goat",
		footprintX			=	3,
		maxWaterDepth		=	15,
		maxSlope			=	30,
		crushStrength		=	30,
		heatmapping			=	false,
		heatProduced		=	80,
		allowRawMovement	=	true,
	},
	{
		name				=	"TANK_SuperHeavy",
		footprintX			=	4,
		maxWaterDepth		=	15,
		maxSlope			=	18,
		crushStrength		=	50,
		heatmapping			=	false,
		heatProduced		=	90,
		allowRawMovement	=	true,
	},
	{
		name				=	"TANK_VeryLarge",
		footprintX			=	5,
		maxWaterDepth		=	15,
		maxSlope			=	10,
		crushStrength		=	50,
		heatmapping			=	false,
		heatProduced		=	120,
		allowRawMovement	=	true,
	},
	{
		-- Rubber Dingy small floaters
		name					=	"BOAT_Small",
		footprintX				=	3,
		minWaterDepth			=	5,
		crushStrength			=	10,
		heatmapping				=	true,
		speedModClass			=	3,
	},
	{
		-- Ponton rafts
		name					=	"BOAT_Medium",
		footprintX				=	4, --15,
		minWaterDepth			=	5,
		crushStrength			=	10,
		heatmapping				=	true,
		allowTerrainCollisions	=	false,
		speedModClass			=	3,
	},
	{
		-- Infantry landing crafts:
		--  * GBRLCA
		--  * GERSchSturmboot
		--  * HUNSchSturmboot
		--  * ITAML
		--  * JPNDaihatsu
		--  * RUSTender15t
		--  * USLCVP
		name					=	"BOAT_LandingCraftSmall",
		footprintX				=	4,
		minWaterDepth			=	2,
		crushStrength			=	10,
		heatmapping				=	true,
	},
	{
		-- Vehicles landing crafts:
		--  * GBRLCT
		--  * GERMFP
		--  * HUNLaBo41
		--  * ITAMZ
		--  * JPNTokuDaihatsu
		--  * RUSLCT
		--  * USLCT
		-- This ships are already big enough to use SAT to block. 
		name					=	"BOAT_LandingCraft",
		-- Except HUNLaBo41 and JPNTokuDaihatsu, all the ships have 60 x 220
		-- collision volumes, so 60 / 16 ~ 4 x 220 / 16 ~ 14 "exclusion area" is
		-- is considered. It is visually ugly for HUNLaBo41 and JPNTokuDaihatsu,
		-- and maybe we want to generate another movedef for them, since those
		-- are actually smaller
		footprintX				=	4,
		footprintZ				=	14,
		minWaterDepth			=	2,
		crushStrength			=	10,
		heatmapping				=	true,
		heatProduced			=	85,
		allowTerrainCollisions	=	false,
	},
	{
		-- Small torpedo boats:
		--   * HUNPAM21
		--   * ITAMAS
		--   * JPNT14
		--   * RUSKomsMTB
		--   * RUSG5
		--   * SWET21
		--   * USPT103
		-- This boats may sails almost everywhere. Even though they are really,
		-- since they main purpose is getting mele confrontations with other
		-- ships, SAT will be involved anyway, so why not enabling SAT too and
		-- getting more realistic battles.
		name					=	"BOAT_MotorTorpedo",
		footprintX				=	1,
		footprintZ				=	6,
		minWaterDepth			=	6,
		crushStrength			=	5,
		heatmapping				=	true,
		heatProduced			=	25,
		allowTerrainCollisions	=	false,
		speedModClass			=	3,
	},
	{
		-- Small river boats:
		--   * JPNAbTei
		--   * JPNTypeNo1AuxSC
		--   * RUSBKA1125
		--   * RUSBMO
		--   * RUSPr165PB
		-- This boats are still small boats,.
		name					=	"BOAT_RiverSmall",
		footprintX				=	1,
		footprintZ				=	9,
		minWaterDepth			=	6,
		crushStrength			=	10,
		heatmapping				=	true,
		heatProduced			=	50,
		allowTerrainCollisions	=	false,
		speedModClass			=	3,
	},
	{
		-- Medium river boats:
		--   * GBRFairmileD
		--   * GBRLCSL
		--   * GERMAL
		--   * GERRBoot
		--   * GERSBoot
		--   * HUNGunboat
		--   * ITAMS
		--   * ITAVedetta
		--   * RUSPr161
		--   * SWEVedettbat
		--   * USSC
		-- This boats are still small boats,.
		name					=	"BOAT_RiverMedium",
		footprintX				=	2,
		footprintZ				=	12,
		minWaterDepth			=	10,
		crushStrength			=	20,
		heatmapping				=	true,
		heatProduced			=	75,
		allowTerrainCollisions	=	false,
		speedModClass			=	3,
	},
	{
		-- Large river boats:
		--   * GBRLCGM
		--   * GERT196
		--   * HUNAFP
		--   * ITAGabbiano
		--   * JPNSeta
		--   * SWEArholma
		--   * USLCSL
		-- This boats are still small boats,.
		name					=	"BOAT_RiverLarge",
		footprintX				=	3,
		footprintZ				=	15,
		minWaterDepth			=	10,
		crushStrength			=	20,
		heatmapping				=	true,
		heatProduced			=	75,
		allowTerrainCollisions	=	false,
		speedModClass			=	3,
	},
	{
		name			=	"HOVER_AmphibTruck", -- DUKW
		footprintX		=	3,
		footprintY		=	3,
		MaxSlope		=	25,
		MaxWaterSlope	=	255,
		crushStrength	=	10,
		heatmapping		=	false,
	},
	{
		name			=	"TANK_Truck_deep", -- boatyard trucks
		footprintX		=	3,
		maxWaterDepth	=	70,
		maxSlope		=	30,
		heatmapping		=	false,
	}
}

return moveDefs
