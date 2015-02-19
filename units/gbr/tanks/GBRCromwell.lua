local GBRCromwell = MediumTank:New{
	name				= "A27M Cromwell Mk. IV",
	acceleration		= 0.071,
	brakeRate			= 0.15,
	buildCostMetal		= 2680,
	maxDamage			= 2800,
	maxReverseVelocity	= 1.925,
	maxVelocity			= 3.85,
	trackOffset			= 10,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF75mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "QF75mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 71,
		armor_rear			= 37,
		armor_side			= 37,
		armor_top			= 20,
		maxammo				= 12,
		weaponcost			= 12,
	},
}

local GBRCromwellMkVI = GBRCromwell:New{
	name				= "A27M Cromwell Mk. VI",
	description			= "Close Support Tank",
	
		weapons = {
		[1] = {
			name				= "CS95mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "CS95mmSmoke",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		-- 3 and 4 should be provided by GBRCromwell base
	},
	customParams = {
		maxammo				= 10,
		weaponcost			= 20,
		weapontoggle		= "smoke",
		canfiresmoke		= true,
	},
}

return lowerkeys({
	["GBRCromwell"] = GBRCromwell,
	["GBRCromwellMkVI"] = GBRCromwellMkVI,
})
