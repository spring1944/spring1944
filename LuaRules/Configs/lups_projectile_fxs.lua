local fxs = {
	flameHeat = {
		class = "JitterParticles2",
		options = {
			colormap		= { {1,1,1,1},{1,1,1,1} },
			count			= 6,
			life			= 50,
			delaySpread		= 25,
			force			= {0,1.5,0},
			emitRotSpread	= 10,
			speed			= 7,
			speedSpread		= 0,
			speedExp		= 1.5,
			size			= 15,
			sizeGrowth		= 5.0,
			scale			= 1.5,
			strength		= 1.0,
			heat			= 2,
		},
	},
	mgtracer = {
		class = "ribbon",
		options = {size = 3, width = 1.5, color = {0.95, 0.05, 0,0.95}, texture = "bitmaps/ProjectileTextures/tracer3.jpg"},
	},
	cannon20tracer = {
		class = "ribbon",
		options = {size = 4, width = 2, color = {0.65, 0.65, 0,0.95}, texture = "bitmaps/ProjectileTextures/tracer3.jpg"},
	},
	cannontracer = {
		class = "ribbon",
		options = {size = 4, width = 4, color = {0.65, 0.65, 0,0.95}, texture = "bitmaps/ProjectileTextures/tracer3.jpg"},
	},
}

return fxs