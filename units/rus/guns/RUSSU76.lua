local RUSSU76 = Tank:New(AssaultGun):New(OpenTopped):New{
	name				= "SU-76",
	acceleration		= 0.051,
	brakeRate			= 0.15,
	buildCostMetal		= 1740,
	maxDamage			= 1120,
	maxReverseVelocity	= 1.665,
	maxVelocity			= 3.33,
	turnRate			= 160,
	trackOffset			= 3,
	trackType			= "T60-70-SU76",
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
		weaponcost			= 12,
	},
}

return lowerkeys({
	["RUSSU76"] = RUSSU76,
})
