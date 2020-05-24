local StrvM42Base = {
	maxDamage			= 2250,
	trackOffset			= 5,
	trackWidth			= 20,


	customParams = {
		armor_front			= 55,
		armor_rear			= 20,
		armor_side			= 25,
		armor_top			= 9,
		slope_front			= 28,
		slope_rear			= -29,
		slope_side			= 30,
	},
}

local SWEStrvM42 = MediumTank:New(StrvM42Base):New{
	name				= "Stridsvagn m/42",
	buildCostMetal		= 2520,
	weapons = {
		[1] = {
			name				= "SWE75mmL34AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "SWE75mmL34HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax 1
			name				= "ksp_m1939",
		},
		[4] = { -- coax 2
			name				= "ksp_m1939",
		},
		[5] = { -- back turret
			name				= "ksp_m1939",
		},
		[6] = { -- hull
			name				= "ksp_m1939",
			maxAngleDif			= 50,
		},
		[7] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		maxammo				= 15,
		maxvelocitykmh		= 42,
	},
}

local SWEBBVM42 = EngineerVehicle:New(MediumTank):New(StrvM42Base):New{
	name				= "Bärgningsbandvagn m/42",
	category			= "HARDVEH", -- don't trigger mines
}

return lowerkeys({
	["SWEStrvM42"] = SWEStrvM42,
	["SWEBBVM42"] = SWEBBVM42,
})
