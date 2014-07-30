-- smallarms_tracerx
-- smallarms_tracer
-- tracerlightsmall

return {
  ["smallarms_tracerx"] = {
    tracer = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 1 0 0.01	1 0.5 0 0.01	0 0 0 0.01]],
        dir                = [[0 0 1]],
        frontoffset        = 0.1,
        fronttexture       = [[flowerflash]],
        length             = 3,
        particlespeed      = 50,
        sidetexture        = [[plasma2]],
        size               = 2.25,
        sizegrowth         = 1,
        ttl                = 20,
      },
    },
  },

  ["smallarms_tracer"] = {
    usedefaultexplosions = false,
    sparks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.97,
        colormap           = [[1 1 0 0.01   1 1 0 0.01   1 1 1 0.01   0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[dir]],
        gravity            = [[0, -0.1, 0]],
        numparticles       = 1,
        particlelife       = 15,
        particlelifespread = 15,
        particlesize       = 1,
        particlesizespread = 1,
        particlespeed      = 50,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[Tracer.png]],
      },
    },
  },

  ["tracerlightsmall"] = {
    usedefaultexplosions = false,
    groundflash = {
      air                = true,
      circlealpha        = 0,
      circlegrowth       = 0,
      flashalpha         = 0.8,
      flashsize          = 10,
      ground             = true,
      ttl                = 2,
      water              = true,
      color = {
        [1]  = 1,
        [2]  = 0.75,
        [3]  = 0,
      },
    },
  },

}

