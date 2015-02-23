local JPNIsuzuType94_AA = TruckAA:New{
	name				= "Type 94 Isuzu w/ Type 98 20mm AA",
	acceleration		= 0.065,
	brakeRate			= 0.195,
	buildCostMetal		= 1200,
	maxDamage			= 600,
	maxReverseVelocity	= 2.055,
	maxVelocity			= 4.11,
	trackOffset			= 10,
	trackWidth			= 12,
	turnRate			= 400,

	weapons = {
		[1] = {
			name				= "Type9820mmAA",
		},
	},
	customParams = {
		maxammo				= 19,
		weaponcost			= 2,
		weaponswithammo		= 1,
	}
}

return lowerkeys({
	["JPNIsuzuType94_AA"] = JPNIsuzuType94_AA,
})
