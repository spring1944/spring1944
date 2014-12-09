local ITA_Gabbiano = BoatMother:New{
	name					= "Classe Gabbiano",
	description				= "Corvette",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 10000,
	category 				= "LARGESHIP SHIP MINETRIGGER",
	collisionVolumeOffsets	= [[0.0 -12.5 0.0]],
	collisionVolumeScales	= [[24.0 11.0 150.0]],
	maxDamage				= 67000,
	maxVelocity				= 1.8,
	transportCapacity		= 6, -- 6 x 1fpu turrets
	turnRate				= 25,	
	weapons = {	
		[1] = {
			name				= "ita450mmtorpedo",
			onlyTargetCategory	= "LARGESHIP",
			mainDir				= [[1 0 1]],
			maxAngleDif			= 90,
		},
		[2] = {
			name				= "ita450mmtorpedo",
			onlyTargetCategory	= "LARGESHIP",
			mainDir				= [[-1 0 1]],
			maxAngleDif			= 90,
		},
	},
	customparams = {
		maxammo				= 2,
		weaponcost			= 40,
		weaponswithammo		= 2,
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

local ITA_Gabbiano_Turret_100mm = BoatChild:New{
	name					= "100mm Turret",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "OTO100mmL47HE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 30,
		weaponcost				= 18,
		weaponswithammo			= 1,
		barrelrecoildist		= 7,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 25,
		elevationspeed			= 25,
    },
}

local ITA_Gabbiano_Turret_20mm = BoatChild:New{
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
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		aaweapon				= 1,
		weaponcost				= 3,
		weaponswithammo			= 2,
		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		fearlimit				= 25,
    },
}

local ITA_Gabbiano_Turret_Twin20mm = BoatChild:New{
	name					= "Twin 20mm Turret",
	description				= "AA Turret",
  	weapons = {	
		[1] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			mainDir		= [[0 0 -1]],
			slaveTo				= 1,
		},
		[3] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir		= [[0 0 -1]],
		},
		[4] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir		= [[0 0 -1]],
			slaveTo				= 3,
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		aaweapon				= 1,
		weaponcost				= 3,
		weaponswithammo			= 4,
		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 45,
		fearlimit				= 25,
		facing					= 2,
    },
}

return lowerkeys({
	["ITAGabbiano"] = ITA_Gabbiano,
	["ITAGabbiano_Turret_100mm"] = ITA_Gabbiano_Turret_100mm,
	["ITAGabbiano_Turret_20mm"] = ITA_Gabbiano_Turret_20mm,
	["ITAGabbiano_Turret_Twin20mm"] = ITA_Gabbiano_Turret_Twin20mm,
})
