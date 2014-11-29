local ITA_StorageSupply = Storage:New{
	name					= "Storage & Supply Center",
	customparams = {
		supplyrangemodifier		= 0.1,
	},
}

return lowerkeys({
	["ITAStorageSupply"] = ITA_StorageSupply,
})
