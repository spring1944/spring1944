local US_LCSS = Boat:New{
	name					= "Landing Craft, Support, Small",
	description				= "Light Rocket Craft",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 1800,
	stealth			= true,
	iconType				= "gunboat",
	maxDamage				= 1030,
	maxReverseVelocity		= 0.5,
	maxVelocity				= 2,
	movementClass			= "BOAT_LandingCraftSmall",
	script					= "<NAME>.lua",
	turnRate				= 80,	
	weapons = {	
		[1] = {
			name				= "BBR_Rack",
			maxAngleDif			= 20,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[2] = {
			name				= "BBR_Rack",
			maxAngleDif			= 20,
			slaveTo				= 1,
		},
		[3] = {
			name				= "M2BrowningAA",
			maxAngleDif			= 300,
			onlyTargetCategory	= "AIR",
			mainDir				= [[0 0 -1]],
		},
		[4] = {
			name				= "M2Browning",
			maxAngleDif			= 300,
			onlyTargetCategory	= "INFANTRY OPENVEH SOFTVEH DEPLOYED SHIP",
			mainDir				= [[ 0 0 -1]],
		},
	},
	customparams = {
		maxAmmo					= 1,
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},

	},
	--[[
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[2] = "custom:PLACEHOLDER_EFFECT01",
			[3] = "custom:PLACEHOLDER_EFFECT02",
			[4] = "custom:PLACEHOLDER_EFFECT03",
			[5] = "custom:PLACEHOLDER_EFFECT04",
			[6] = "custom:PLACEHOLDER_EFFECT05",
			[7] = "custom:PLACEHOLDER_EFFECT06",
			[8] = "custom:MG_MUZZLEFLASH",
		},
	},
	]]--
}


return lowerkeys({
	["USLCSS"] = US_LCSS,
})
