local ITA_StorageSupply = Storage:New{
	name					= "Storage & Supply Center",
	customparams = {
		supplyrangemodifier	= 0.5,
		normaltex			= "unittextures/ITASupplyCenter_normals.png",
	},
}

return lowerkeys({
	["ITAStorageSupply"] = ITA_StorageSupply,
})
