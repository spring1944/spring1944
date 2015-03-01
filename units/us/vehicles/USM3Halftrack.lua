local USM3Base = Vehicle:New{
	acceleration			= 0.053,
	brakeRate				= 0.195,
	maxDamage				= 930,
	maxReverseVelocity		= 2.665,
	maxVelocity				= 5.33,
	trackOffset				= 10,
	trackWidth				= 15,
	turnRate				= 400,
	
	customParams = {
		armor_front				= 9,
		armor_rear				= 8,
		armor_side				= 8,
		armor_top				= 8,
		normaltex				= "unittextures/gbrm5halftrack_normals.dds",
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
		[2] = {
			name					= "M2BrowningAA",
		},
		[3] = {
			name					= "M2BrowningAA",
		},
		[4] = {
			name					= "M2BrowningAA",
		},
		[5] = { -- the cannon AA don't have anti-ground, should M16 and Staghound?
			name					= "M2Browning",
		},
		[6] = {
			name					= "M2Browning",
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
