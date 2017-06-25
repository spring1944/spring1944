local HUN_LaBo41 = TankLandingCraft:New{
	name					= "Ladungsboot 41",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 2200,
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2,
	transportMass			= 4000,
	turnRate				= 35,	
	customparams = {
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
		normaltex			= "",
	},
}


return lowerkeys({
	["HUNLaBo41"] = HUN_LaBo41,
})
