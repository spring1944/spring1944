-- smokeshell_medium

return {
  ["smokeshell_medium"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 10,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.45,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0.01  0.5 0.5 0.5 0.5     0 0 0 0.01]],
        dir                = [[dir]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 360,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 1, 0]],
        numparticles       = 7,
        particlelife       = 120,
        particlelifespread = 50,
        particlesize       = [[60 i-0.4]],
        particlesizespread = 15,
        particlespeed      = [[100 i-10]],
        particlespeedspread = 50,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.05,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },

}

