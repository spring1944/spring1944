-- Default Spring Treedef

local wallDefs = {}

wallDefs["WallRedBricks"] = {
    description    = "WallRedBricks",
    object         = "Features/WallRedBricks.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 40,
    crushResistance = 14,
    footprintX  = 1,
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {4, 24, 36},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod = true,
    },
}

wallDefs["WallRedBricks_Large"] = {
    description    = "WallRedBricks_Large",
    object         = "Features/WallRedBricks_Large.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 40,
    crushResistance = 14,
    footprintX  = 1,
    footprintZ  = 5,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {4, 24, 72},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod = true,
    },
}

wallDefs["WallRedBricks_Corner"] = {
    description    = "WallRedBricks_Corner",
    object         = "Features/WallRedBricks_Corner.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 40,
    crushResistance = 14,
    footprintX  = 1,
    footprintZ  = 1,
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {6, 24, 6},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod = true,
    },
}

return lowerkeys( wallDefs )
