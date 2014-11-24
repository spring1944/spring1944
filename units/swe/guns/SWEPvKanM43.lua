local SWE_PvKanM43_Truck = ATGunTractor:New{
	name					= "Towed 5.7cm PvKv m/43",
	buildCostMetal			= 450,
	corpse					= "SWEScaniaVabisF11_Destroyed",
	script					= "ruszis2_truck.cob",
	trackOffset				= 5,
	trackWidth				= 12,
}

return lowerkeys({
	["SWEPvKanM43_Truck"] = SWE_PvKanM43_Truck,
})
