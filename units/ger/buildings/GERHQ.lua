local GER_HQ = HQ:New{
	name					= "Wehrmacht HQ Bunker",
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
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
		},
		[2] = {
			name				= "Small_Tracer",
		},
	},
}

return lowerkeys({
	["GERHQBunker"] = GER_HQ,
})
