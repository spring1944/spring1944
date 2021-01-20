local GER_StorageBunker = Storage:New(Bunker):New{
	name					= "Hardened Storage Shed",
	energyStorage			= 2200,
	buildCostMetal		= 7000,
	maxDamage				= 15000,
	customParams = {
		normaltex			= "unittextures/GERStorageBunker_normals.png",
	},
}

-- remove armor values
if GER_StorageBunker.customparams then
	GER_StorageBunker.customparams.armour = nil
end

return lowerkeys({
	["GERStorageBunker"] = GER_StorageBunker,
})
