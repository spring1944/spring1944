local ITA_Barracks = Barracks:New{
	collisionVolumeScales		= [[50 32 110]],
	collisionVolumeOffsets		= [[0 -5 0]],
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
		normaltex			= "unittextures/ITABarracks_normals.png",
	},
}

local ITA_BarracksElite = ITA_Barracks:New{
	objectName					= "<SIDE>/ITABarracks.s3o",
	buildPic					= "itabarracks.png",
	maxDamage					= 8000,
	workerTime					= 25,
	customParams = {
		normaltex			= "unittextures/ITABarracks_normals.png",
	},
}

return lowerkeys({
	["ITABarracks"] = ITA_Barracks,
	["ITAEliteBarracks"] = ITA_BarracksElite -- TODO: change unitname too
})
