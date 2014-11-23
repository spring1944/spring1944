local ITA_Obice100_Truck = HGunTractor:New{
	name					= "Towed Obice da 100/22",
	corpse					= "ITATL37_Abandoned", -- TODO: grumble
	script					= "ruszis3_truck.cob",
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["ITAObice100_Truck"] = ITA_Obice100_Truck,
})
