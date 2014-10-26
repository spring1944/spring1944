local GER_RBoot = BoatMother:New{
	name					= "Raumboot",
	description				= "Minesweeper (light patrol ship)",
	acceleration			= 0.2,
	brakeRate				= 0.15,
	buildCostMetal			= 2170,
	buildTime				= 2170,
	collisionVolumeOffsets	= [[0.0 -16.0 -15.0]],
	collisionVolumeScales	= [[40.0 20.0 260.0]],
	corpse					= "GERRBoot_dead",
	mass					= 16000,
	maxDamage				= 16000,
	maxReverseVelocity		= 1.37,
	maxVelocity				= 2.74,
	movementClass			= "BOAT_LightPatrol",
	objectName				= "GERRboot.s3o",
	soundCategory			= "GERBoat",
	transportCapacity		= 3, -- 3 x 1fpu turrets
	turnRate				= 205,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "flak4337mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		soundcategory = "GER/Boat",
		children = {
			"GER_RBoot_Turret_37mm", 
			"GER_RBoot_Turret_20mm",
			"GER_RBoot_Turret_20mm",
		},
		deathanim = {
			["z"] = {angle = 45, speed = 15},
		},
	},
}

local GER_RBoot_Turret_37mm = BoatChild:New{ --
	name					= "37mm Turret",
	description				= "Primary Turret",
	objectName				= "GERRboot_Turret_37mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak4337mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		weaponcost				= 3,
		weaponswithammo			= 1,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 60,
		elevationspeed			= 30,
		fearlimit				= 25,
    },
}

local GER_RBoot_Turret_20mm = BoatChild:New{
	name					= "20mm Turret",
	description				= "20mm AA Turret",
	objectName				= "GERRBoot_Turret_20mm.s3o",
  	weapons = {	
		[1] = {
			name				= "flak3820mmaa",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			mainDir		= [[0 0 -1]],
		},
		[2] = {
			name				= "flak3820mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			mainDir		= [[0 0 -1]],
		},
	},
	customparams = {
	    maxammo					= 16, -- TODO: from BMO 37mm
		weaponcost				= 3,
		weaponswithammo			= 2,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 80,
		aaweapon				= 1,
		facing					= 2,
		fearlimit				= 25,
    },
}

return lowerkeys({
	["GERRBoot"] = GER_RBoot,
	["GER_RBoot_Turret_37mm"] = GER_RBoot_Turret_37mm,
	["GER_RBoot_Turret_20mm"] = GER_RBoot_Turret_20mm,
})
