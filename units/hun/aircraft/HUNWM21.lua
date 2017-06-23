local HUN_WM21 = Recon:New{
	name			= "Weiss WM-21 SOLYOM",
	maxDamage		= 77,
	
	maxAcc			= 0.480,
	
	customParams = {
		enginesound		= "po2-",
		enginesoundnr	= 11,
		normaltex			= "",
	},
}


return lowerkeys({
	["HUNWM21"] = HUN_WM21,
})
