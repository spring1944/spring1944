local GBR_LCA = InfantryLandingCraft:New{
	name					= "Landing Craft, Assault",
	acceleration			= 0.009,
	brakeRate				= 0.5,
	buildCostMetal			= 500,
	maxDamage				= 914,
	maxReverseVelocity		= 0.685,
	maxVelocity				= 2,
	turnRate				= 100,	
	weapons = {	
		[1] = {
			name				= "bren",
			maxAngleDif			= 90,
		},
	},
	customparams = {
		armor_front				= 28.5, -- 3/8in for doors, + 3/4in? ramp
		armor_rear				= 19,
		armor_side				= 19, -- wiki says 3/4in sides
		armor_top				= 6, -- 1/4in deck
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
		normaltex			= "",
	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			"custom:MG_MUZZLEFLASH",
		},
	},
}


return lowerkeys({
	["GBRLCA"] = GBR_LCA,
})
