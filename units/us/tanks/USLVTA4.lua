local USLVTA4 = LightTank:New(Amphibian):New{
	name				= "LVT(A)-4",
	description			= "Amphibious Support Tank",
	buildCostMetal		= 1800,
	maxDamage			= 1814,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M875mmHE",
		},
		[2] = {
			name				= "M2BrowningAA",
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 13,
		armor_rear			= 6,
		armor_side			= 8,
		armor_top			= 6,
		slope_front			= 31,
		maxammo				= 9,
		maxvelocitykmh		= 40,
		flagCapRate			= 0.5,
		flagCapType			= 'buoy',
		normaltex			= "unittextures/USLVTA4_normals.dds",
	},
}

return lowerkeys({
	["USLVTA4"] = USLVTA4,
})
