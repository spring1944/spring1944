-- Tanks ----
local Tank = Unit:New{ -- some overlap with Vehicle
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
	description 		= "Heavy Tank",
	explodeAs			= "Vehicle_Explosion_Large",
	iconType			= "heavytank",
	turnRate			= 150,
	
	customParams = {
		soundcategory		= "<SIDE>/Tank/Heavy",
	}
}

-- Assault Gun
local AssaultGun = Tank:New{
	description 		= "Self-Propelled Assault Gun",
	iconType			= "selfprop",
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP",
	}
}

-- Tank Destroyer
local TankDestroyer = AssaultGun:New{
	description 		= "Tank Destroyer",
	customParams = {
		weaponswithammo		= 1, -- AP only
		soundcategory		= "<SIDE>/Tank/SP/TD",
	}
}

local OpenTankDestroyer = TankDestroyer:New{
	category			= "MINETRIGGER OPENVEH", -- open topped
}

-- SP Arty Tank
local SPArty = Tank:New{
	description 		= "Self-Propelled Artillery",
	category			= "MINETRIGGER OPENVEH", -- SPH tend to be open topped
	iconType			= "sparty",
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP",
	}
}

return {
	Tank = Tank,
	Tankette = Tankette,
	LightTank = LightTank,
	MediumTank = MediumTank,
	HeavyTank = HeavyTank,
	AssaultGun = AssaultGun,
	TankDestroyer = TankDestroyer,
	OpenTankDestroyer = OpenTankDestroyer,
	SPArty = SPArty,
}