local GER_MAL = BoatMother:New{
	name					= "Marineartillerieleichter",
	description				= "Landing Fire Support Ship",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 8000,
	buildTime				= 8000,
	collisionVolumeOffsets	= [[0.0 -24.0 80.0]],
	collisionVolumeScales	= [[60.0 20.0 230.0]],
	corpse					= "GERMAL_dead",
	mass					= 27200,
	maxDamage				= 27200,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 1.6,
	movementClass			= "BOAT_LandingCraft",
	objectName				= "GERMAL.s3o",
	soundCategory			= "GERBoat",
	transportCapacity		= 5, -- 5 x 1fpu turrets
	turnRate				= 120,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "sk88mmc30",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"GER_MAL_Turret_105mm", 
			"GER_MAL_Turret_105mm", 
			"GER_MAL_Turret_Quad20mm",
			"GER_MAL_Turret_37mm",
			"GER_MAL_Turret_37mm",
		},
		deathanim = {
			["x"] = {angle = -10, speed = 5},
		},
	},
}

local GER_MAL_Turret_105mm = BoatChild:New{ --
	name					= "105mm Turret", -- TODO: should be for MAL 2?
	description				= "Primary Turret",
	objectName				= "GERMAL_Turret_105mm.s3o",
  	weapons = {	
		[1] = {
			name				= "sk88mmc30",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    maxammo					= 26,
		weaponcost				= 20,
		weaponswithammo			= 1,
		barrelrecoildist		= 7,
		barrelrecoilspeed		= 5,
		turretturnspeed			= 12,
		elevationspeed			= 15,
		fearlimit				= 15, -- 3/4 enclosed
    },
}

local GER_MAL_Turret_Quad20mm = BoatChild:New{
	name					= "Flakvierling 20mm Turret",
	description				= "Quad 20mm AA Turret",
	objectName				= "GERMAL_Turret_Quad20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			slaveTo				= 1,
		},
		[3] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			slaveTo				= 1,
		},
		[4] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			slaveTo				= 1,
		},
		[5] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[6] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			slaveTo				= 5,
		},
		[7] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			slaveTo				= 5,
		},
		[8] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			slaveTo				= 5,
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		weaponcost				= 2,
		weaponswithammo			= 8,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
    },
}

local GER_MAL_Turret_37mm = BoatChild:New{
	name					= "37mm Turret",
	description				= "37mm AA Turret",
	objectName				= "GERMAL_Turret_37mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak4337mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "flak4337mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 270,
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		weaponcost				= 2,
		weaponswithammo			= 2,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 30,
		aaweapon				= 1,
		fearlimit				= 25,
    },
}

return lowerkeys({
	["GERMAL"] = GER_MAL,
	["GER_MAL_Turret_105mm"] = GER_MAL_Turret_105mm,
	["GER_MAL_Turret_Quad20mm"] = GER_MAL_Turret_Quad20mm,
	["GER_MAL_Turret_37mm"] = GER_MAL_Turret_37mm,
})
