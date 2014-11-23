local ITA_Breda20_Truck = AAGunTractor:New{
	name					= "Towed Breda 20/65",
	buildCostMetal			= 1250,
	corpse					= "ITAFiat626_Abandoned", -- TODO: grumble
	script					= "gerflak38_truck.cob",
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["ITABreda20_Truck"] = ITA_Breda20_Truck,
})
