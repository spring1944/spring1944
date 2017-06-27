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
		armor_front			= 25,
		armor_rear			= 16,
		armor_side			= 19,
		armor_top			= 13,
		turretturnspeed		= 43, -- may find this too slow in game
		maxvelocitykmh		= 89,

	}
}

return lowerkeys({
	["GBRStaghound"] = GBRStaghound,
})
