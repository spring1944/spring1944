-- molotov
-- molotov_flames

return {
  ["molotov"] = {
    usedefaultexplosions = false,
    fire = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 12,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.75,
        alwaysvisible      = false,
        colormap           = [[1 1 1 0.1  0 0 0 0]],
        directional        = false,
        emitrot            = 80,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 32,
        particlelifespread = 16,
        particlesize       = 0.5,
        particlesizespread = 1,
        particlespeed      = 0,
        particlespeedspread = 1,
        pos                = [[-4 r8, 0, -4 r8]],
        sizegrowth         = 0.25,
        sizemod            = 1,
        texture            = [[fireball]],
      },
    },
    flames = {
      class              = [[CExpGenSpawner]],
      count              = 48,
      ground             = true,
      unit               = 1,
      properties = {
        delay              = [[r16]],
        explosiongenerator = [[custom:Molotov_Flames]],
        pos                = [[-8 r16, 0, -8 r16]],
      },
    },
    groundflash = {
      circlealpha        = 0,
      circlegrowth       = 10,
      flashalpha         = 1,
      flashsize          = 12,
      ttl                = 48,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0,
      },
    },
  },

  ["molotov_flames"] = {
    flames = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.95,
        alwaysvisible      = false,
        colormap           = [[1 1 1 0.2  0 0 0 0.2  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 1,
        particlelife       = 24,
        particlelifespread = 8,
        particlesize       = 0.5,
        particlesizespread = 2,
        particlespeed      = 0,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[fireball]],
      },
    },
  },

}

