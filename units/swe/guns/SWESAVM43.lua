local SWESAVM43 = LightTank:New(AssaultGun):New{
	name				= "SAV m/43",
	buildCostMetal		= 1740,
	corpse			= "SWESAVM43_Abandoned",
	maxDamage			= 1200,
	turnRate			= 160,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Ansaldo75mmL34AP",
			maxAngleDif			= 15,
		},
		[2] = {
			name				= "Ansaldo75mmL34HE",
			maxAngleDif			= 15,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 55,
		armor_rear			= 15,
		armor_side			= 13,
		armor_top			= 13,
		maxammo				= 11,
		maxvelocitykmh		= 43,

	},
}

return lowerkeys({
	["SWESAVM43"] = SWESAVM43,
})
