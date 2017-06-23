local JPN_Ki43 = Interceptor:New{
	name				= "Ki-43 Hayabusa",
	buildCostMetal		= 985,
	maxDamage			= 235,
		
	maxAcc				= 0.757,
	maxAileron			= 0.0044,
	maxBank				= 1,
	maxElevator			= 0.0031,
	maxPitch			= 1,
	maxRudder			= 0.0043,
	maxVelocity			= 19.3,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		normaltex			= "",
	},

	weapons = {
		[1] = {
			name				= "Type1Ho103",
			maxAngleDif			= 10,
		},
		[2] = {
			name				= "Type1Ho103",
			maxAngleDif			= 10,
			slaveTo				= 1,
		},	
	},
}


return lowerkeys({
	["JPNKi43"] = JPN_Ki43,
})
