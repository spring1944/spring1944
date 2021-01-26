local HUN_LaBo41 = TankLandingCraftComposite:New{
	name					= "Ladungsboot 41",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 750,
	loadingRadius			= 250,
	unloadSpread			= 10,
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2,
	transportMass			= 4000,
	turnRate				= 35,	
	
	script = "BoatTransport.lua",
	transportUnloadMethod = 0,
	holdSteady = true,
	--loadingRadius = 150,

	 
	 
	customparams = {
		deathanim = {
			["x"] = {angle = -5, speed = 2.5},
		},
		customanims = "hun_labo",
		
		armlength 	= 98,
		ramplength	= 50,
		colsize		= 40,
		normaltex			= "unittextures/HUNLaBo41_normals.png",
	},
}

return lowerkeys({
	["HUNLaBo41"] = HUN_LaBo41,
})
