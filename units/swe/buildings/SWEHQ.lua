local SWE_HQ = HQ:New{
	name					= "Swedish Army HQ",
	corpse					= "swepbilm31f_destroyed",
	footprintX				= 7,
	footprintZ				= 7,
	maxDamage				= 10625, -- TODO: Same as GER Bunker! Change me!
	yardmap					= [[ooooooo 
							    oocccoo 
								oocccoo 
								ooyyyyo 
								ooyyyyo 
								ooyyyyo 
								ooyyyyo]],
	customParams = {
		normaltex			= "unittextures/SWEPBilM31f_normals.png",
	},
}

return lowerkeys({
	["SWEHQ"] = SWE_HQ,
})
