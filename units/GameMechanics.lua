local BinocSpot = Null:New{
	sightDistance				= 200,
	yardmap						= "y",
}

local Flag = Null:New{
	name				= "Flag",
	description			= "Command Flag",
	activateWhenBuilt	= true,
	extractsMetal		= 0.000292,
	hideDamage			= true,
	iconType			= "flag",
	levelGround			= false,
	objectName			= "GEN/flag.S3O",
	script				= "Flag.lua", -- atm defaults to .cob
	sightDistance		= 0,
	windGenerator		= 0.00001, -- needed for WindChanged callin
	yardmap				= "y",
	customParams = {
		dontCount			= true,
		flag				= true,
	},
}

local Buoy = Flag:New{ -- One day...
	name				= "Buoy",
	description			= "Naval Spawn Point",
	floater				= true,
	objectName			= "Gen/buoy.S3O",
	script				= "buoy.cob", --overwrite flag
	canMove = false, -- for some reason cannot be true or it won't float?
}

local SmallTankShelter = TankShelter:New{
	name				= "Tank Shelter (Small)",
	transportMass		= 2100,
}

return lowerkeys({
	["BinocSpot"] = BinocSpot,
	["Flag"] = Flag,
	["Buoy"] = Buoy,
	["SmallTankShelter"] = SmallTankShelter,
})