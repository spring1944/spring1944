local JPN_Daihatsu = InfantryLandingCraft:New{
	name					= "Daihatsu Landing Craft",
	acceleration			= 0.09,
	brakeRate				= 0.5,
	buildCostMetal			= 300,
	maxDamage				= 950,
	maxReverseVelocity		= 0.685,
	maxVelocity				= 1.9,
	transportCapacity		= 40,
	transportMass			= 2000,
	turnRate				= 100,

	customparams = {
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]

	},
}


return lowerkeys({
	["JPNDaihatsu"] = JPN_Daihatsu,
})
