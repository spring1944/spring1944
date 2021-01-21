local HUN_SchSturmboot = InfantryLandingCraftComposite:New{
	name					= "Schwere Sturmboot 42",
	objectName				= "GER/GERSchSturmboot.s3o",
	corpse					= "GERSchSturmboot_dead",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 400,
	maxDamage				= 950,
	maxReverseVelocity		= 0.6,
	maxVelocity				= 4,
	turnRate				= 65,	

	customparams = {
		deathanim = {
			["z"] = {angle = 30, speed = 10},
		},
		normaltex			= "unittextures/GERSchSturmboot_normals.png",
	},
}

return lowerkeys({
	["HUNSchSturmboot"] = HUN_SchSturmboot,
})
