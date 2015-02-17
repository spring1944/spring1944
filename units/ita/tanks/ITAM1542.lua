local ITAM1542 = LightTank:New{
	name				= "Carro Mediuo M15/42",
	acceleration		= 0.051,
	brakeRate			= 0.15,
	buildCostMetal		= 1850,
	maxDamage			= 1550,
	maxReverseVelocity	= 1.55,
	maxVelocity			= 3.1,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "CannoneDa47mml40AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "CannoneDa47mml40HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- front hull MG
			name				= "BredaM38",
			maxAngleDif			= 10,
		},
		[4] = { -- coax MG 1
			name				= "BredaM38",
		},
		[5] = { -- coax MG 2
			name				= "BredaM38",
			slaveTo				= 4,
		},
		[6] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 43,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 14,
		maxammo				= 25,
		weaponcost			= 8,
	},
}

return lowerkeys({
	["ITAM1542"] = ITAM1542,
})
