local ITA_Vedetta = BoatMother:New{
	name					= "Classe Vedetta",
	description				= "Patrol Gunboat",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 2200,
	buildTime				= 2200,
	collisionVolumeOffsets	= [[0.0 -12.5 0.0]],
	collisionVolumeScales	= [[24.0 11.0 150.0]],
	corpse					= "ITAVedetta_dead",
	mass					= 7000,
	maxDamage				= 7000,
	maxReverseVelocity		= 0.7,
	maxVelocity				= 1.56,
	movementClass			= "BOAT_LightPatrol",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 140,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Ansaldo76mmL40HE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory		= "ITA/Boat",
		children = {
			"ITAVedetta_Turret_76mm", 
			"ITAVedetta_Turret_MG", 
			"ITAVedetta_Turret_MG", 
			"ITAVedetta_Turret_MG", 
		},
		--[[deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
}

local ITA_Vedetta_Turret_76mm = BoatChild:New{
	name					= "76mm Turret",
	description				= "Primary Turret",
	weapons = {	
		[1] = {
			name				= "Ansaldo76mmL40HE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 7,
		weaponcost				= 18, -- !?
		weaponswithammo			= 1,
		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 15,
		elevationspeed			= 15,
	},
}

local ITA_Vedetta_Turret_MG = BoatChild:New{
	name					= "MG Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "BredaM1931AA",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 200,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "BredaM1931",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			maxAngleDif			= 200,
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 60,
		elevationspeed			= 60,
		facing					= 2,
		aaweapon				= 1,
	},
}


return lowerkeys({
	["ITAVedetta"] = ITA_Vedetta,
	["ITAVedetta_Turret_76mm"] = ITA_Vedetta_Turret_76mm,
	["ITAVedetta_Turret_MG"] = ITA_Vedetta_Turret_MG,
})
