local SWEPBilM40 = ArmouredCar:New{
	name				= "PBil m/40 Lynx",
	buildCostMetal		= 1280, 
	maxDamage			= 780,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "boforsm40_20mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "boforsm40_20mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "ksp_m1939",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= "ksp_m1939",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 45,
		},
		[5] = {
			name				= "ksp_m1939",
			mainDir				= [[0 0 -1]],
			maxAngleDif			= 45,
		},		
		[6] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 20,
		armor_rear			= 8,
		armor_side			= 10,
		armor_top			= 6,
		maxammo				= 19,
		reversemult			= 0.75,
		maxvelocitykmh		= 73,

	}
}

return lowerkeys({
	["SWEPBilM40"] = SWEPBilM40,
})
