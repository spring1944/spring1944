local RUS_BMO = BoatMother:New{
	name					= "BMO Class Subchaser",
	description				= "Armoured light patrol ship",
	acceleration			= 0.1,
	brakeRate				= 0.05,
	buildCostMetal			= 1700,
	buildTime				= 1700,
	collisionVolumeOffsets	= [[0.0 -9.0 0.0]],
	collisionVolumeScales	= [[24.0 12.0 160.0]],
	corpse					= "RUSBMO_dead",
	mass					= 562000,
	maxDamage				= 588000, --+10% because it has armor
	maxReverseVelocity		= 1.1,
	maxVelocity				= 2.2,
	movementClass			= "BOAT_LightPatrol",
	objectName				= "RUSBMO.s3o",
	soundCategory			= "RUSBoat",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 300,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "M1939_61k37mmaa",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"RUS_Turret_37mm_Front", 
			"RUS_Turret_45mm_Rear", 
			"RUS_BMO_Turret_DshKAA", 
			"RUS_BMO_Turret_Vickers", 
		},
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},
	},
}

local RUS_Turret_37mm_Front = BoatChild:New{ -- Used on multiple vessels
	name					= "37mm Turret",
	description				= "Primary Turret",
	objectName				= "RUSBMO_Turret_37mm.s3o",
  	weapons = {	
		[1] = {
			name				= "M1939_61k37mmaa",
			maxAngleDif			= 270,
			badTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "M1939_61k37mmhe",
			maxAngleDif			= 270,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
	    maxammo					= 16,
		weaponcost				= 3,
		weaponswithammo			= 2,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 90,
		aaweapon				= 1,
		fearlimit				= 75, -- 3/4 enclosed
    },
}
local RUS_Turret_37mm_Rear = RUS_Turret_37mm_Front:New{
  	weapons = {	
		[1] = {
			weaponMainDir		= [[0 0 -1]],
		},
		[2] = {
			weaponMainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,
    },
}

local RUS_BMO_Turret_DshKAA = BoatChild:New{
	name					= "BMO DshK Turret",
	description				= "Heavy Machinegun Turret",
	objectName				= "RUSBMO_Turret_DshKAA.s3o",
	weapons = {	
		[1] = { -- original BMO used twin_dshk but we can use 2 actual weapons here
			name				= "dshk",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			weaponMainDir		= [[0 0 -1]],
			maxAngleDif			= 358,
		},
		[2] = {
			name				= "dshk",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			weaponMainDir		= [[0 0 -1]],
			maxAngleDif			= 358,
			slaveTo				= 1,
		},
	},
	customparams = {
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 80,
		elevationspeed			= 45,
		facing					= 2,
	},
}

local RUS_BMO_Turret_Vickers = BoatChild:New{
	name					= "BMO Vickers .50cal Turret",
	description				= "Heavy Machinegun Turret",
	objectName				= "RUSBMO_Turret_Vickers.s3o",
	weapons = {	
		[1] = {
			name				= "dshk", --"twin05calVickers",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			weaponMainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
		[2] = {
			name				= "dshk", --"twin05calVickers",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			weaponMainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
	},
	customparams = {
		barrelrecoildist		= 1,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 60,
		elevationspeed			= 35,
		facing					= 2,
		fearlimit				= 25,
	},
}

local RUS_Turret_45mm_Front = BoatChild:New{ -- Used on multiple vessels
	name					= "45mm Turret",
	description				= "Primary Turret",
	objectName				= "RUSBMO_Turret_45mm.s3o",
  	weapons = {	
		[1] = {
			name				= "M1937_40k45mmhe",
			maxAngleDif			= 300,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		maxammo					= 18,
		weaponcost				= 8,
		weaponswithammo			= 1,
		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 25,
		elevationspeed			= 30,
    },
}
local RUS_Turret_45mm_Rear = RUS_Turret_45mm_Front:New{
  	weapons = {	
		[1] = {
			weaponMainDir		= [[0 0 -1]],
		},
	},
	customparams = {
		facing					= 2,
    },
}

return lowerkeys({
	["RUSBMO"] = RUS_BMO,
	["RUS_Turret_37mm_Front"] = RUS_Turret_37mm_Front,
	["RUS_Turret_37mm_Rear"] = RUS_Turret_37mm_Rear,
	["RUS_Turret_45mm_Front"] = RUS_Turret_45mm_Front,
	["RUS_Turret_45mm_Rear"] = RUS_Turret_45mm_Rear,
	["RUS_BMO_Turret_DshKAA"] = RUS_BMO_Turret_DshKAA,
	["RUS_BMO_Turret_Vickers"] = RUS_BMO_Turret_Vickers,
})
