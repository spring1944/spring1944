local US_M5Gun_Truck = ATGunTractor:New{
	name					= "Towed 3-Inch M5",
	buildCostMetal			= 600,
	corpse					= "USGMCTruck_Destroyed",
	trackOffset				= 10,
	trackWidth				= 15,
}

return lowerkeys({
	["USM5Gun_Truck"] = US_M5Gun_Truck,
})
