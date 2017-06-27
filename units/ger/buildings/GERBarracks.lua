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
	customParams = {
		normaltex			= "unittextures/GERBarracks_normals.dds",
	},
}

local GER_BarracksBunker = GER_Barracks:New(Bunker):New{
	buildCostMetal				= 5640,
	maxDamage					= 18250,
	yardmap						= [[ooyyy 
								    yyyyy 
									yyyyy 
									yycyy 
									ooyyy 
									ooyyy 
									ooyyy]],
	customParams = {

	},
}

return lowerkeys({
	["GERBarracks"] = GER_Barracks,
	["GERBarracksBunker"] = GER_BarracksBunker,
})
