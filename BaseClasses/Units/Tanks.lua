-- Tanks ----
local Tank = Unit:New{ -- some overlap with Vehicle
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
	turnRate			= 75,
	
	customParams = {
		blockfear			= true,
		soundcategory		= "<SIDE>/Tank",
		hasturnbutton		= true,
		reversemult			= 0.5,
		weapontoggle		= "priorityAPHE",
		turretturnspeed		= 16,	-- default
		immobilizationresistance = 0.75,	-- rather high by default
	},
}


-- Light Tank
local LightTank = Tank:New{
	description 		= "Light Tank",
	iconType			= "lighttank",
	movementClass		= "TANK_Light",
	trackType			= "T60-70-SU76",
	turnRate			= 150,

	customParams = {
		damageGroup		= "lightTanks",
		turretturnspeed		= 36,	-- faster than default
	},
}

-- Tankette
local Tankette = LightTank:New{
	description 		= "Tankette",
	explodeAs			= "Vehicle_Explosion_Sm",
	footprintX			= 2,
	footprintZ			= 2,
}

-- Medium Tank
local MediumTank = Tank:New{
	description 		= "Medium Tank",
	iconType			= "medtank",
	turnRate			= 125,

	customParams = {
		damageGroup		= "mediumTanks",
	},
}

-- Heavy Tank
local HeavyTank = Tank:New{
	acceleration		= 0.043,
	brakeRate			= 0.105,
	description 		= "Heavy Tank",
	explodeAs			= "Vehicle_Explosion_Large",
	iconType			= "heavytank",
	movementClass		= "TANK_Heavy",
	turnRate			= 100,

	customParams = {
		damageGroup			= "heavyTanks",
		soundcategory		= "<SIDE>/Tank/Heavy",
	}
}

-- Assault Gun
local AssaultGun = Def:New{ -- not a full class (role/mixin)
	description 		= "Self-Propelled Assault Gun",
	iconType			= "selfprop",
	turnRate			= 110,
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP",
		turretturnspeed		= 24,
	}
}

-- Tank Destroyer
local TankDestroyer = AssaultGun:New{
	description 		= "Tank Destroyer",
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP/TD",
		weapontoggle		= false,
	}
}

-- SP Arty Tank
local SPArty = Def:New{ -- not a full class (role/mixin)
	description 		= "Self-Propelled Howitzer",
	iconType			= "sparty",
	turnRate			= 95,
	customParams = {
		canareaattack		= true,
		soundcategory		= "<SIDE>/Tank/SP",
		weapontoggle		= false,
	}
}

local OpenTopped = Def:New{ --not a full class (role/mixin)
	category			= "MINETRIGGER OPENVEH",
	customParams = {
		damageGroup		= "lightTanks",
	},
}

return {
	Tank = Tank,
	Tankette = Tankette,
	LightTank = LightTank,
	MediumTank = MediumTank,
	HeavyTank = HeavyTank,
	AssaultGun = AssaultGun,
	TankDestroyer = TankDestroyer,
	SPArty = SPArty,
	OpenTopped = OpenTopped,
}
