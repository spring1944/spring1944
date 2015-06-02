local US_SC = BoatMother:New{
	name					= "SC-497 Submarine Chaser",
	description				= "Patrol Gunboat",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 2500,
	buildTime				= 2500,
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	corpse					= "USSC_dead",
	mass					= 9800,
	maxDamage				= 9800,
	maxReverseVelocity		= 0.7,
	maxVelocity				= 1.56,
	movementClass			= "BOAT_Medium",
	objectName				= "USSC.s3o",
	soundCategory			= "USBoat",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 300,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory = "US/Boat",
		children = {
			"US_SC_Turret_76mm",
			"US_SC_Turret_20mm_Right",
			"US_SC_Turret_20mm_Left",
			"US_SC_Turret_20mm_Rear",
		},
		deathanim = {
			["z"] = {angle = 30, speed = 20},
		},
	},
}


local US_SC_Turret_20mm_Left = BoatChild:New{
	name					= "Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "USSC_Turret_20mm.s3o",
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 180,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 150,
			mainDir				= [[1 0 0]],
		},
	},
	customparams = {
		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
		facing 					= 3,
	},
}
local US_SC_Turret_20mm_Right = US_SC_Turret_20mm_Left:New{
	weapons = {	
		[1] = {
			mainDir				= [[-1 0 0]],
		},
		[2] = {
			mainDir				= [[-1 0 0]],
		},
	},
	customparams = {
		facing 					= 1,
	},
}
local US_SC_Turret_20mm_Rear = US_SC_Turret_20mm_Left:New{
	weapons = {	
		[1] = {
			mainDir				= [[0 0 1]],
			maxAngleDif			= 270,
		},
		[2] = {
			mainDir				= [[0 0 1]],
			maxAngleDif			= 270,
		},
	},
	customparams = {
		facing 					= 2,
	},
}

local US_SC_Turret_76mm = BoatChild:New{
	name					= "3in Mk 50 Turret",
	description				= "Primary Turret",
	objectName				= "USSC_Turret_76mm.s3o",
  	weapons = {	
		[1] = {
			maxAngleDif			= 270,
			name				= "mk223in50",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 26,
		weaponcost				= 8,
		weaponswithammo			= 1,
		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,
    },
}


return lowerkeys({
	["USSC"] = US_SC,
	["US_SC_Turret_76mm"] = US_SC_Turret_76mm,
	["US_SC_Turret_20mm_Left"] = US_SC_Turret_20mm_Left,
	["US_SC_Turret_20mm_Right"] = US_SC_Turret_20mm_Right,
	["US_SC_Turret_20mm_Rear"] = US_SC_Turret_20mm_Rear,
})