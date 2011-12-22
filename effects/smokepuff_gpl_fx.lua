-- smokepuff_gpl_smokespawn
-- smokepuff_gpl_fx
-- smokepuff_gpl_spawnsystem

return {
  ["smokepuff_gpl_smokespawn"] = {
    particlesystem_smokepuff_gpl_column_01_01 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 1.0,
        colormap           = [[1.0 0.7 0.5 1.0     0.4 0.4 0.4 1.0    0.3 0.3 0.3 1.0    0.2 0.2 0.2 1.0    0 0 0 0.01]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.001 r-0.002, 0.003, 0.001 r-0.002]],
        numparticles       = 1,
        particlelife       = 90,
        particlelifespread = 10,
        particlesize       = 1,
        particlesizespread = 0.25,
        particlespeed      = 0.000001,
        particlespeedspread = 0,
        pos                = [[0, 3, 0]],
        sizegrowth         = [[0.025 r0.05]],
        sizemod            = 1.0,
        texture            = [[GenericSmokeCloud]],
      },
    },
  },

  ["smokepuff_gpl_fx"] = {
    delayspawner01_smokepuff_gpl_smokecolumn = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        delay              = [[1 i1]],
        explosiongenerator = [[custom:SMOKEPUFF_GPL_SPAWNSYSTEM]],
      },
    },
  },

  ["smokepuff_gpl_spawnsystem"] = {
    delayspawner01_smokepuff_gpl_smokecolumn = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = [[10 r10]],
      ground             = true,
      water              = true,
      properties = {
        delay              = [[0 i1]],
        explosiongenerator = [[custom:SMOKEPUFF_GPL_SMOKESPAWN]],
      },
    },
  },

}

