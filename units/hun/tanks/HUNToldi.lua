local HUNToldiII = LightTank:New{
	name				= "38.M Toldi II",
	buildCostMetal		= 1200,
	corpse			= "HUNToldiII_Abandoned",
	maxDamage			= 850,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "Solothurn_36MAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Solothurn_36MHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},

		[3] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 13,
		armor_rear			= 13,
		armor_side			= 13,
		armor_top			= 5,
		slope_front			= 30,
		slope_rear			= -33,
		slope_side			= 15,
		maxammo				= 24,
		maxvelocitykmh		= 48,
		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 20,

	},
}

local HUNToldiIIA = HUNToldiII:New{
	name		= "42.M Toldi IIA",
	buildCostMetal	= 1500,
	corpse			= "HUNToldiIIA_Abandoned",
	maxDamage	= 900,
	weapons = {
--		[1] = {
--			name				= "Bofors_m38AP",
--			mainDir				= [[0 16 1]],
--			maxAngleDif			= 210,
--		},
--		[2] = {
--			name				= "Bofors_m38HE",
--			mainDir				= [[0 16 1]],
--			maxAngleDif			= 210,
--		},

		[1] = {
			name				= "Mavag_37_42MAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Mavag_37_42MHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax 1
			name				= "gebauer_1934_37m",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 23,
	},
}

return lowerkeys({
	["HUNToldiII"] = HUNToldiII,
	["HUNToldiIIA"] = HUNToldiIIA,
})
