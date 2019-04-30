-- The Gun without crew members enough
local NewInfGun = Unit:New{
    airSightDistance    = 2000,
    category            = "INFANTRY MINETRIGGER",
    corpse              = "<NAME>_Destroyed",
    iconType            = "artillery",
    damageModifier      = 0.265,
    footprintX          = 2,
    footprintZ          = 2,
    mass                = 100,
    maxDamage           = 300,
    radardistance       = 650,
    repairable          = true,
    script              = "NewInfGun.lua",
    seismicDistance     = 1400,
    seismicSignature    = 0, -- required, not default
    sightDistance       = 650,
    stealth             = true,
    upright             = true,

    capturable          = true,

    canMove             = true,  -- Cannot move without crew
    acceleration        = 0.2,
    brakeRate           = 0.6,    

    flankingBonusMax    = 1.5,
    flankingBonusMin    = 0.675,
    flankingBonusMobilityAdd = 0.01,
    flankingBonusMode   = 1,

    maxVelocity         = 0.75,
    movementClass       = "KBOT_Gun",
    noChaseCategory     = "FLAG AIR MINE",
    turnRate            = 120,

    -- We need to can load crew members
    loadingRadius       = 120,
    releaseHeld         = false,
    transportCapacity   = 2,
    transportMass       = 100,  -- Edit according to transportCapacity
    transportSize       = 1,
    unloadSpread        = 3,

    customParams = {
        damageGroup              = "armouredvehicles",
        armor_front              = 1,
        immobilizationresistance = 1.0,
        feartarget             = true,
        soundcategory          = "<SIDE>/Infantry",
        pronespheremovemult    = 0.4,
        wiki_parser            = "infantry",
        wiki_subclass_comments = "",
        wiki_comments          = "",
        hasturnbutton          = true,
        maxammo                = 4,
        infgun                 = true,
        pronespheremovemult    = 0.2,
        scriptAnimation        = "gun_anim",
    },

    weapons = {
        [1] = { -- Cannon
            maxAngleDif = 30,
        },
    },
}

return {
    NewInfGun = NewInfGun,
}
 
