local ITA_Ro37 = Recon:New{
	name			= "Ro.37Bis Lince",
	maxDamage		= 77,
	
	maxAcc			= 0.480,
	
	customParams = {
		enginesound		= "po2-",
		enginesoundnr	= 11,

		normaltex			= "unittextures/ITARo37bis_normals.png",
	},
}


return lowerkeys({
	["ITARo37"] = ITA_Ro37,
})
