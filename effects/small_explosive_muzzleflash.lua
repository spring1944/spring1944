-- mortar_muzzleflash
-- faust_backblast
-- schrek_backblast

return {
  ["mortar_muzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 1 0 0.01	1 0.5 0 0.01	0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0.1,
        fronttexture       = [[shotgunflare]],
        length             = 2.5,
        sidetexture        = [[plasma2]],
        size               = 3,
        sizegrowth         = 1,
        ttl                = 4,
      },
    },
  },

  ["faust_backblast"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 1 0 0.01	1 0.5 0 0.01	0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0.1,
        fronttexture       = [[flowerflash]],
        length             = 8,
        sidetexture        = [[plasma2]],
        size               = 4,
        sizegrowth         = -0.5,
        ttl                = 4,
      },
    },
  },

  ["schrek_backblast"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 1 0 0.01	1 0.5 0 0.01	0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0.1,
        fronttexture       = [[shotgunflare]],
        length             = 5.5,
        sidetexture        = [[plasma2]],
        size               = 3,
        sizegrowth         = 1,
        ttl                = 4,
      },
    },
  },

}

