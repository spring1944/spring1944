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
        normaltex = "unittextures/FeaturesSilo_normals_normals.png",
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
        normaltex = "unittextures/FeaturesStorages_normals_normals.png",
    },
}

return lowerkeys( defs )
