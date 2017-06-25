local RUS_Barracks = Barracks:New{
	buildCostMetal				= 1500,
	collisionVolumeScales		= [[50 32 110]],
	collisionVolumeOffsets		= [[0 15 0]],
	footprintX					= 6,
	footprintZ					= 8,
	maxDamage					= 10000, -- TODO: wtf?
	yardmap						= [[oooooo 
								    oooooo 
									ooccoo 
									occcco 
									occcco 
									cccccc 
									cccccc 
									cccccc]],
	customParams = {
		normaltex			= "",
	},
}

return lowerkeys({
	["RUSBarracks"] = RUS_Barracks,
})
