local ITA_Barracks = Barracks:New{
	buildCostMetal				= 1500,
	collisionVolumeScales		= [[50 32 110]],
	collisionVolumeOffsets		= [[0 -5 0]],
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

}

local ITA_BarracksElite = ITA_Barracks:New{
	objectName					= "<SIDE>/ITABarracks.s3o",
	buildPic					= "itabarracks.png",
}

return lowerkeys({
	["ITABarracks"] = ITA_Barracks,
	["ITAEliteBarracks"] = ITA_BarracksElite -- TODO: change unitname too
})
