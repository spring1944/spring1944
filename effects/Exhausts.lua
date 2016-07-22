--petrol_exhaust
--diesel_exhaust

return {
  ["petrol_exhaust"] = {
    muzzlesmoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 4, -- 10
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.4, --0.8
        alwaysvisible      = false,
        colormap           = [[1.0 0.7 0.5 1.0     0.4 0.4 0.4 1.0    0.3 0.3 0.3 1.0    0.2 0.2 0.2 1.0    0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[dir]],
        gravity            = [[0, -0.1, 0]],
        numparticles       = 10,
        particlelife       = 50, -- 20
        particlelifespread = 25,
        particlesize       = [[7 i-0.4]],
        particlesizespread = 1,
        particlespeed      = [[10 i-1]], --[10 i-1]],
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },
  ["diesel_exhaust"] = {
    muzzlesmoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 4, -- 10
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.4, --0.8
        alwaysvisible      = false,
        colormap           = [[0.72 0.61 0.41 1      0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[dir]],
        gravity            = [[0, -0.1, 0]],
        numparticles       = 10,
        particlelife       = 50, -- 20
        particlelifespread = 25,
        particlesize       = [[7 i-0.4]],
        particlesizespread = 1,
        particlespeed      = [[10 i-1]], --[10 i-1]],
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },
}

