local HUN_38MBotondBase = Truck:New{
	name					= "38M Botond",
	corpse					= "HUN38MBotond_Abandoned",
	trackOffset				= 10,
	trackWidth				= 13,
	customParams = {
		normaltex			= "unittextures/HUN38MBotond_normals.png",
	},
}

local HUN_38MBotond = HUN_38MBotondBase:New(TransportTruck)

HUN_38MBotond.corpse = "HUN38MBotond_Abandoned"

local HUN_PontoonTruck = HUN_38MBotondBase:New(PontoonTruck, true)

return lowerkeys({
	["HUN38MBotond"] = HUN_38MBotond,
	["HUNPontoonTruck"] = HUN_PontoonTruck,
})
