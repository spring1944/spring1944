-- spam_config.lua
     
-- s44 spam configuration file
     
return {
    max_units = 100, -- Maximum amount of units a ai instance will have at once
    wait = 300, -- Time before the ai begins its attack
    metal_income = 20, -- Its nominal metal income
    energy_income = 20, -- Its nominal energy income
    hq_build_speed = 500, --
    hq_hp = 1000000, -- Initial health of the spam hq
    hq_bonus_multiplier = 2, --
    hq_los = 512,
    hq_range = 1024, -- Range of all 4 lasers
    hq_damage = 100, -- Damage for each of the 4 lasers with beamtime 0.25 and reload time 1.0
    unit_bonus_multiplier = 0.25,
    warning = "Ready or not here they come!",
 
    build_order = {{"gbrrifle", 100}, -- First entry is the unit name to be produced and the later is the likelyhood of it spawning
                   {"rusppsh", 85},
                   {"germg42", 65},
                   {"usbazooka", 45},
                   {"gbrcommando", 20},
                   {"gbrstaghound", 75},
                   {"usflamethrower", 35},
                   {"gersdkfz250", 60},
                   {"gerpuma", 50},
                   {"jpnhago", 40},
                   {"rusvalentine", 30},
                   {"gbrcommando", 20},
                   {"itasemovente90", 55},
                   {"uslvta4", 50},
                   {"usm7priest", 35},
                   {"swestrvm41", 40},
                   {"hunhetzer", 35},
                   {"rusisu152", 20},
                   {"usm4a3105sherman", 15},
                   {"rust3485", 10},
                   {"gertigerii", 5},
    }
}

