local RUSValentine = LightTank:New{
	name				= "Mk.III Valentine Infantry Tank",
	acceleration		= 0.051,
	brakeRate			= 0.15,
	buildCostMetal		= 2000,
	maxDamage			= 1650,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "qf2pdr40mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "qf2pdr40mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
		},
		[4] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 60,
		armor_rear			= 32,
		armor_side			= 55,
		armor_top			= 20,
		maxammo				= 18,
		weaponcost			= 8,
		turretturnspeed		= 36, -- 10s for 360
		maxvelocitykmh		= 24,
	},
}

return lowerkeys({
	["RUSValentine"] = RUSValentine,
})
