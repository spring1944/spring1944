local HUN_SchSturmboot = InfantryLandingCraft:New{
	name					= "Schwere Sturmboot 42",
	objectName				= "GER/GERSchSturmboot.s3o",
	corpse					= "GERSchSturmboot_dead",
	script					= "gerschsturmboot.cob",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 400,
	maxDamage				= 950,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 4,
	turnRate				= 165,	

	customparams = {
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
}

return lowerkeys({
	["HUNSchSturmboot"] = HUN_SchSturmboot,
})
