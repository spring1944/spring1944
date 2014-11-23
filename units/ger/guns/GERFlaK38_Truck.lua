local GER_FlaK38_Truck = AAGunTractor:New{
	name					= "Towed 2cm FlaK 38",
	buildCostMetal			= 1250,
	corpse					= "GEROpelBlitz_Destroyed",
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["GERFlaK38_Truck"] = GER_FlaK38_Truck,
})
