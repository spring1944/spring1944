local ITACannone65 = InfantryGun:New{
	name					= "Cannone da 65/17",
	corpse					= "itacannone65_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "Cannone65L17HE",
		},
		[2] = { -- HEAT
			name				= "Cannone65L17HEAT",
			maxAngleDif			= 30,
		},
	},
}


return lowerkeys({
	["ITACannone65"] = ITACannone65,
})
