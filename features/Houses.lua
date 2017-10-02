-- Default Spring Treedef

local defs = {}

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
        mod = true,
    },
}

return lowerkeys( defs )
