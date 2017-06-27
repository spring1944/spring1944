local HUNHetzer = MediumTank:New(TankDestroyer):New{
	name				= "Sd.Kfz. 138/2 JagdPanzer 38 Hetzer",
	description			= "Turretless Tank Destroyer",
	corpse				= "HUNHetzer_Abandoned",
	buildCostMetal		= 3500,
	maxDamage			= 1575,
	trackOffset			= 5,
	trackWidth			= 20,

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
		armor_front			= 100,
		armor_rear			= 21,
		armor_side			= 26,
		armor_top			= 8,
		maxammo				= 15,
		soundcategory		= "HUN/Tank",
		maxvelocitykmh		= 40,

	},
}

local HUNBergeHetzer = EngineerVehicle:New{
	name				= "Berge Hetzer",
	description			= "Armored recovery vehicle",
	corpse				= "HUNBergeHetzer_Abandoned",
	category			= "HARDVEH",
	maxDamage			= 1575,
	trackOffset			= 5,
	trackWidth			= 20,
	customParams = {
		armor_front			= 100,
		armor_rear			= 21,
		armor_side			= 26,
		armor_top			= 0,
		maxvelocitykmh		= 40,
		soundcategory		= "HUN/Tank",
		customanims			= "bergehetzer",

	},
}

return lowerkeys({
	["HUNHetzer"] = HUNHetzer,
	["HUNBergeHetzer"] = HUNBergeHetzer,
})
