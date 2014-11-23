local ITA_Cannone47_Truck = ATGunTractor:New{
	name					= "Towed Cannone da 47/32",
	buildCostMetal			= 400,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	script					= "ruszis2_truck.cob",
	trackOffset				= 5,
	trackWidth				= 12,
}

return lowerkeys({
	["ITACannone47_Truck"] = ITA_Cannone47_Truck,
})
