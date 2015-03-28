local SWEPBilM40 = ArmouredCar:New{
	name				= "PBil m/40 Lynx",
	buildCostMetal		= 1085, -- from ITA AB41
	maxDamage			= 780,
	trackOffset			= 10,
	trackWidth			= 13,

	weapons = {
		[1] = {
			name				= "BredaM3520mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "BredaM3520mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "M1919A4Browning",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},-- TODO: Hull MGs?
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 20,
		armor_rear			= 8,
		armor_side			= 10,
		armor_top			= 6,
		maxammo				= 19,
		weaponcost			= 8,
		weaponswithammo		= 2,
		reversemult			= 0.75,
		maxvelocitykmh		= 73,
	}
}

return lowerkeys({
	["SWEPBilM40"] = SWEPBilM40,
})
