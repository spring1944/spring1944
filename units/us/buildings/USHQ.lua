local US_HQ = HQ:New{
	name						= "US Army HQ",
	buildingGroundDecalSizeX	= 5,
	buildingGroundDecalSizeY	= 7,
	collisionVolumeScales		= [[41 44 82]],
	collisionVolumeOffsets		= [[0 -11 -3]],
	collisionVolumeType			= "CylZ",
	footprintX					= 4,
	footprintZ					= 6,
	maxDamage					= 10625,
	yardmap						= [[oooo
								    oyyo 
									oyyo 
									oyyo 
									yyyy 
									yyyy]],
	customParams = {
		normaltex			= "unittextures/USHQ1_normals.dds",
	},
}

return lowerkeys({
	["USHQ"] = US_HQ,
})
