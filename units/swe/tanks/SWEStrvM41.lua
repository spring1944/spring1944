local SWEStrvM41 = LightTank:New{
	name				= "Stridsvagn m/41 SII",
	buildCostMetal		= 2000,
	maxDamage			= 1100,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "M637mmAP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "M637mmHE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax
			name				= "M1919A4Browning",
		},
		[4] = { -- hull
			name				= "M1919A4Browning",
			maxAngleDif			= 50,
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = { -- TODO: armour values are made up based on 'better than m/40'
		armor_front			= 57,
		armor_rear			= 20,
		armor_side			= 24,
		armor_top			= 8,
		maxammo				= 15,
		maxvelocitykmh		= 42,
	},
}

return lowerkeys({
	["SWEStrvM41"] = SWEStrvM41,
})
