local GBR_StorageCamo = Storage:New{
	name					= "Hidden Storage Shed",
	customparams = {
			hiddenbuilding				= true,
		normaltex			= "",
	},
	minCloakDistance		= 300,
}

return lowerkeys({
	["GBRStorageCamo"] = GBR_StorageCamo,
})
