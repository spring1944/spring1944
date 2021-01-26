local SWE_PartisanBase = Storage:New{
	name					= "Partisan supply base",
	builder					= true,
	canMove					= true,
	cloakCost				= 0,
	init_cloaked			= 1,
	minCloakDistance		= 300,
	stealth					= 1,
	workerTime				= 20,
	yardmap					= [[yyyy yyyy yyyy yyyy yyyy yyyy]],
	customParams = {
		hiddenbuilding		= 1,
		dontCount			= 1,
		spawnsUnit			= "swepartisan",
		normaltex			= "unittextures/GBRStorageCamo_normals.png",
	},
}

return lowerkeys({
	["SWEPartisanBase"] = SWE_PartisanBase,
})
