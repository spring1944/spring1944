local US_C47 = ParaTransport:New{
	name			= "C-47 Skytrain",
	maxDamage		= 1705.7,
	
	customParams = {
		feartarget = false,
		enginesound		= "spitfireb-",
		enginesoundnr	= 18,
		normaltex			= "unittextures/USC47a_normals.png",
	},
	
	weapons = {
		[1] = {
			name			= "us_paratrooper",
		},
	},
}


return lowerkeys({
	["USC47"] = US_C47,
})
