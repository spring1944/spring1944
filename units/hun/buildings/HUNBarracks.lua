local HUN_Barracks = Barracks:New{
	buildCostMetal				= 2340,
	buildingGroundDecalSizeX	= 7,
	buildingGroundDecalSizeY	= 7,
	collisionVolumeScales		= [[41 44 82]],
	collisionVolumeOffsets		= [[0 -11 -3]],
	collisionVolumeType			= "CylZ",
	footprintX					= 4,
	footprintZ					= 6,
	maxDamage					= 5315,
	yardmap						= [[oooo 
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
	["HUNBarracks"] = HUN_Barracks,
})
