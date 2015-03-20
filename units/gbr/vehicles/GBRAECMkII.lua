local GBRAECMkII = HeavyArmouredCar:New{
	name				= "AEC Armoured Car Mk.II",
	acceleration		= 0.03,
	brakeRate			= 0.09,
	buildCostMetal		= 1350,
	maxDamage			= 1270,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "qf6pdr57mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		--[2] = {
			--name				= "qf6pdr57mmhe",
			--mainDir				= [[0 16 1]],
			--maxAngleDif			= 210,
		--},
		[2] = {
			name				= "BESA",
		},
		[3] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 57,
		armor_rear			= 16,
		armor_side			= 30,
		armor_top			= 8,
		maxammo				= 10,
		weaponcost			= 10,
		weaponswithammo		= 1,
		turretturnspeed		= 32, -- 11s for 360
		maxvelocitykmh		= 66,
		
		cegpiece = {
			[2] = "coaxflare",
		},
	}
}

return lowerkeys({
	["GBRAECMkII"] = GBRAECMkII,
})
