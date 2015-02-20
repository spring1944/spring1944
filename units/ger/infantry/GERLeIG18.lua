local GERLeIG18 = InfantryGun:New{
	name					= "7.5cm LeIG 18",
	corpse					= "gerleig18_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "leig18HE",
		},
	},
}


return lowerkeys({
	["GERLeIG18"] = GERLeIG18,
})
