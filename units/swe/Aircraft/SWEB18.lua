local SWEB18 = Fighter:New{
	name				= "SAAB T 18", --ATM pure copy of Ki-102b (Type 4) Assault Plane
	description			= "Anti-Tank & Anti-Shipping Aircraft",
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

	script				= "jpnki102.cob", -- TODO: LUS!
	
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
			mainDir				= [[0 -1 16]],
		},
		[2] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
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
			mainDir				= [[0 1 -1]],
		},
	},
}


return lowerkeys({
	["SWEB18"] = SWEB18,
})
