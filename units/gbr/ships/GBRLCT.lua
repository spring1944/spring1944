local GBR_LCT = TankLandingCraftComposite:New{
	name					= "LCT Mk. 4",
	acceleration			= 0.001,
	brakeRate				= 0.001,
	buildCostMetal			= 2100,
	category 				= "LARGESHIP SHIP MINETRIGGER",
	collisionVolumeOffsets	= [[0.0 0.0 0.0]],
	collisionVolumeScales	= [[60.0 100.0 220.0]],
	loadingRadius			= 350,
	unloadSpread			= 10,
	--transportUnloadMethod	= 2,
	maxDamage				= 35000,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 2,
	transportMass			= 27000,
	turnRate				= 35,
	weapons = {
		[1] = {
			name				= "Oerlikon20mmaa",
		},
	},
	customparams = {
		children = {
			"GBRLCSL_Turret_20mm_Left",
			"GBRLCSL_Turret_20mm_Right",
		},
		deathanim = {
			["x"] = {angle = -30, speed = 10},
		},
		customanims = "gbr_lct",
		normaltex = "unittextures/GBRLCT_normals.png",
	},
}

return lowerkeys({
	["GBRLCT"] = GBR_LCT,
})
