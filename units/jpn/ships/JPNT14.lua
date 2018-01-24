local JPNT14 = ArmedBoat:New{
	name					= "Type T-14 Motor Torpedo Boat",
	description				= "Motor Torpedo Boat",
	acceleration			= 0.35,
	brakeRate				= 0.15,
	buildCostMetal			= 1440,
	collisionVolumeOffsets	= [[0.0 -10.0 -5.0]],
	collisionVolumeScales	= [[22.0 20.0 85.0]],
	corpse					= "RUSKomsMTB_dead", -- TODO: needs a corpse (model exists)
	maxDamage				= 1450,
	maxReverseVelocity		= 3.005,
	maxVelocity				= 3.96,
	movementClass			= "BOAT_RiverSmall",
	transportCapacity		= 1, -- 1 x 1fpu turrets
	turnRate				= 105,	
	weapons = {	
		[1] = {
			name				= "Type9625mmHE",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP TURRET DEPLOYED",
		},
	},
	customparams = {
		soundcategory = "JPN/Boat",
		children = {
			"JPNT14_Turret_25mm",
		},
		deathanim = {
			["z"] = {angle = 45, speed = 15},
		},

	},
}

local JPNT14_Turret_25mm = OpenBoatTurret:New{
	name					= "25mm Turret",
	description				= "25mm AA Turret",
  	weapons = {	
		[1] = {
			name				= "Type9625mmAA",
		},
		[2] = {
			name				= "Type9625mmHE",
		},
	},
	customparams = {
		maxammo					= 14,

		barrelrecoildist		= 4,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 90,
		elevationspeed			= 80,
		aaweapon				= 1,

    },
}

return lowerkeys({
	["JPNT14"] = JPNT14,
	["JPNT14_Turret_25mm"] = JPNT14_Turret_25mm,
})
