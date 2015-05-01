local USM3Base = Vehicle:New{
	maxDamage				= 930,
	trackOffset				= 10,
	trackWidth				= 15,
	
	customParams = {
		armor_front				= 9,
		armor_rear				= 8,
		armor_side				= 8,
		armor_top				= 8,
		normaltex				= "unittextures/gbrm5halftrack_normals.dds",
		maxvelocitykmh			= 72,
	},
}

local USM3Halftrack = USM3Base:New(HalfTrack):New{
	name					= "M3A1 Halftrack",
	buildCostMetal			= 1200,
	
	weapons = {
		[1] = {
			name					= "M2Browning",
		},
		[2] = {
			name					= "M2BrowningAA",
		},
	},
}


local USM16MGMC = USM3Base:New(ArmouredCarAA):New{
	name					= "M16 MGMC",
	buildCostMetal			= 990,
	corpse					= "usm3halftrack_destroyed", -- TODO: M16 corpse

	weapons = {
		[1] = {
			name					= "M2BrowningAA",
		},
		[2] = { -- Need to be interlaced with AA to use same flares
			name					= "M2Browning",
		},
		[3] = {
			name					= "M2BrowningAA",
		},
		[4] = {
			name					= "M2Browning",
		},
		[5] = {
			name					= "M2BrowningAA",
		},
		[6] = {
			name					= "M2BrowningAA",
		},
	},
}



-- Lend Lease
local GBRM5Halftrack = USM3Halftrack:New{name = "M5 Halftrack"}
local RUSM5Halftrack = USM3Halftrack:New{name = "M5 Halftrack"}

return lowerkeys({
	["USM3Halftrack"] = USM3Halftrack,
	["USM16MGMC"] = USM16MGMC,
	["GBRM5Halftrack"] = GBRM5Halftrack,
	["RUSM5Halftrack"] = RUSM5Halftrack,
})
