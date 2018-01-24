local GBR_HQ = HQ:New{
	name					= "British Army HQ",
	collisionVolumeScales	= [[76 45 86]],
	collisionVolumeOffsets	= [[0 -9 -3]],
	collisionVolumeType		= "CylZ",
	maxDamage				= 10625,
	yardmap					= [[ooooooo 
							    ooyyyoo 
								ooyyyoo 
								ooyyyoo 
								oyyyyyo 
								yyyyyyy 
								yyyyyyy]],
	customParams = {
		normaltex		= "unittextures/GBRHQ_normals.dds",
	},
}

return lowerkeys({
	["GBRHQ"] = GBR_HQ,
})
