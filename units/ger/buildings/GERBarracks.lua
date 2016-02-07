Unit('GER_Barracks'):Extends('Barracks'):Attrs{
	buildCostMetal				= 2140,
	buildingGroundDecalSizeX	= 6,
	buildingGroundDecalSizeY	= 8,
	collisionVolumeScales		= [[70 30 105]],
	collisionVolumeOffsets		= [[0 -10 0]],
	footprintX					= 5,
	footprintZ					= 7,
	maxDamage					= 6250,
	yardmap						= [[yyooo 
								    ooooo 
									ooooo 
									ooooo 
									yyyyy 
									yyyyy 
									yyyyy]],
}

Unit('GER_BarracksBunker'):Extends('GER_Barracks'):Extends('Bunker'):Attrs{
	buildCostMetal				= 5640,
	maxDamage					= 18250,
	yardmap						= [[ooyyy 
								    yyyyy 
									yyyyy 
									yycyy 
									ooyyy 
									ooyyy 
									ooyyy]],
}

