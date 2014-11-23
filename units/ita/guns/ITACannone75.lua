local ITA_Cannone75_Truck = FGGunTractor:New{
	name					= "Towed Cannone da 75/32",
	buildCostMetal			= 1250,
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["ITACannone75_Truck"] = ITA_Cannone75_Truck,
})
