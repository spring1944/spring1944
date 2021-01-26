local JPN_Ki76 = Recon:New{
	name			= "Ki-76 Stella",
	maxDamage		= 86,
	
	maxAcc			= 0.353,
	
	customParams = {
		enginesound		= "po2-",
		enginesoundnr	= 11,
		normaltex			= "unittextures/JPNKi76_normals.png",
	},
}


return lowerkeys({
	["JPNKi76"] = JPN_Ki76,
})
