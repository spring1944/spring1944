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
    footprintX  = 2,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {4, 24, 36},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesWallRedBricks_normals.png",
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
    footprintX  = 2,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {4, 24, 72},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesWallRedBricks_normals.png",
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
        mod       = true,
        normaltex = "unittextures/FeaturesWallRedBricks_normals.png",
    },
}

wallDefs["WallFortress"] = {
    description    = "WallFortress",
    object         = "Features/WallFortress.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 50000,
    metal           = 0,
    mass            = 5000,
    crushResistance = 100,
    footprintX  = 2,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {16, 48, 72},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesWallFortress_normals.png",
    },
}

wallDefs["WallFortress_door"] = {
    description    = "WallFortress_door",
    object         = "Features/WallFortress_door.dae",
    blocking       = false,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 50000,
    metal           = 0,
    mass            = 5000,
    crushResistance = 100,
    footprintX  = 2,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {16, 8, 72},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesWallFortress_normals.png",
    },
}

wallDefs["WallFortress_corner"] = {
    description    = "WallFortress_corner",
    object         = "Features/WallFortress_corner.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 50000,
    metal           = 0,
    mass            = 5000,
    crushResistance = 100,
    footprintX  = 3,  -- 1 footprint unit = 16 elmo
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {36, 60, 36},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesWallFortress_normals.png",
    },
}

return lowerkeys( wallDefs )
