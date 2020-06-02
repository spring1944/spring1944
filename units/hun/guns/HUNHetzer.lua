local HetzerBase = Tank:New{
	maxDamage			= 1575,
	trackOffset			= 5,
	trackWidth			= 20,
	
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 60,
					slope			= -40,
				},
				rear = {
					thickness		= 20,
					slope			= 13,
				},
				side = {
					thickness 		= 20,
					slope			= -15,
				},
				top = {
					thickness		= 8,
				},
			},
			super = {
				front = {
					thickness		= 60,
					slope			= 60,
				},
				rear = {
					thickness		= 8,
					slope			= 68,
				},
				side = {
					thickness 		= 20,
					slope			= 40,
				},
				top = {
					thickness		= 8,
				},
			},
		},
		soundcategory		= "HUN/Tank",
		maxvelocitykmh		= 40,
	},
}

local HUNHetzer = HetzerBase:New(MediumTank):New(TankDestroyer):New{
	name				= "Sd.Kfz. 138/2 JagdPanzer 38 Hetzer",
	description			= "Turretless Tank Destroyer",
	corpse				= "HUNHetzer_Abandoned",
	buildCostMetal		= 2800,


	weapons = {
		[1] = {
			name				= "kwk75mml48AP",
			maxAngleDif			= 25,
		},
		[2] = {
			name				= "mg42remote",
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		maxammo				= 15,
	},
}

local HUNBergeHetzer = HetzerBase:New(EngineerVehicle):New{
	name				= "Berge Hetzer",
	description			= "Armored recovery vehicle",
	corpse				= "HUNBergeHetzer_Abandoned",
	category			= "HARDVEH", -- we don't want minetrigger, so it can clear mines

	customParams = {
		customanims			= "bergehetzer",
		weapontoggle		= false, -- can't override with nil
	},
}

return lowerkeys({
	["HUNHetzer"] = HUNHetzer,
	["HUNBergeHetzer"] = HUNBergeHetzer,
})
