local GER_Barracks = Barracks:New{
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

local GER_BarracksBunker = GER_Barracks:New{
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

return lowerkeys({
	["GERBarracks"] = GER_Barracks,
	["GERBarracksBunker"] = GER_BarracksBunker,
})
