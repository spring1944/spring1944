-- Default Spring Treedef

local defs = {}


defs["Silo"] = {
    description    = "Silo",
    object         = "Features/Silo.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 300000,
    metal           = 0,
    mass            = 30000,
    crushResistance = 3000,
    footprintX  = 36 / 16,  -- 1 footprint unit = 16 elmo
    footprintZ  = 36 / 16,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "cylY",
    collisionVolumeScales = {36, 80, 36},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesSilo_normals.png",
    },
}

defs["Storage_001"] = {
    description    = "Storage_001",
    object         = "Features/Storage_001.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 10000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 98 / 16,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 55 / 16,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {98, 33, 55},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Storage_002"] = {
    description    = "Storage_002",
    object         = "Features/Storage_002.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 10000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 98 / 16,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 55 / 16,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {98, 41, 55},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Storage_Open"] = {
    description    = "Storage_Open",
    object         = "Features/Storage_Open.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 10000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {98, 12, 55},
    collisionVolumeOffsets = {0, 21, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Storage_Open_002"] = {
    description    = "Storage_Open_002",
    object         = "Features/Storage_Open_002.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 10000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {98, 12, 55},
    collisionVolumeOffsets = {0, 29, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Crate_001"] = {
    description    = "Crate_001",
    object         = "Features/Crate_001.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 1000,
    crushResistance = 10,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {3.4, 3.4, 3.4},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Crate_002"] = {
    description    = "Crate_002",
    object         = "Features/Crate_002.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 1000,
    crushResistance = 10,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {6, 6, 6},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Crates_001"] = {
    description    = "Crates_001",
    object         = "Features/Crates_001.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 1000,
    crushResistance = 10,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {10, 7, 10},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Crates_002"] = {
    description    = "Crates_002",
    object         = "Features/Crates_002.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 1000,
    crushResistance = 10,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {13, 9, 13},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}

defs["Crates_003"] = {
    description    = "Crates_003",
    object         = "Features/Crates_003.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 1000,
    metal           = 0,
    mass            = 1000,
    crushResistance = 10,
    footprintX  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    footprintZ  = 1,  -- 1 footprint unit = 16 elmo (no blocking)
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {13, 11.5, 13},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesStorages_normals.png",
    },
}


return lowerkeys( defs )
