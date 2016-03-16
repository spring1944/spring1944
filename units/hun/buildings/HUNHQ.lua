local HUN_HQ = HQ:New(Bunker):New{
	name					= "Hungarian HQ Bunker",
	buildTime				= 25000,
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
}

return lowerkeys({
	["HUNHQ"] = HUN_HQ,
})
