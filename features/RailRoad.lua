-- Default Spring Treedef

local defs = {}

defs["RailStation_small"] = {
    description    = "RailStation_small",
    object         = "Features/TrainStation_small.dae",
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
    footprintX  = 10,  -- 1 footprint unit = 16 elmo
    footprintZ  = 4,   -- 1 footprint unit = 16 elmo
    upright =  true,
    floating = false,
    collisionVolumeTest = 1,
    collisionVolumeType = "box",
    collisionVolumeScales = {144, 64, 48},
    collisionVolumeOffsets = {0, 0, 0},
    customParams = {
        mod       = true,
        normaltex = "unittextures/FeaturesTrainStation_normals.png",
    },
}

return lowerkeys( defs )
