local JPN_Barracks = Barracks:New{
	buildCostMetal				= 1500,
	collisionVolumeScales		= [[50 32 110]],
	collisionVolumeOffsets		= [[0 15 0]],
	footprintX					= 6,
	footprintZ					= 8,
	maxDamage					= 10000, -- TODO: wtf?
	yardmap						= [[oooooo 
								    oooooo 
									ooccoo 
									occcco 
									occcco 
									cccccc 
									cccccc 
									cccccc]],
	customParams = {
		normaltex			= "",
	},
}

local JPN_Tent = Barracks:New{
	name						= "Tent Barracks",
	description					= "Light Infantry Training & Housing Facility",
	buildCostMetal				= 1000,
	footprintX					= 5,
	footprintZ					= 5,
	minCloakDistance			= 300,
	customparams = {
			hiddenbuilding				= true,
	},
	workerTime					= 15,
	yardmap						= [[ooooo 
								    ooooo 
									occco 
									occco 
									occco]],
}

return lowerkeys({
	["JPNBarracks"] = JPN_Barracks,
	["JPNTent"] = JPN_Tent,
})
