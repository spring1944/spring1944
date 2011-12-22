-- bullet
-- bullet_miss

return {
  ["bullet"] = {
    usedefaultexplosions = false,
    miss = {
      class              = [[CExpGenSpawner]],
      count              = 1,
      nounit             = 1,
      properties = {
        delay              = 0,
        explosiongenerator = [[custom:Bullet_Miss]],
        pos                = [[0, 0,  0]],
      },
    },
  },

  ["bullet_miss"] = {
    ground = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 2,
      ground             = true,
      properties = {
        colormap           = [[0.5 0.4 0.3 1  0.05 0.04 0.03 0.1]],
        dir                = [[-0.1 r0.2, 1, -0.1 r0.2]],
        frontoffset        = 0,
        fronttexture       = [[splashbase]],
        length             = [[4 r8]],
        sidetexture        = [[splashside]],
        size               = [[1 r0.5]],
        sizegrowth         = 1,
        ttl                = 12,
      },
    },
    water = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 2,
      water              = true,
      properties = {
        colormap           = [[0.45 0.45 0.5 0.5  0.045 0.045 0.05 0.05]],
        dir                = [[-0.1 r0.2, 1, -0.1 r0.2]],
        frontoffset        = 0,
        fronttexture       = [[splashbase]],
        length             = [[4 r8]],
        sidetexture        = [[splashside]],
        size               = [[1 r0.5]],
        sizegrowth         = 1,
        ttl                = 12,
      },
    },
  },

}

