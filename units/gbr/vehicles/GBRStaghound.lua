local GBRStaghound = ArmouredCarAA:New{
	name				= "T17E2 Staghound AA",
	acceleration		= 0.047,
	brakeRate			= 0.09,
	buildCostMetal		= 990,
	maxDamage			= 1270,
	maxReverseVelocity	= 2.965,
	maxVelocity			= 5.93,
	trackOffset			= 10,
	trackWidth			= 16,
	turnRate			= 405,

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
		cegpiece = {
			[1] = "flare1",
			[2] = "flare2",
			[3] = "flare1",
		},
	}
}

return lowerkeys({
	["GBRStaghound"] = GBRStaghound,
})
