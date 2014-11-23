local JPN_Type91_105mm_Truck = HGunTractor:New{
	name					= "Towed Obice da 100/22",
	buildCostMetal			= 1850, -- TODO: why?
	corpse					= "JPNShiKe_Abandoned", -- TODO: grumble
	script					= "jpnshike.cob",
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["JPNType91_105mm_Truck"] = JPN_Type91_105mm_Truck,
})
