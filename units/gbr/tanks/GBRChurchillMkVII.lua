local GBRChurchillMkVII = HeavyTank:New{
	name				= "A22F Churchill Mk. VII",
	description			= "Heavily Armoured All-Terrain Support Tank",
	buildCostMetal		= 5800,
	maxDamage			= 4060,
	movementClass		= "TANK_Goat",
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "QF75mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "QF75mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
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
		armour = {
			base = {
				front = {
					thickness		= 152,
					slope			= 1,
				},
				rear = {
					thickness		= 51,
					slope			= 1,
				},
				side = {
					thickness 		= 95,
				},
				top = {
					thickness		= 16,
				},
			},
			turret = {
				front = {
					thickness		= 152,
					slope			= 1,
				},
				rear = {
					thickness		= 95,
					slope			= 1,
				},
				side = {
					thickness 		= 95,
					slope			= 0,
				},
				top = {
					thickness		= 20,
				},
			},
		},
		maxammo				= 14,
		turretturnspeed		= 24, -- 15s for 360
		maxvelocitykmh		= 24,
		normaltex			= "unittextures/GBRChurchillMkVII_normals.dds",
	},
}

return lowerkeys({
	["GBRChurchillMkVII"] = GBRChurchillMkVII,
})
