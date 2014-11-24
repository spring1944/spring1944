-- Vehicles ----
local Deployed = Unit:New{
	activateWhenBuilt			= true,
	airSightDistance			= 2000,
	buildingGroundDecalSizeX	= 5,
	buildingGroundDecalSizeY	= 5,
	buildingGroundDecalType		= "Dirt2.dds",
	category					= "DEPLOYED",
	flankingBonusMax			= 1.25,
	flankingBonusMin			= 0.75,
	flankingBonusMode			= 1,
	footprintX					= 3,
	footprintZ					= 3,
	maxDamage					= 2500,
	maxSlope					= 15,
	maxWaterDepth				= 0,
	radardistance				= 650,
	sightDistance				= 650,
	stealth						= true,
	useBuildingGroundDecal		= true,
	
	customParams = {
		feartarget		= 1,
		soundcategory	= "<SIDE>/Gun",
		maxammo			= 4,
	},
}

-- Guns --
local AAGun = Deployed:New{
	description			= "Deployed Anti-Aircraft Gun",
	buildCostMetal		= 1400,
	iconType			= "aaartillery",
	maxDamage			= 1250,
	customParams = {
		weaponswithammo		= 2,
		maxammo				= 16,
	},
	weapons = {
		[1] = { -- AA
			onlyTargetCategory	= "AIR",
		},
		[2] = { -- HE
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},	
}

local ATGun = Deployed:New{
	description			= "Deployed Anti-Tank Gun",
	buildCostMetal		= 840,
	iconType			= "atartillery",
	customParams = {
		weaponswithammo		= 1,
	},
	weapons = {
		[1] = { -- AP
			badTargetCategory	= "SOFTVEH",
			onlyTargetCategory	= "SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP",
			maxAngleDif			= 70,
		},
	},
}

local LightATGun = ATGun:New{
	buildCostMetal		= 400,
	initCloaked			= true,
	cloakCost			= 0,
	cloakTimeout		= 160,
	minCloakDistance	= 300,
}

local FGGun = Deployed:New{
	description			= "Deployed Field Gun",
	buildCostMetal		= 1300,
	iconType			= "artillery",
	customParams = {
		weaponswithammo		= 2,
	},
	weapons = {
		[1] = { -- HE
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 60,
		},
		[2] = { -- AP
			onlyTargetCategory	= "OPENVEH HARDVEH",
			maxAngleDif			= 60,
		},
	},	
}

local HGun = Deployed:New{
	description			= "Deployed Howitzer",
	buildCostMetal		= 1800,
	iconType			= "artillery",
	customParams = {
	    canAreaAttack		= true,
		canfiresmoke		= true,
		weaponswithammo		= 2,
	},
	weapons = {
		[1] = { -- HE
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 35,
		},
		[2] = { -- Smoke
			onlyTargetCategory	= "NOTHING",
			maxAngleDif			= 35,
		},
	},
}

local RGun = Deployed:New{
	description			= "Deployed Rocket Launcher",
	buildCostMetal		= 3600,
	iconType			= "artillery",
	customParams = {
		weaponswithammo		= 1,
	},
	weapons = {
		[1] = {
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
			maxAngleDif			= 35,
		},
	},
}

return {
	Deployed = Deployed,
	-- Trucks
	AAGun = AAGun,
	ATGun = ATGun,
	LightATGun = LightATGun,
	FGGun = FGGun,
	HGun = HGun,
	RGun = RGun,
}