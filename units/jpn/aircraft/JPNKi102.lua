local JPN_Ki102 = Fighter:New{
	name				= "Ki-102b (Type 4) Assault Plane",
	description			= "Anti-Tank Aircraft",
	buildCostMetal		= 985,
	maxDamage			= 495,
	cruiseAlt			= 1250,
	radarDistance		= 1200,
	maxFuel				= 160,
	iconType			= "bomber",
		
	maxAcc				= 0.702,
	maxAileron			= 0.00375,
	maxBank				= 0.9,
	maxElevator			= 0.00375,
	maxPitch			= 1,
	maxRudder			= 0.0025,
	maxVelocity			= 11.2,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		maxammo				= 18,
		weaponswithammo		= 1,
	},

	weapons = {
		[1] = {
			name				= "Ho40157mm",
			maxAngleDif			= 15,
			onlyTargetCategory	= "SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP",
			badTargetCategory	= "SOFTVEH",
			mainDir				= [[0 -1 16]],
		},
		[2] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir				= [[0 -1 16]],
			slaveTo				= 1, -- TODO: why?
		},	
		[3] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
			mainDir				= [[0 .5 -1]],
			slaveTo				= 1, -- TODO: why?
		},
		[4] = {
			name				= "Te4",
			maxAngleDif			= 50,
			onlyTargetCategory	= "AIR",
			mainDir				= [[0 1 -1]],
		},
		[5] = {
			name 				= "Medium_Tracer",
		},
	},
}


return lowerkeys({
	["JPNKi102"] = JPN_Ki102,
})
