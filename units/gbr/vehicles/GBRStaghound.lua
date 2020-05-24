local GBRStaghound = ArmouredCarAA:New{
	name				= "T17E2 Staghound AA",
	buildCostMetal		= 990,
	maxDamage			= 1270,
	trackOffset			= 10,
	trackWidth			= 16,

	weapons = {
		[1] = {
			name				= "M2browningaa",
		},
		[2] = {
			name				= "M2browningaa",
		},
		[3] = {
			name				= "M2browning",
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 22,
		armor_rear			= 9,
		armor_side			= 19,
		armor_top			= 13,
		slope_front			= 47,
		slope_rear			= 28,
		slope_side			= -9,
		turretturnspeed		= 43, -- may find this too slow in game
		maxvelocitykmh		= 89,

	}
}

return lowerkeys({
	["GBRStaghound"] = GBRStaghound,
})
