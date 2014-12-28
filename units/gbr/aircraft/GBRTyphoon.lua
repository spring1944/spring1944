local GBR_Typhoon = Fighter:New{
	name				= "Hawker Typhoon Mk.IB",
	description			= "Attack Fighter",
	buildCostMetal		= 3000,
	cruiseAlt			= 900,
	maxDamage			= 444.5,
		
	maxAcc				= 0.648,
	maxAileron			= 0.0044,
	maxBank				= 0.9,
	maxElevator			= 0.0031,
	maxPitch			= 1,
	maxRudder			= 0.0023,
	maxVelocity			= 14,
	turnRate			= 50,

	customParams = {
		enginesound			= "spitfireb-",
		enginesoundnr		= 18,
		maxammo				= 8,
		weaponcost			= -1,
		weaponswithammo		= 2,
	},

	weapons = {
		[1] = {
			name				= "HVARRocket",
			maxAngleDif			= 30,
			onlyTargetCategory	= "HARDVEH OPENVEH SHIP LARGESHIP",
		},
		[2] = {
			name				= "HVARRocket",
			maxAngleDif			= 30,
			onlyTargetCategory	= "HARDVEH OPENVEH SHIP LARGESHIP",
			slaveTo				= 1,
		},
		[3] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[4] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},	
		[5] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[6] = {
			name				= "HS40420mm",
			maxAngleDif			= 10,
			slaveTo				= 3,
		},
		[7] = {
			name 				= "Large_Tracer",
		},
	},
}


return lowerkeys({
	["GBRTyphoon"] = GBR_Typhoon,
})
