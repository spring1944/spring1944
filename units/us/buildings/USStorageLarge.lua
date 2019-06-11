local US_StorageLarge = Storage:New{
	name					= "Large Storage Shed",
	energyStorage			= 3120,
	buildCostMetal		= 7000,
	customParams = {
		normaltex			= "unittextures/LogisticsLarge_normals.dds",
	},
}

return lowerkeys({
	["USStorageLarge"] = US_StorageLarge,
})
