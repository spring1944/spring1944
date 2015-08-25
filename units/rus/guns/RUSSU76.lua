local RUSSU76 = LightTank:New(AssaultGun):New(OpenTopped):New{
	name				= "SU-76",
	buildCostMetal		= 1740,
	maxDamage			= 1120,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "ZiS376mmAP",
			maxAngleDif			= 12,
		},
		[2] = {
			name				= "ZiS376mmHE",
			maxAngleDif			= 12,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 29,
		armor_rear			= 17,
		armor_side			= 12,
		armor_top			= 7,
		maxammo				= 11,
		maxvelocitykmh		= 45,
	},
}

return lowerkeys({
	["RUSSU76"] = RUSSU76,
})
