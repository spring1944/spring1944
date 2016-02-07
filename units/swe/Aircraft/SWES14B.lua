Unit('SWE_S14B'):Extends('Recon'):Attrs{
	name			= "S 14B Storch",
	maxDamage		= 86,
	
	maxAcc			= 0.317,
	script			= "gerfi156.cob",
	
	customParams = {
		enginesound		= "spitfireb-",
		enginesoundnr	= 18,
	},
	
	weapons = {
		[1] = {
			name				= "mg42aa",
			maxAngleDif			= 90,
			mainDir				= [[0 .75 -1]],
		},
	},
}


