local GBRShermanFirefly = MediumTank:New{
	name				= "Sherman Mk. Vc Firefly",
	description			= "Upgunned Medium Tank",
	buildCostMetal		= 4000,
	maxDamage			= 3270,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF17pdrMkVIAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "QF17pdrMkVIHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
		},
		[4] = {
			name				= "BESA",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 30,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 51,
		armor_rear			= 38,
		armor_side			= 38,
		armor_top			= 20,
		slope_front			= 55,
		slope_rear			= 22,
		maxammo				= 14,
		turretturnspeed		= 19, 
		maxvelocitykmh		= 40,
		normaltex			= "unittextures/GBRShermans_normals.dds",
	},
}

return lowerkeys({
	["GBRShermanFirefly"] = GBRShermanFirefly,
})
