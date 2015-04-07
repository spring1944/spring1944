local SWE_HQ = HQ:New{
	name					= "Swedish Army HQ",
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
}

return lowerkeys({
	["SWEHQ"] = SWE_HQ,
})
