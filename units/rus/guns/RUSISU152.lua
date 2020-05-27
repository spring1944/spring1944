local RUSISU152 = HeavyTank:New(AssaultGun):New{
	name				= "ISU-152",
	description			= "Heavy Assault Gun",
	buildCostMetal		= 5800,
	maxDamage			= 4180,
	trackOffset			= 5,
	trackWidth			= 22,

	weapons = {
		[1] = {
			name				= "ML20S152mmHE",
			maxAngleDif			= 25,
		},
		--[2] = {
			--name				= "ML20S152mmAP",
			--maxAngleDif			= 25,
		--},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 90,
		armor_rear			= 60,
		armor_side			= 75,
		armor_top			= 30,
		slope_front			= 29,
		slope_rear			= 50,
		slope_side			= 15,

		maxammo				= 4,
		soundcategory		= "RUS/Tank/Zveroboy",
		weapontoggle		= false,
		maxvelocitykmh		= 40,
		killvoicecategory	= "RUS/Tank/Zveroboy/RUS_ISU_KILL",
		killvoicephasecount	= 3,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "unittextures/RUSISU152_normals.dds",
		piecehitvols		= {
			base				= {
									scale = {1, 0.6, 1},
									offset = {0, -0.2, 0},
								},
		},
	},
}

return lowerkeys({
	["RUSISU152"] = RUSISU152,
})
