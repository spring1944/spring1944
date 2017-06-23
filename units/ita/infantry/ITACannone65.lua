local ITACannone65 = InfantryGun:New{
	name					= "Cannone da 65/17",
	corpse					= "itacannone65_destroyed",
	buildCostMetal				= 950,
	weapons = {
		[1] = { -- HE
			name				= "Cannone65L17HE",
			maxAngleDif			= 30,
		},
		[2] = { -- HEAT
			name				= "Cannone65L17HEAT",
			maxAngleDif			= 30,
		},
	},
	customParams = {
		normaltex			= "",
	},
}


return lowerkeys({
	["ITACannone65"] = ITACannone65,
})
