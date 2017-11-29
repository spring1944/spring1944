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
    footprintX  = 11,  -- 1 footprint unit = 16 elmo
    footprintZ  = 10,  -- 1 footprint unit = 16 elmo
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
    footprintX  = 4,  -- 1 footprint unit = 16 elmo
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
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
    footprintX  = 4,  -- 1 footprint unit = 16 elmo
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
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
    footprintX  = 5,  -- 1 footprint unit = 16 elmo
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
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
    footprintX  = 4,  -- 1 footprint unit = 16 elmo
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
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


defs["Factory_SmokeStack"] = {
    description    = "Factory_SmokeStack",
    object         = "Features/Factory_SmokeStack.dae",
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
    footprintX  = 3,  -- 1 footprint unit = 16 elmo
    footprintZ  = 3,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "cylY",
    collisionVolumeScales = {34, 212, 34},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesFactorySmokestack_normals.png",
    },
}
defs["Factory_001"] = {
    description    = "Factory_001",
    object         = "Features/Factory_001.dae",
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
    footprintX  = 7,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {100, 51, 53},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesFactory_normals.png",
    },
}
defs["Factory_002"] = {
    description    = "Factory_002",
    object         = "Features/Factory_002.dae",
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
    footprintX  = 8,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {122, 100, 86},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesFactory_normals.png",
    },
}
defs["Factory_003"] = {
    description    = "Factory_003",
    object         = "Features/Factory_003.dae",
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
    footprintX  = 8,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {122, 100, 86},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesFactory_normals.png",
    },
}

--------------------------------------------------------------------------------
-- Autogenerated houses
--------------------------------------------------------------------------------

defs["House_001"] = {
    description    = "House_001",
    object         = "Features/House_001.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 8,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {112, 109, 88},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_167.png",
    },
}

defs["House_002"] = {
    description    = "House_002",
    object         = "Features/House_002.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 9,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {136, 122, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_050.png",
    },
}

defs["House_003"] = {
    description    = "House_003",
    object         = "Features/House_003.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 6,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {88, 83, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_007.png",
    },
}

defs["House_004"] = {
    description    = "House_004",
    object         = "Features/House_004.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 9,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {136, 110, 88},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_179.png",
    },
}

defs["House_005"] = {
    description    = "House_005",
    object         = "Features/House_005.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 6,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {88, 102, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_042.png",
    },
}

defs["House_006"] = {
    description    = "House_006",
    object         = "Features/House_006.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 8,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {112, 80, 88},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_113.png",
    },
}

defs["House_007"] = {
    description    = "House_007",
    object         = "Features/House_007.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 6,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {88, 152, 88},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_099.png",
    },
}

defs["House_008"] = {
    description    = "House_008",
    object         = "Features/House_008.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 9,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {136, 92, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_191.png",
    },
}

defs["House_009"] = {
    description    = "House_009",
    object         = "Features/House_009.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 9,  -- 1 footprint unit = 16 elmo
    footprintZ  = 6,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {136, 74, 88},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_043.png",
    },
}


defs["House_010"] = {
    description    = "House_010",
    object         = "Features/House_010.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 9,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {136, 84, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_127.png",
    },
}

defs["House_011"] = {
    description    = "House_011",
    object         = "Features/House_011.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 6,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {88, 75, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_166.png",
    },
}

defs["House_012"] = {
    description    = "House_012",
    object         = "Features/House_012.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 6,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {88, 83, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_098.png",
    },
}

defs["House_013"] = {
    description    = "House_013",
    object         = "Features/House_013.dae",
    blocking       = true,
    burnable       = false,
    reclaimable    = false,
    noSelect       = false,
    indestructible = true,
    energy          = 0,
    damage          = 500000,
    metal           = 0,
    mass            = 50000,
    crushResistance = 5000,
    footprintX  = 8,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,  -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {112, 91, 64},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesHouseNormal_008.png",
    },
}


return lowerkeys( defs )
