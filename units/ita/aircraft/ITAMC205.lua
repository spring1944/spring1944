local ITA_MC205 = FighterBomber:New{
	name				= "Macchi MC205 Veltro",
	buildCostMetal		= 3375,
	maxDamage			= 340,
		
	maxAcc				= 0.742,
	maxAileron			= 0.0054,
	maxBank				= 0.9,
	maxRudder			= 0.005,
	maxVelocity			= 17.5,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
		normaltex			= "",
	},

	weapons = {
		[1] = {
			name				= "Bomb160kg",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= "lastBomb160kg",
			maxAngleDif			= 20,
			mainDir				= [[0 0 1]],
			slaveTo				= 1,
		},
		[3] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
		},
		[4] = {
			name				= "BredaSafat05",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},	
		[5] = {
			name				= "BredaSafat03",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[6] = {
			name				= "BredaSafat03",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
	},
}


return lowerkeys({
	["ITAMC205"] = ITA_MC205,
})
