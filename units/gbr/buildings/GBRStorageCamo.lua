local GBR_StorageCamo = Storage:New{
	name					= "Hidden Storage Shed",
	energyStorage			= 1144,
	customparams = {
		hiddenbuilding		= true,
		normaltex			= "unittextures/GBRStorageCamo_normals.png",
	},
	minCloakDistance		= 300,
}

return lowerkeys({
	["GBRStorageCamo"] = GBR_StorageCamo,
})
