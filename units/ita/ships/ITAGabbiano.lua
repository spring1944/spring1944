local ITA_Gabbiano = ArmedBoat:New{
	name					= "Classe Gabbiano",
	description				= "Corvette",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 15000,
	category				= "LARGESHIP SHIP MINETRIGGER",
	collisionVolumeOffsets	= [[0.0 -12.5 0.0]],
	collisionVolumeScales	= [[24.0 11.0 150.0]],
	maxDamage				= 67000,
	maxVelocity				= 1.8,
	transportCapacity		= 6, -- 6 x 1fpu turrets
	turnRate				= 25,	
	weapons = {	
		[1] = {
			name				= "OTO100mmL47HE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory		= "ITA/Boat",
		children = {
			"ITAGabbiano_Turret_100mm", 
			"ITAGabbiano_Turret_20mm", 
			"ITAGabbiano_Turret_20mm", 
			"ITAGabbiano_Turret_20mm", 
			"ITAGabbiano_Turret_Twin20mm",
			"ITAGabbiano_Turret_Twin20mm",
		},
		deathanim = {
			["z"] = {angle = -45, speed = 10},
		},
	},
}

local ITA_Gabbiano_Turret_100mm = OpenBoatTurret:New{
	name					= "100mm Turret",
	description				= "Primary Turret",
	weapons = {	
		[1] = {
			name				= "OTO100mmL47HE",
			maxAngleDif			= 270,		},
	},
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 25,
		elevationspeed			= 25,
	},
}

local ITA_Gabbiano_Turret_20mm = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "AA Turret",
	weapons = {	
		[1] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
    },
}

local ITA_Gabbiano_Turret_Twin20mm = OpenBoatTurret:New{
	name					= "Twin 20mm Turret",
	description				= "AA Turret",
	weapons = {	
		[1] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
			slaveTo				= 1,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 45,
		facing					= 2,
		aaweapon				= 1,
    },
}

return lowerkeys({
	["ITAGabbiano"] = ITA_Gabbiano,
	["ITAGabbiano_Turret_100mm"] = ITA_Gabbiano_Turret_100mm,
	["ITAGabbiano_Turret_20mm"] = ITA_Gabbiano_Turret_20mm,
	["ITAGabbiano_Turret_Twin20mm"] = ITA_Gabbiano_Turret_Twin20mm,
})
