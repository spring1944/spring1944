local ITASemovente90 = MediumTank:New(TankDestroyer):New(OpenTopped):New{
	name				= "Semovente da 90/53",
	description			= "Heavily Armed Tank Destroyer",
	buildCostMetal		= 3550,
	maxDamage			= 1700,
	trackOffset			= 5,
	trackWidth			= 15,

	weapons = {
		[1] = {
			name				= "Ansaldo90mmL53AP",
			maxAngleDif			= 80,
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 40,
		armor_rear			= 0,
		armor_side			= 25,
		armor_top			= 10,
		maxammo				= 6,
		maxvelocitykmh		= 25,
		exhaust_fx_name			= "diesel_exhaust",
		normaltex			= "",
	},
}

return lowerkeys({
	["ITASemovente90"] = ITASemovente90,
})
