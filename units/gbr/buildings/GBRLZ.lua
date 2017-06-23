local GBR_LZ = Building:New{
	name			= "Commando Landing Zone",
	buildCostMetal	= 2700,
	explodeAs		= "GBRLZ_death",
	footprintX		= 1,
	footprintZ		= 1,
	idleAutoHeal	= 0,
	levelGround		= false,
	maxDamage		= 5,
	maxSlope		= 60,
	stealth			= true,
	yardmap			= [[c]],
	
	sfxtypes = {
		explosionGenerator = {
			"custom:LZflare",
		},
	},
	customParams = {
		hiddenbuilding	= true,
		dontCount		= true,
		normaltex		= "",
	}
}

return lowerkeys({
	["GBRLZ"] = GBR_LZ,
})
