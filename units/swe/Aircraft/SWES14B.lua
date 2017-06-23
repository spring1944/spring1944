local SWE_S14B = Recon:New{

	name			= "S 14B Storch",
	maxDamage		= 86,
	
	maxAcc			= 0.317,
	
	customParams = {
		enginesound		= "spitfireb-",
		enginesoundnr	= 18,
		normaltex			= "",
	},
	
	weapons = {
		[1] = {
			name				= "mg42aa",
			maxAngleDif			= 90,
			mainDir				= [[0 .75 -1]],
		},
	},
}


return lowerkeys({
	["SWES14B"] = SWE_S14B,
})
