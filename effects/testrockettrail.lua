-- testrockettrail
-- testbazookatrail

return {
  ["testrockettrail"] = {
    trail = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 8,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.6,
        colormap           = [[1 0.5 0.1 .1  .5 .5 .5 1  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 3,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 50,
        particlelifespread = 0,
        particlesize       = [[5 i-0.45]],
        particlesizespread = 0,
        particlespeed      = [[-8 i4]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.2,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },

  ["testbazookatrail"] = {
    trail = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 10,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.6,
        colormap           = [[1 0.5 0.1 .1  .5 .5 .5 1  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 3,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 30,
        particlelifespread = 0,
        particlesize       = [[5 i-0.45]],
        particlesizespread = 0,
        particlespeed      = [[-8 i4]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.2,
        sizemod            = .7,
        texture            = [[smokesmall]],
      },
    },
  },

}

