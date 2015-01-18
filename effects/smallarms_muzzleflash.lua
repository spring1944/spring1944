-- rifle_muzzleflash
-- pistol_muzzleflash
-- smg_muzzleflash
-- mg_shellcasings
-- ptrd_muzzleflash
-- mg_muzzleflash

return {
  ["rifle_muzzleflash"] = {
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
        length             = 2.25,
        sidetexture        = [[plasma2]],
        size               = 1.75,
        sizegrowth         = 1,
        ttl                = 4,
      },
    },
  },

  ["pistol_muzzleflash"] = {
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
        length             = 3.5,
        sidetexture        = [[plasma2]],
        size               = 2.5,
        sizegrowth         = -0.5,
        ttl                = 4,
      },
    },
  },

  ["smg_muzzleflash"] = {
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
        length             = 3.5,
        sidetexture        = [[plasma2]],
        size               = 2.5,
        sizegrowth         = -0.5,
        ttl                = 4,
      },
    },
  },

  ["mg_shellcasings"] = {
    usedefaultexplosions = false,
    sparks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 0.01   1 1 1 0.01   1 1 1 0.01   0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 20,
        emitvector         = [[dir]],
        gravity            = [[0, -0.1, 0]],
        numparticles       = 1,
        particlelife       = 15,
        particlelifespread = 0,
        particlesize       = 0.25,
        particlesizespread = 0,
        particlespeed      = 2.5,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[shell]],
      },
    },
  },

  ["ptrd_muzzleflash"] = { -- TODO: rename to atr_muzzleflash
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
        length             = 3.375,
        sidetexture        = [[plasma2]],
        size               = 2.6,
        sizegrowth         = 1,
        ttl                = 4,
      },
    },
  },

  ["mg_muzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      groundflash = {
        circlealpha        = 1,
        circlegrowth       = 0,
        color              = [[1,0.7,0]],
        flashalpha         = 0.9,
        flashsize          = 10,
        ttl                = 3,
      },
      properties = {
        colormap           = [[1 1 0 0.01	1 0.5 0 0.01	0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0.1,
        fronttexture       = [[flowerflash]],
        length             = 3,
        sidetexture        = [[plasma2]],
        size               = 2.25,
        sizegrowth         = 1,
        ttl                = 3,
      },
    },
  },

}

