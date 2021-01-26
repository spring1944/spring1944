local US_Barracks = Barracks:New{
	buildingGroundDecalSizeX	= 7,
	buildingGroundDecalSizeY	= 7,
	collisionVolumeScales		= [[41 44 82]],
	collisionVolumeOffsets		= [[0 -11 -3]],
	collisionVolumeType			= "CylZ",
	footprintX					= 4,
	footprintZ					= 6,
	yardmap						= [[oooo 
								    oyyo 
									oyyo 
									oyyo 
									yyyy 
									yyyy]],
	customParams = {
		normaltex			= "unittextures/USBarracks1_normals.png",
	},
}

return lowerkeys({
	["USBarracks"] = US_Barracks,
})
