local GER_StorageBunker = Storage:New(Bunker):New{
	name					= "Hardened Storage Shed",
	energyStorage			= 2200,
	maxDamage				= 15000,
	customParams = {

	},
}

-- remove armor values
if GER_StorageBunker.customparams then
	GER_StorageBunker.customparams.armor_front = nil
	GER_StorageBunker.customparams.armor_side = nil
	GER_StorageBunker.customparams.armor_top = nil
	GER_StorageBunker.customparams.armor_rear = nil
end

return lowerkeys({
	["GERStorageBunker"] = GER_StorageBunker,
})
