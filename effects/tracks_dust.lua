return
{
	["dustcloud_medium"] =
	{
		smoke =
		{
			air                = true,
			class              = [[CSimpleParticleSystem]],
			count              = 2,
			ground             = true,
			water              = true,
			properties =
			{
				airdrag            = 0.91,
				alwaysvisible      = false,
				colormap           = [[0.25 0.2 0.15 0.5  0 0 0 0]],
				dir                = [[dir]],
				directional        = false,
				emitrot            = 0,
				emitrotspread      = 360,
				emitvector         = [[0, 1, 0]],
				gravity            = [[0, 0, 0]],
				numparticles       = 5,
				particlelife       = 50,
				particlelifespread = 20,
				particlesize       = [[10 i-0.4]],
				particlesizespread = 5,
				particlespeed      = [[1.5 i-10]],
				particlespeedspread = 0.5,
				pos                = [[0, 0, 0]],
				sizeGrowth		   = 0.5,
				sizemod            = 1.0,
				texture            = [[smokesmall]],
			},
		},
	},
}
