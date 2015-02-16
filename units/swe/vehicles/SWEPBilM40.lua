local SWEPBilM40 = ArmouredCar:New{
	name				= "PBil m/40 Lynx",
	description			= "Light Armoured Car",
	acceleration		= 0.058,
	brakeRate			= 0.195,
	buildCostMetal		= 1085, -- from ITA AB41
	maxDamage			= 780,
	maxReverseVelocity	= 2.905,
	maxVelocity			= 5.81,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

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
		armor_front			= 13,
		armor_rear			= 9,
		armor_side			= 10,
		armor_top			= 6,
		maxammo				= 19,
		weaponcost			= 8,
		weaponswithammo		= 2,
	}
}

return lowerkeys({
	["SWEPBilM40"] = SWEPBilM40,
})
