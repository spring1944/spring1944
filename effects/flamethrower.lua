-- flamethrower
-- flamethrower_flames

return {
  ["flamethrower"] = {
    usedefaultexplosions = false,
    fire = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 2,
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
        particlespeedspread = 4,
        pos                = [[-4 r8, 0, -4 r8]],
        sizegrowth         = 0.75,
        sizemod            = 1,
        texture            = [[fireball]],
      },
    },
    flames = {
      class              = [[CExpGenSpawner]],
      count              = 4,
      ground             = true,
      unit               = 1,
      properties = {
        delay              = [[4 r16]],
        explosiongenerator = [[custom:Flamethrower_Flames]],
        pos                = [[-16 r32, r16, -16 r32]],
      },
    },
    groundflash = {
      circlealpha        = 0,
      circlegrowth       = 10,
      flashalpha         = 0.0625,
      flashsize          = 64,
      ttl                = 48,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0.10000000149012,
      },
    },
  },

  ["flamethrower_flames"] = {
    flames = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.95,
        alwaysvisible      = false,
        colormap           = [[1 1 1 0.2  0 0 0 0.3  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 1,
        particlelife       = 24,
        particlelifespread = 16,
        particlesize       = 1,
        particlesizespread = 8,
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

