local ITA_ML = InfantryLandingCraft:New{
	name					= "Moto Lance",
	acceleration			= 0.1,
	brakeRate				= 0.5,
	buildCostMetal			= 800,
	maxDamage				= 1550,
	maxReverseVelocity		= 0.685,
	maxVelocity				= 2.2,
	transportCapacity		= 22,
	transportMass			= 1300,
	turnRate				= 55,	
	weapons = {	
		[1] = {
			name				= "BredaM1931AA",
			onlyTargetCategory	= "AIR",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 150,
		},
		[2] = {
			name				= "BredaM1931",
			mainDir				= [[0 0 1]],
			maxAngleDif			= 150,
		}
	},
	customparams = {
		armor_front				= 6,
		armor_rear				= 6,
		armor_side				= 6,
		armor_top				= 6,
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]

	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			"custom:MG_MUZZLEFLASH",
		},
	},
}


return lowerkeys({
	["ITAML"] = ITA_ML,
})
