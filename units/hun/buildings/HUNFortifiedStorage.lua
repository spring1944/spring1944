local HUN_FortifiedStorage = Storage:New(Bunker):New{
	name					= "Fortified Storage Shed",
	maxDamage				= 12000,
	energyStorage			= 2200,
	buildCostMetal		= 6500,
	weapons = {
		[1] = {
			name				= "feg35m",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 90,
		},
		[2] = {
			name				= "feg35m",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 90,
		},
		[3] = {
			name				= "feg35m",
			mainDir				= [[0 0 -1]],
			maxAngleDif			= 90,
		},
		[4] = {
			name				= "feg35m",
			mainDir				= [[0 0 -1]],
			maxAngleDif			= 90,
		},
		[5] = {
			name				= "feg35m",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
		[6] = {
			name				= "feg35m",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
		[7] = {
			name				= "feg35m",
			mainDir				= [[-1 0 0]],
			maxAngleDif			= 90,
		},
		[8] = {
			name				= "feg35m",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
		[9] = {
			name				= "feg35m",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
		[10] = {
			name				= "feg35m",
			mainDir				= [[1 0 0]],
			maxAngleDif			= 90,
		},
	},
	customParams = {

	},
}

if HUN_FortifiedStorage.customparams then
	HUN_FortifiedStorage.customparams.armour = nil
	HUN_FortifiedStorage.customparams.hidefirearc	= true
end

return lowerkeys({
	["HUNFortifiedStorage"] = HUN_FortifiedStorage,
})
