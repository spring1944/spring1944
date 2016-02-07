-- Tanks ----
AbstractUnit('Tank'):Extends('Unit'):Attrs{ -- some overlap with Vehicle
	acceleration		= 0.051,
	brakeRate			= 0.15,
	canMove				= true,
	category			= "MINETRIGGER HARDVEH",
	explodeAs			= "Vehicle_Explosion_Med",
	footprintX			= 3,
	footprintZ			= 3,
	leaveTracks			= true,
	movementClass		= "TANK_Medium",
	noChaseCategory		= "FLAG AIR MINE",
	script				= "Vehicle.lua",
	seismicSignature	= 1,
	trackType			= "Stdtank",
	turnRate			= 250,
	
	customParams = {
		blockfear			= true,
		soundcategory		= "<SIDE>/Tank",
		hasturnbutton		= true,
		reversemult			= 0.5,
		weapontoggle		= "priorityAPHE",
	},
}


-- Light Tank
AbstractUnit('LightTank'):Extends('Tank'):Attrs{
	description 		= "Light Tank",
	iconType			= "lighttank",
	movementClass		= "TANK_Light",
	trackType			= "T60-70-SU76",

	customParams = {
		damageGroup		= "lightTanks",
	},
}

-- Tankette
AbstractUnit('Tankette'):Extends('LightTank'):Attrs{
	description 		= "Tankette",
	explodeAs			= "Vehicle_Explosion_Sm",
	footprintX			= 2,
	footprintZ			= 2,
}

-- Medium Tank
AbstractUnit('MediumTank'):Extends('Tank'):Attrs{
	description 		= "Medium Tank",
	iconType			= "medtank",

	customParams = {
		damageGroup		= "mediumTanks",
	},
}

-- Heavy Tank
AbstractUnit('HeavyTank'):Extends('Tank'):Attrs{
	acceleration		= 0.043,
	brakeRate			= 0.105,
	description 		= "Heavy Tank",
	explodeAs			= "Vehicle_Explosion_Large",
	iconType			= "heavytank",
	movementClass		= "TANK_Heavy",
	turnRate			= 150,

	customParams = {
		damageGroup			= "heavyTanks",
		soundcategory		= "<SIDE>/Tank/Heavy",
	}
}

-- Assault Gun
AbstractUnit('AssaultGun'):Attrs{ -- not a full class (role/mixin)
	description 		= "Self-Propelled Assault Gun",
	iconType			= "selfprop",
	turnRate			= 160,
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP",
	}
}

-- Tank Destroyer
AbstractUnit('TankDestroyer'):Extends('AssaultGun'):Attrs{
	description 		= "Tank Destroyer",
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP/TD",
		weapontoggle		= false,
	}
}

-- SP Arty Tank
AbstractUnit('SPArty'):Attrs{ -- not a full class (role/mixin)
	description 		= "Self-Propelled Howitzer",
	iconType			= "sparty",
	turnRate			= 175,
	customParams = {
		canareaattack		= true,
		soundcategory		= "<SIDE>/Tank/SP",
		weapontoggle		= false,
	}
}

AbstractUnit('OpenTopped'):Attrs{ --not a full class (role/mixin)
	category			= "MINETRIGGER OPENVEH",
	customParams = {
		damageGroup		= "armouredVehicles",
	},
}

