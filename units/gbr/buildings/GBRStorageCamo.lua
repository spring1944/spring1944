local GBR_StorageCamo = Storage:New{
	name					= "Hidden Storage Shed",
	customparams = {
			hiddenbuilding				= true,

	},
	minCloakDistance		= 300,
}

return lowerkeys({
	["GBRStorageCamo"] = GBR_StorageCamo,
})
