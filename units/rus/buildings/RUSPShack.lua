local RUS_PShack = Barracks:New{
	buildCostMetal				= 645,
    description                 = "Partisan Resistance Center",
	customparams = {
			hiddenbuilding				= true,
	},
	footprintX					= 3,
	footprintZ					= 3,
	maxDamage					= 1000,
    minCloakDistance            = 300,
	yardmap						= [[yyy 
									yyy 
									yyy]],
	customParams = {

	},
}

return lowerkeys({
	["RUSPShack"] = RUS_PShack,
})
