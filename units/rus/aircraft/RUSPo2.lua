Unit('RUS_Po2'):Extends('Recon'):Attrs{
	name			= "Po-2 Kukuruznik",
	maxDamage		= 77,
	
	maxAcc			= 0.822,
	
	customParams = {
		enginesound		= "po2-",
		enginesoundnr	= 11,
		planevoice			= {
			enter_map		= 'sounds/rus/air/po2/rus_air_po2_select.wav',
			return_to_base  = 'sounds/rus/air/rus_air_return.wav',
		},
	},
}

Unit('RUS_Po2Partisan'):Extends('RUS_Po2'):Attrs{
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

