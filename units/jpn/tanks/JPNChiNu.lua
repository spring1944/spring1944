local JPNChiNu = MediumTank:New{
	name				= "Type 3 Chi-Nu",
	description			= "75mm Medium Tank",
	buildCostMetal		= 2650,
	maxDamage			= 1880,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type375mmL38AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type375mmL38HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
            maxAngleDif			= 50,
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 50,
		armor_rear			= 20,
		armor_side			= 20,
		armor_top			= 12,
		slope_front			= 16,
		slope_rear			= -1,
		slope_side			= 30,
		maxammo				= 12,
		maxvelocitykmh		= 39,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNChiNu"] = JPNChiNu,
})
