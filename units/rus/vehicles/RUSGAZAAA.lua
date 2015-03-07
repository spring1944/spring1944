local RUSGAZAAA = TruckAA:New{
	name				= "M4 GAZ-AAA",
	acceleration		= 0.065,
	brakeRate			= 0.195,
	buildCostMetal		= 750,
	maxDamage			= 600,
	maxReverseVelocity	= 2.055,
	maxVelocity			= 4.11,
	trackOffset			= 10,
	trackWidth			= 12,
	turnRate			= 400,

	weapons = {
		[1] = {
			name				= "MaximAA",
		},
		[2] = {
			name				= "MaximAA",
			slaveTo				= 1,
		},
		[3] = {
			name				= "MaximAA",
			slaveTo				= 1,
		},
		[4] = {
			name				= "MaximAA",
			slaveTo				= 1,
		},
	},
	customParams = {
		cegpiece = {
			[1] = "flare1",
			[2] = "flare2",
			[3] = "flare3",
			[4] = "flare4",
		},
	}
}

return lowerkeys({
	["RUSGAZAAA"] = RUSGAZAAA,
})
