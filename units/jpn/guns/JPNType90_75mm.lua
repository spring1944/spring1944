local JPN_Type90_75mm_Truck = FGGunTractor:New{
	name					= "Towed Type 90 75mm Gun",
	buildCostMetal			= 1250,
	corpse					= "JPNShiKe_Abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["JPNType90_75mm_Truck"] = JPN_Type90_75mm_Truck,
})
