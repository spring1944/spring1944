local GBR_Auster = Recon:New{
	name			= "TC Auster AOP Mk V",
	maxDamage		= 49.9,
	
	customParams = {
		enginesound		= "spitfireb-",
		enginesoundnr	= 18,
		normaltex			= "unittextures/GBRAuster1_normals.dds",
	},
}


return lowerkeys({
	["GBRAuster"] = GBR_Auster,
})
