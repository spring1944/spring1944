local JPNHoRo = Tank:New(AssaultGun):New(OpenTopped):New{
	name				= "Type 4 Ho-Ro",
	description			= "Heavy Howitzer Assault Gun",
	acceleration		= 0.041,
	brakeRate			= 0.15,
	buildCostMetal		= 3450,
	maxDamage			= 1630,
	maxReverseVelocity	= 1.5,
	maxVelocity			= 3,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type38150mmL11HE",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= "Type38150mmL11Smoke",
			maxAngleDif			= 20,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 0,
		maxammo				= 4,
		weaponcost			= 25,
		weapontoggle		= "smoke",
		canfiresmoke		= true,
	},
}

return lowerkeys({
	["JPNHoRo"] = JPNHoRo,
})
