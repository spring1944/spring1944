local ITA_MAS = ArmedBoat:New{
	name					= "MAS 500 type",
	description				= "Motor Torpedo boat",
	acceleration			= 0.3,
	brakeRate				= 0.3,
	buildCostMetal			= 1000,
	collisionVolumeOffsets	= [[0.0 -16.0 -15.0]],
	collisionVolumeScales	= [[40.0 20.0 260.0]],
	maxDamage				= 2400,
	maxVelocity				= 4.3, -- 43 knots
	transportCapacity		= 1, -- 1 x 1fpu turrets
	turnRate				= 55,	
	weapons = {	
		[1] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory		= "ITA/Boat",
		children = {
			"ITAMS_Turret_20mm_Rear", 
		},
		deathanim = {
			["z"] = {angle = 45, speed = -30},
		},
	},
}


return lowerkeys({
	["ITAMAS"] = ITA_MAS,
})
