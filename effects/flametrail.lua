-- flametrail

return {
  ["flametrail"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 4,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.5,
        alwaysvisible      = false,
        colormap           = [[1 1 0.25 0.5  0.25 0.15 0.05 0.25  0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 3,
        particlelifespread = 2,
        particlesize       = 6,
        particlesizespread = 2,
        particlespeed      = [[i1]],
        particlespeedspread = 0.5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[longersmokesmall]],
      },
    },
  },

}

