-- dirt_backblast

return {
  ["dirt_backblast"] = {
    usedefaultexplosions = false,
    dirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 16,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.95,
        alwaysvisible      = false,
        colormap           = [[0.25 0.2 0.15 0.5  0 0 0 0]],
        directional        = false,
        emitrot            = 180,
        emitrotspread      = 15,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 32,
        particlelifespread = 16,
        particlesize       = 1,
        particlesizespread = 0,
        particlespeed      = 0,
        particlespeedspread = 8,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[1 r1]],
        sizemod            = 1,
        texture            = [[smokesmall]],
      },
    },
  },

}

