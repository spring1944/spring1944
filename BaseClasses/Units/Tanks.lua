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
	turnRate			= 250,
	
	customParams = {
		blockfear			= true,
		soundcategory		= "<SIDE>/Tank",
		hasturnbutton		= true,
		weaponswithammo		= 2,
		weapontoggle		= "priorityAPHE",
		
		cegpiece = {
			[1] = "flare",
			[2] = "flare",
			[3] = "coaxflare",
		},
	},
}


-- Light Tank
local LightTank = Tank:New{
	description 		= "Light Tank",
	iconType			= "lighttank",
	movementClass		= "TANK_Light",
	trackType			= "T60-70-SU76",
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
}

-- Heavy Tank
local HeavyTank = Tank:New{
	acceleration		= 0.043,
	brakeRate			= 0.105,
	description 		= "Heavy Tank",
	explodeAs			= "Vehicle_Explosion_Large",
	iconType			= "heavytank",
	movementClass		= "TANK_Heavy",
	turnRate			= 150,
	
	customParams = {
		soundcategory		= "<SIDE>/Tank/Heavy",
	}
}

-- Assault Gun
local AssaultGun = Unit:New{ -- not a full class (interface)
	description 		= "Self-Propelled Assault Gun",
	iconType			= "selfprop",
	script				= "Vehicle.lua",
	turnRate			= 160,
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP",
	}
}

-- Tank Destroyer
local TankDestroyer = AssaultGun:New{
	description 		= "Tank Destroyer",
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP/TD",
		weaponswithammo		= 1, -- AP only
		weapontoggle		= false,
	}
}

-- SP Arty Tank
local SPArty = Unit:New{ -- not a full class (interface)
	description 		= "Self-Propelled Howitzer",
	iconType			= "sparty",
	turnRate			= 175,
	customParams = {
		canareaattack		= true,
		soundcategory		= "<SIDE>/Tank/SP",
		weaponswithammo		= 1, -- No smoke!
		weapontoggle		= false,
	}
}

local OpenTopped = { --not a full class (interface, more like 'attribute')
	category			= "MINETRIGGER OPENVEH",
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