local USM3Base = Vehicle:New{
	maxDamage				= 930,
	trackOffset				= 10,
	trackWidth				= 15,
	transportCapacity		= 11, -- 13 inc driver and gunner
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 13,
					slope			= 30,
				},
				rear = {
					thickness		= 6,
				},
				side = {
					thickness 		= 6,
				},
				top = {
					thickness		= 0,
				},
			},
			turret = {
				front = {
					thickness		= 0,
				},
				rear = {
					thickness		= 0,
				},
				side = {
					thickness 		= 0,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxvelocitykmh			= 72,
		frontseats				= 2,
	},
}

local USM3Halftrack = HalfTrack:New(USM3Base):New{
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
	customParams = {
		normaltex			= "unittextures/USM3A1Halftrack_normals.png",
	},
}


local USM16MGMC = USM3Base:New(ArmouredCarAA):New{
	name					= "M16 MGMC",
	buildCostMetal			= 990,
	corpse					= "usm16mgmc_destroyed",
	transportCapacity		= 0,

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
	customParams = {
		normaltex			= "unittextures/USM3A1Halftrack_normals.png",
	},
}

-- Lend Lease
local GBRM5Halftrack = USM3Halftrack:New{
	name = "M5A1 Halftrack",
	customParams = {
		normaltex			= "unittextures/gbrm5halftrack_normals.dds",
	},
}
local RUSM5Halftrack = USM3Halftrack:New{
	name = "M5A1 Halftrack",
	customParams = {
		normaltex			= "unittextures/RUSM5Halftrack_normals.dds",
	},
}


-- add custom anims here (model-specific, do not apply to M5)
USM3Halftrack.customparams.customanims		= "m3a1halftrack"
USM3Halftrack.objectname 					= "<SIDE>/USM3A1Halftrack.s3o"

USM16MGMC.customparams.customanims		= "m3a1halftrack"

return lowerkeys({
	["USM3Halftrack"] = USM3Halftrack,
	["USM16MGMC"] = USM16MGMC,
	["GBRM5Halftrack"] = GBRM5Halftrack,
	["RUSM5Halftrack"] = RUSM5Halftrack,
})
