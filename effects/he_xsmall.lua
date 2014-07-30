-- he_xsmall

return {
  ["he_xsmall"] = {
    usedefaultexplosions = false,
    dust = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 8,
      ground             = true,
      properties = {
        colormap           = [[0.5 0.4 0.3 1  0.05 0.04 0.03 0.1]],
        dir                = [[-0.1 r0.2, 1, -0.1 r0.2]],
        frontoffset        = 0,
        fronttexture       = [[splashbase]],
        length             = [[8 r4]],
        sidetexture        = [[splashside]],
        size               = [[2 r1]],
        sizegrowth         = 1,
        ttl                = 12,
      },
    },
    groundflash = {
      circlealpha        = 0,
      circlegrowth       = 10,
      flashalpha         = 1,
      flashsize          = 8,
      ttl                = 8,
      color = {
        [1]  = 1,
        [2]  = 0.75,
        [3]  = 0.5,
      },
    },
    water = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 4,
      water              = true,
      properties = {
        colormap           = [[0.45 0.45 0.5 0.5  0.045 0.045 0.05 0.05]],
        dir                = [[-0.1 r0.2, 1, -0.1 r0.2]],
        frontoffset        = 0,
        fronttexture       = [[splashbase]],
        length             = [[8 r4]],
        sidetexture        = [[splashside]],
        size               = [[2 r1]],
        sizegrowth         = 1,
        ttl                = 12,
      },
    },
  },

}

