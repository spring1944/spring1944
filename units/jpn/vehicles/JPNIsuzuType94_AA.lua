local JPNIsuzuType94_AA = TruckAA:New{
	name				= "Type 94 Isuzu w/ Type 98 20mm AA",
	buildCostMetal		= 1200,
	maxDamage			= 600,
	maxVelocity			= 4.11,
	trackOffset			= 10,
	trackWidth			= 12,

	weapons = {
		[1] = {
			name				= "Type9820mmAA",
		},
	},
	customParams = {
		maxammo				= 19,

	}
}

return lowerkeys({
	["JPNIsuzuType94_AA"] = JPNIsuzuType94_AA,
})
