local ITAAB41 = ArmouredCar:New{
	name				= "Autoblinda AB-41",
	buildCostMetal		= 1085,
	maxDamage			= 752,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "BredaM3520mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "BredaM3520mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BredaM38",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= "BredaM38",
			mainDir				= [[0 0 -1]],
			maxAngleDif			= 45,
		},
		[5] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 18,
		armor_rear			= 9,
		armor_side			= 10,
		armor_top			= 6,
		reversemult			= 0.75,
		maxammo				= 19,
		maxvelocitykmh		= 78,

	}
}

return lowerkeys({
	["ITAAB41"] = ITAAB41,
})
