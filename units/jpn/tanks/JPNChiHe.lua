local JPNChiHe = MediumTank:New{
	name				= "Type 1 Chi-He",
	buildCostMetal		= 2300,
	maxDamage			= 1700,
	maxVelocity			= 2.9,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type147mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type147mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
            maxAngleDif			= 50,
		},
		[4] = { -- Rear turret MG
                        name                            = "Type97MG",
                        mainDir                         = [[0 16 -1]],
                        maxAngleDif                     = 210,

		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 50,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 11,
		maxammo				= 20,
		maxvelocitykmh		= 44,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNChiHe"] = JPNChiHe,
})
