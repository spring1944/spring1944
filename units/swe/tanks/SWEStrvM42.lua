local StrvM42Base = {
	maxDamage			= 2250,
	trackOffset			= 5,
	trackWidth			= 20,


	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 55,
					slope			= 28,
				},
				rear = {
					thickness		= 20,
					slope			= -29,
				},
				side = {
					thickness 		= 25,
					slope			= 30,
				},
				top = {
					thickness		= 9,
				},
			},
		},
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
		armour = {
			turret = {
				front = {
					thickness		= 55,
					slope			= 43,
				},
				rear = {
					thickness		= 25,
					slope			= 7,
				},
				side = {
					thickness 		= 30,
					slope			= 5,
				},
				top = {
					thickness		= 10,
				},
			},
		},
		maxammo				= 15,
		maxvelocitykmh		= 42,
		normaltex			= "unittextures/SWEStrvM42_normals.png",
	},
}

local SWEBBVM42 = EngineerVehicle:New(MediumTank):New(StrvM42Base):New{
	name				= "Bärgningsbandvagn m/42",
	category			= "HARDVEH", -- don't trigger mines
	customParams = {
		normaltex			= "unittextures/SWEBBVM42_normals.png",
	},
}

return lowerkeys({
	["SWEStrvM42"] = SWEStrvM42,
	["SWEBBVM42"] = SWEBBVM42,
})
