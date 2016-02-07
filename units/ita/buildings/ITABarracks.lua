Unit('ITA_Barracks'):Extends('Barracks'):Attrs{
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
}

Unit('ITA_BarracksElite'):Extends('ITA_Barracks'):Attrs{
	objectName					= "<SIDE>/ITABarracks.s3o",
	buildPic					= "itabarracks.png",
}

