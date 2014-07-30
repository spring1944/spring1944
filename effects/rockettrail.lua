-- rockettrail

return {
  ["rockettrail"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 8,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.5,
        alwaysvisible      = false,
        colormap           = [[1 1 0.625 0.25  0.18 0.18 0.18 0.24  0.15 0.15 0.15 0.20  0.12 0.12 0.12 0.16  0.09 0.09 0.09 0.12  0.06 0.06 0.06 0.08  0.03 0.03 0.03 0.04  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 5,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 16,
        particlelifespread = 24,
        particlesize       = 1,
        particlesizespread = 2,
        particlespeed      = [[i3]],
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[0.4 r0.2]],
        sizemod            = 1,
        texture            = [[smokesmall]],
      },
    },
  },

}

