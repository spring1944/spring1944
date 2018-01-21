local US_PT103 = ArmedBoat:New{
	name					= "PT-103 Type",
	description				= "Patrol Torpedo Boat",
	acceleration			= 0.3,
	brakeRate				= 0.15,
	buildCostMetal			= 1785,
	movementClass			= "BOAT_RiverSmall",
	collisionVolumeOffsets	= [[0.0 -16.0 0.0]],
	collisionVolumeScales	= [[35.0 18.0 240.0]],
	maxDamage				= 4000,
	maxReverseVelocity		= 2.15,
	maxVelocity				= 4.92, -- 41kn
	movementClass			= "BOAT_Medium",
	transportCapacity		= 4, -- 4 x 1fpu turrets
	turnRate				= 100,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "bofors40mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"USPT103_Turret_20mm",
			"USPT103_Turret_Twin50",
			"USPT103_Turret_Twin50",
			"USPT103_Turret_Bofors",
		},
		deathanim = {
			["x"] = {angle = 15, speed = 30},
			["z"] = {angle = 45, speed = 30},
		},
		smokegenerator		=	1,
		smokeradius		=	300,
		smokeduration		=	40,
		smokecooldown		=	30,
		smokeceg		=	"SMOKESHELL_Medium",

	},
}


local US_PT103_Turret_Twin50 = OpenBoatTurret:New{
	name					= "Browning 50cal Turret",
	description				= "Heavy Machinegun Turret",
	weapons = {	
		[1] = {
			name				= "m2browning", -- TODO: should be m2browningaa too :/
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
		},
		[2] = {
			name				= "m2browning",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			slaveTo				= 1,
		},
	},
	customparams = {
		turretturnspeed			= 250, -- TODO: :o huge compared to others
		elevationspeed			= 200, -- TODO: ditto

	},
}


local US_PT103_Turret_20mm = OpenBoatTurret:New{
	name					= "Oerlikon 20mm Turret",
	description				= "20mm AA Turret",
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			onlyTargetCategory	= "AIR",
			maxAngleDif			= 300,
		},
		[2] = {
			name				= "Oerlikon20mmhe",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 300,
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,

	},
}

local US_PT103_Turret_Bofors = OpenBoatTurret:New{
	name					= "40mm Bofors Turret",
	description				= "Primary Turret",
  	weapons = {	
		[1] = {
			name				= "bofors40mmaa",
			maxAngleDif			= 270,
			mainDir		= [[0 0 -1]],
			onlyTargetCategory	= "AIR",
		},
		[2] = {
			name				= "bofors40mmhe",
			mainDir		= [[0 0 -1]],
			maxAngleDif			= 270,
		},
	},
	customparams = {
		maxammo					= 10,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 90,
		aaweapon				= 1,
		facing					= 2,
		defaultheading1		= math.rad(180),
    },
}


return lowerkeys({
	["USPT103"] = US_PT103,
	["USPT103_Turret_20mm"] = US_PT103_Turret_20mm,
	["USPT103_Turret_Twin50"] = US_PT103_Turret_Twin50,
	["USPT103_Turret_Bofors"] = US_PT103_Turret_Bofors,
})
