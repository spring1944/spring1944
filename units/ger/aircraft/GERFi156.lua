local GER_Fi156 = Recon:New{
	name			= "Fi 156 Storch",
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
	["GERFi156"] = GER_Fi156,
})
