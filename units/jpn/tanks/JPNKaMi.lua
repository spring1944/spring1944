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
		maxvelocitykmh		= 37,
	},
}

return lowerkeys({
	["JPNKaMi"] = JPNKaMi,
})
