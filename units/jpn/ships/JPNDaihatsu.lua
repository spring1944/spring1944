local JPN_Daihatsu = InfantryLandingCraft:New{
	name					= "Daihatsu Landing Craft",
	acceleration			= 0.9,
	brakeRate				= 0.5,
	buildCostMetal			= 500,
	maxDamage				= 950,
	maxReverseVelocity		= 0.685,
	maxVelocity				= 2,
	transportCapacity		= 40,
	transportMass			= 2000,
	turnRate				= 100,

	customparams = {
		-- TODO: Was Daihatsu even armoured?
	    armor_front				= 6,
		armor_rear				= 6,
		armor_side				= 6,
		armor_top				= 6,
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
}


return lowerkeys({
	["JPNDaihatsu"] = JPN_Daihatsu,
})
