local ITA_HQ = HQ:New{
	name					= "Italian Army HQ",
	footprintX				= 7,
	footprintZ				= 7,
	maxDamage				= 10625, -- TODO: Same as GER Bunker! Change me!
	yardmap					= [[ooooooo 
							    oocccoo 
								oocccoo 
								ooyyyoo 
								ooyyyoo 
								ooyyyoo 
								ooyyyoo]],
	customParams = {

	},
}

return lowerkeys({
	["ITAHQ"] = ITA_HQ,
})
