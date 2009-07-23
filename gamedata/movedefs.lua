local moveDefs 	=	 {
	{
		name					=	"KBOT_Infantry",
		footprintX		=	1,
		maxWaterDepth	=	10,
		maxSlope			=	36,
		crushStrength	=	0,
	},
	{
		name					=	"TANK_Truck",
		footprintX		=	3,
		maxWaterDepth	=	5,
		maxSlope			=	17,
	},
	{
		name					=	"TANK_Car",
		footprintX		=	2,
		maxWaterDepth	=	8,
		maxSlope			=	18,
	},
	{
		name					=	"TANK_Light",
		footprintX		=	2,
		maxWaterDepth	=	8,
		maxSlope			=	22,
	},
	{
		name					=	"TANK_Medium",
		footprintX		=	3,
		maxWaterDepth	=	10,
		maxSlope			=	21,
	},
	{
		name					=	"TANK_Heavy",
		footprintX		=	3,
		maxWaterDepth	=	15,
		maxSlope			=	20,
	},
	{
		name					=	"TANK_SuperHeavy",
		footprintX		=	4,
		maxWaterDepth	=	15,
		maxSlope			=	18,
	},
	{
		name					=	"TANK_VeryLarge",
		footprintX		=	5,
		maxWaterDepth	=	15,
		maxSlope			=	10,
	},
	{
		name					=	"KBOT_Gun",
		footprintX		=	2,
		maxWaterDepth	=	5,
		maxSlope			=	24,
	},
	{
		name					=	"BOAT_Small",
		footprintX		=	3,
		minWaterDepth	=	5,
		crushStrength	=	10,
	},
	{
		name					=	"BOAT_Medium",
		footprintX		=	15,
		minWaterDepth	=	5,
		crushStrength	=	10,
	},
	{
		name					=	"BOAT_RiverSmall",
		footprintX		=	4,
		minWaterDepth	=	6,
		crushStrength	=	10,
	},
	{
		name					=	"BOAT_River",
		footprintX		=	8,
		minWaterDepth	=	6,
		crushStrength	=	10,
	},
	{
		name					=	"BOAT_LightPatrol",
		footprintX		=	4,
		minWaterDepth	=	10,
		crushStrength	=	10,
	},
	{
		name					=	"BOAT_Destroyer",
		footprintX		=	8,
		minWaterDepth	=	20,
		crushStrength	=	10,
	},
	{
		name					=	"BOAT_LandingCraft",
		footprintX		=	8,
		minWaterDepth	=	2,
		crushStrength	=	10,
	},
	{
		name					=	"HOVER_AmphibTruck",
		footprintX		=	3,
		footprintY		=	3,
		MaxSlope		=	17,
		MaxWaterSlope		=	255,
		crushStrength		=	10,
	},
	{
		name					=	"BOAT_Sub",
		footprintX		=	8,
		minWaterDepth	=	40,
		crushStrength	=	10,
		submarine	=	1,
	},
	{
		name					=	"TANK_Truck_deep",
		footprintX		=	3,
		maxWaterDepth	=	45,
		maxSlope			=	17,
	}
}

return moveDefs