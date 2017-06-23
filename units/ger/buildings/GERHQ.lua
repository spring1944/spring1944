local GER_HQ = HQ:New(Bunker):New{
	name					= "Wehrmacht HQ Bunker",
	buildCostMetal			= 4000,
	collisionVolumeScales	= [[150 30 110]],
	collisionVolumeOffsets	= [[0 -13 0]],
	footprintX				= 10,
	footprintZ				= 10,
	maxDamage				= 10625,
	yardmap					= [[oooooooooo 
								oooooooooo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo]],
	weapons = {
		[1] = {
			name				= "MG34",
		},
	},
	customParams = {
		normaltex			= "unittextures/GERHQBunker_normals.dds",
	},
}

return lowerkeys({
	["GERHQBunker"] = GER_HQ,
})
