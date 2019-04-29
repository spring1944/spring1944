local GERLeIG18 = InfantryGun:New{
	name					= "7.5cm LeIG 18",
	corpse					= "gerleig18_destroyed",
	buildCostMetal				= 1280,
	weapons = {
		[1] = { -- HE
			name				= "leig18HE",
		},
	},
	customParams = {

	},
}


local KK = NewInfGun:New{
	name					= "7.5cm LeIG 18",
	corpse					= "gerleig18_destroyed",
	buildCostMetal				= 1280,
	weapons = {
		[1] = { -- HE
			name				= "leig18HE",
		},
	},
	customParams = {

	},
}


return lowerkeys({
	["GERLeIG18"] = GERLeIG18,
	["GERKK"] = KK,
})
