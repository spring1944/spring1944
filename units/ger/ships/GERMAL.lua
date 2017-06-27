local GER_MAL = ArmedBoat:New{
	name					= "Marineartillerieleichter",
	description				= "Landing Fire Support Ship",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 8000,
	collisionVolumeOffsets	= [[0.0 -24.0 80.0]],
	collisionVolumeScales	= [[60.0 20.0 230.0]],
	iconType			= "artyboat",
	maxDamage				= 27200,
	maxReverseVelocity		= 0.55,
	maxVelocity				= 1.6,
	movementClass			= "BOAT_LandingCraft",
	transportCapacity		= 5, -- 5 x 1fpu turrets
	turnRate				= 120,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "sk88mmc30",
		},
	},
	customparams = {
		children = {
			"GERMAL_Turret_105mm", 
			"GERMAL_Turret_105mm", 
			"GERMAL_Turret_Quad20mm",
			"GERMAL_Turret_37mm",
			"GERMAL_Turret_37mm",
		},
		deathanim = {
			["x"] = {angle = -10, speed = 5},
		},

	},
}

local GER_MAL_Turret_105mm = PartiallyEnclosedBoatTurret:New{ --
	name					= "105mm Turret", -- TODO: should be for MAL 2?
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "sk88mmc30",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 7,
		barrelrecoilspeed		= 5,
		turretturnspeed			= 12,
		elevationspeed			= 15,

    },
}

local GER_MAL_Turret_Quad20mm = OpenBoatTurret:New{
	name					= "Flakvierling 20mm Turret",
	description				= "Quad 20mm AA Turret",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
		[3] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
		[4] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			slaveTo				= 1,
		},
		[5] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
		},
		[6] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			slaveTo				= 5,
		},
		[7] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			slaveTo				= 5,
		},
		[8] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			slaveTo				= 5,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,

    },
}

local GER_MAL_Turret_37mm = OpenBoatTurret:New{
	name					= "37mm Turret",
	description				= "37mm AA Turret",
  	weapons = {	
		[1] = {
			name				= "flak4337mmaa",
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "flak4337mmhe",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 30,
		elevationspeed			= 30,
		aaweapon				= 1,

    },
}

return lowerkeys({
	["GERMAL"] = GER_MAL,
	["GERMAL_Turret_105mm"] = GER_MAL_Turret_105mm,
	["GERMAL_Turret_Quad20mm"] = GER_MAL_Turret_Quad20mm,
	["GERMAL_Turret_37mm"] = GER_MAL_Turret_37mm,
})
