-- burning_flames
-- burning

return {
  ["burning_flames"] = {
    flames = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.95,
        alwaysvisible      = false,
        colormap           = [[1 1 1 0.2  0 0 0 0.3  0 0 0 0.2  0 0 0 0.1  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 1,
        particlelife       = 64,
        particlelifespread = 16,
        particlesize       = 8,
        particlesizespread = 8,
        particlespeed      = 0,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[fireball]],
      },
    },
    groundflash = {
      circlealpha        = 0,
      circlegrowth       = 10,
      flashalpha         = 0.125,
      flashsize          = 32,
      ttl                = 16,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0.10000000149012,
      },
    },
  },

  ["burning"] = {
    usedefaultexplosions = false,
    flames = {
      class              = [[CExpGenSpawner]],
      count              = 512,
      ground             = true,
      unit               = 1,
      properties = {
        delay              = [[i1 r2]],
        explosiongenerator = [[custom:Burning_Flames]],
        pos                = [[-4 r8, r2, -4 r8]],
      },
    },
  },

}

