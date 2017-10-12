-- Default Spring Treedef

local defs = {}

defs["Fountain"] = {
    description    = "Fountain",
    object         = "Features/Fountain.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = false,
    energy          = 0,
    damage          = 10000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 16,
    footprintX  = 2,  -- 1 footprint unit = 16 elmo
    footprintZ  = 2,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "cylY",
    collisionVolumeScales = {32, 4, 32},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesConcrete_normals.png",
    },
}

defs["HouseMansion"] = {
    description    = "HouseMansion",
    object         = "Features/HouseMansion.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 100000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 168 / 16,  -- 1 footprint unit = 16 elmo
    footprintZ  = 149 / 16,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {168, 80, 149},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseMansion_normals.png",
    },
}

defs["HouseMedieval_001"] = {
    description    = "HouseMedieval_001",
    object         = "Features/MedievalHouse_001.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 100000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 69 / 16,  -- 1 footprint unit = 16 elmo
    footprintZ  = 40 / 16,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {69, 50, 40},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesMedievalHouse_normals.png",
    },
}
defs["HouseMedieval_002"] = {
    description    = "HouseMedieval_002",
    object         = "Features/MedievalHouse_002.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 100000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 57 / 16,  -- 1 footprint unit = 16 elmo
    footprintZ  = 38 / 16,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {57, 44, 38},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesMedievalHouse_normals.png",
    },
}
defs["HouseMedieval_003"] = {
    description    = "HouseMedieval_003",
    object         = "Features/MedievalHouse_003.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 100000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 69 / 16,  -- 1 footprint unit = 16 elmo
    footprintZ  = 44 / 16,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {69, 41, 44},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesMedievalHouse_normals.png",
    },
}
defs["HouseMedieval_004"] = {
    description    = "HouseMedieval_004",
    object         = "Features/MedievalHouse_004.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 100000,
    metal           = 0,
    mass            = 10000,
    crushResistance = 1000,
    footprintX  = 65 / 16,  -- 1 footprint unit = 16 elmo
    footprintZ  = 44 / 16,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {65, 41, 44},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesMedievalHouse_normals.png",
    },
}


return lowerkeys( defs )
