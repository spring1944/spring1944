local JPNHoNiII = LightTank:New(SPArty):New(OpenTopped):New{
	name				= "Type 2 Ho-Ni II",
	buildCostMetal		= 3150,
	maxDamage			= 1630,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type91105mmL24HE",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 0,
		maxammo				= 4,
		maxvelocitykmh		= 38,
		exhaust_fx_name			= "diesel_exhaust",

	},
}

return lowerkeys({
	["JPNHoNiII"] = JPNHoNiII,
})
