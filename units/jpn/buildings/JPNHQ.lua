local JPN_HQ = HQ:New{
	name					= "Imperial Japanese Army HQ",
	collisionVolumeScales	= [[41 44 82]],
	collisionVolumeOffsets	= [[0 -11 -3]],
	collisionVolumeType		= "CylZ",
	footprintX				= 4,
	footprintZ				= 6,
	maxDamage				= 10625, -- TODO: Same as GER Bunker! Change me!
	yardmap					= [[oooo 
							    oyyo 
								oyyo 
								oyyo 
								yyyy 
								yyyy]],
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["JPNHQ"] = JPN_HQ,
})
