local SWEStrvM40SII = LightTank:New{
	name				= "Stridsvagn m/40",
	buildCostMetal		= 1500,
	maxDamage			= 750,
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
		[3] = { -- coax 1
			name				= "M1919A4Browning",
		},
		[4] = { -- coax 2
			name				= "M1919A4Browning",
		},
		[5] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 54, -- 13+35~63d,  13 + 30mm @ 32d gives 81!
		armor_rear			= 18,
		armor_side			= 18,
		armor_top			= 5,
		maxammo				= 18,
		maxvelocitykmh		= 48,
	},
}

return lowerkeys({
	["SWEStrvM40SII"] = SWEStrvM40SII,
})
