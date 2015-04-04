local SWEPBilM31 = ArmouredCarAA:New{
	name				= "PBil m/31 w/ 20mm Bofors m/40",
	buildCostMetal		= 990,
	maxDamage			= 420,
	trackOffset			= 10,
	trackWidth			= 16,

	weapons = {
		[1] = {
			name				= "flak3820mmaa",
		},
		[2] = {
			name				= "vickers", -- TODO: ksp m/36
			maxAngleDif			= 15,
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 6,
		armor_rear			= 6,
		armor_side			= 16,
		armor_top			= 0,
		maxammo				= 19,
		maxvelocitykmh		= 60,
		
		cegpiece = {
			[1] = "flare",
			[2] = "bow_mg_flare",
		},
	}
}

return lowerkeys({
	["SWEPBilM31"] = SWEPBilM31,
})
