local GBRWasp = LightTank:New{
	name				= "Wasp Mk.II",
	description			= "Universal Carrier Flamethrower",
	buildCostMetal		= 935,
	iconType			= "flametank",
	maxDamage			= 431,
	trackOffset			= 10,
	trackWidth			= 13,
	movementClass		= "TANK_Light", -- tracked so should be better at slopes than wheeled light AFVs

	weapons = {
		[1] = {
			name				= "waspflamethrower",
			maxAngleDif			= 15,
			mainDir				= [[0 0.02 1]],
		},
		[2] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armour = {
			base = {
				front = {
					thickness		= 10,
				},
				rear = {
					thickness		= 8,
				},
				side = {
					thickness 		= 8,
				},
				top = {
					thickness		= 0,
				},
			},
		},
		maxammo				= 7,
		maxvelocitykmh		= 48,

	}
}

return lowerkeys({
	["GBRWasp"] = GBRWasp,
})
