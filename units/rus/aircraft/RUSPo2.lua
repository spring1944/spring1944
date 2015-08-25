local RUS_Po2 = Recon:New{
	name			= "Po-2 Kukuruznik",
	maxDamage		= 77,
	
	maxAcc			= 0.822,
	
	customParams = {
		enginesound		= "po2-",
		enginesoundnr	= 11,
		planevoice		= 1,
	},
}

local RUS_Po2Partisan = RUS_Po2:Clone("RUSPo2"):New{
	buildpic		= "RUSPo2Partisan.png", -- override clone
	script			= "RUSPo2Partisan.cob", -- more override clone
	description		= "Partisan Supply Plane",
	customParams = {
		troopdropper	= 1,
		deposit			= 0,
	},
	
	weapons = {
		[1] = {
			name			= "rus_partisandrop",
		},
	},
}

return lowerkeys({
	["RUSPo2"] = RUS_Po2,
	["RUSPo2Partisan"] = RUS_Po2Partisan,
})
