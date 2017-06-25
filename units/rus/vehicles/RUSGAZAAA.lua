local RUSGAZAAA = TruckAA:New{
	name				= "M4 GAZ-AAA",
	buildCostMetal		= 750,
	maxDamage			= 600,
	maxVelocity			= 4.11,
	trackOffset			= 10,
	trackWidth			= 12,

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
		normaltex			= "",
	},
}

return lowerkeys({
	["RUSGAZAAA"] = RUSGAZAAA,
})
