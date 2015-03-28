local JPNKaMi = LightTank:New(Amphibian):New{
	name				= "Type 2 Ka-Mi",
	description			= "Amphibious Light Tank",
	buildCostMetal		= 1150,
	maxDamage			= 1250,
	trackOffset			= 7,
	trackWidth			= 16,

	weapons = {
		[1] = {
			name				= "Type137mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "Type137mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- bow MG
			name				= "Type97MG",
		},
		[4] = { -- Rear Turret MG
			name				= "Type97MG",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 8,
		armor_side			= 14,
		armor_top			= 6,
		maxammo				= 15,
		weaponcost			= 8,
		maxvelocitykmh		= 37,
		
		cegpiece = {
			[3] = "bow_mg_flare",
			[4] = "turret_mg_flare",
		},
	},
}

return lowerkeys({
	["JPNKaMi"] = JPNKaMi,
})
