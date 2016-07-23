--petrol_exhaust
--diesel_exhaust

return {
	["petrol_exhaust"] = {
		muzzlesmoke =
		{
			air                = true,
			ground				= true,
			water				= true,
			class              = [[CSimpleParticleSystem]],
			count              = 10,
			properties =
			{
				airdrag            = 0.8,
				alwaysvisible      = false,
				colormap           = [[0 0 0 0.01  0.5 0.5 0.5 0.5     0 0 0 0.01]],
				directional        = false,
				emitrot            = 0,
				emitrotspread      = 30,
				emitvector         = [[dir]],
				gravity            = [[0, 0.1, 0]],
				numparticles       = 1,
				particlelife       = 50,
				particlelifespread = 25,
				particlesize       = [[7 i-0.4]],
				particlesizespread = 1,
				particlespeed      = [[8 i-1]],
				particlespeedspread = 1,
				pos                = [[0, 0, 0]],
				sizegrowth         = 0.1,
				sizemod            = 1.0,
				texture            = [[smokesmall]],
			},
		},
	},
	["diesel_exhaust"] = {
		muzzlesmoke =
		{
			air                = true,
			ground				= true,
			water				= true,
			class              = [[CSimpleParticleSystem]],
			count              = 10,
			properties =
			{
				airdrag            = 0.8,
				alwaysvisible      = false,
				colormap           = [[0.72 0.61 0.41 1      0 0 0 0.01]],
				directional        = false,
				emitrot            = 0,
				emitrotspread      = 30,
				emitvector         = [[dir]],
				gravity            = [[0, 0.1, 0]],
				numparticles       = 1,
				particlelife       = 50,
				particlelifespread = 25,
				particlesize       = [[7 i-0.4]],
				particlesizespread = 1,
				particlespeed      = [[8 i-1]],
				particlespeedspread = 1,
				pos                = [[0, 0, 0]],
				sizegrowth         = 0.1,
				sizemod            = 1.0,
				texture            = [[smokesmall]],
			},
		},
	},
}

