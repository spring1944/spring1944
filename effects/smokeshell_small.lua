-- smokeshell_small

return {
  ["smokeshell_small"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 2,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.08,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0.01  0.5 0.5 0.5 0.5     0 0 0 0.01]],
        dir                = [[dir]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 360,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -5, 0]],
        numparticles       = 5,
        particlelife       = 100,
        particlelifespread = 50,
        particlesize       = [[30 i-0.4]],
        particlesizespread = 15,
        particlespeed      = [[90 i-10]],
        particlespeedspread = 30,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.05,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },

}

