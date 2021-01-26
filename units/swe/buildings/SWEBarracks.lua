local SWE_Barracks = Barracks:New{
	collisionVolumeScales		= [[50 32 110]],
	collisionVolumeOffsets		= [[0 15 0]],
	footprintX					= 6,
	footprintZ					= 8,
	yardmap						= [[oooooo 
								    oooooo 
									ooccoo 
									occcco 
									occcco 
									cccccc 
									cccccc 
									cccccc]],
	customParams = {
		normaltex			= "unittextures/SWEScaniaVabisF11_normals.png",
	},
}

return lowerkeys({
	["SWEBarracks"] = SWE_Barracks,
})
