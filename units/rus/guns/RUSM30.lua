local RUS_M30_Truck = HGunTractor:New{
	name					= "Towed 122mm M-30",
	buildCostMetal			= 2000,
	corpse					= "RUSYa12_abandoned", -- TODO: grumble
	trackOffset				= 10,
	trackWidth				= 13,
}

return lowerkeys({
	["RUSM30_Truck"] = RUS_M30_Truck,
})
