local US_L4 = Recon:New{
	name			= "L-4 Grasshopper",
	maxDamage		= 34.5,
	
	maxAcc			= 0.557,
	
	customParams = {
		enginesound		= "spitfireb-",
		enginesoundnr	= 18,
		normaltex			= "unittextures/USL4a_normals.png",
	},
}


return lowerkeys({
	["USL4"] = US_L4,
})
