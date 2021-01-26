local SWE_S14B = Recon:New{

	name			= "S 14B Storch",
	maxDamage		= 86,
	
	maxAcc			= 0.317,
	
	customParams = {
		enginesound		= "spitfireb-",
		enginesoundnr	= 18,
		normaltex			= "unittextures/SWES14_normals.png",
	},
	
	weapons = {
		[1] = {
			name				= "ksp_m1936AA",
			maxAngleDif			= 90,
			mainDir				= [[0 .25 -1]],
		},
	},
}


return lowerkeys({
	["SWES14B"] = SWE_S14B,
})
