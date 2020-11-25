-- The Gun without crew members enough
local InfantryGun = Unit:New{
    category            = "MINETRIGGER OPENVEH",
    corpse              = "<NAME>_Destroyed",
    iconType            = "artillery",
    buildCostMetal      = 1300,
    damageModifier      = 0.265,
    footprintX          = 1,
    footprintZ          = 1,
    mass                = 100,
    maxDamage           = 300,
    repairable          = true,
    script              = "InfantryGun.lua",
    seismicDistance     = 0,
    seismicSignature    = 0, -- required, not default
    radardistance       = 1,
    airSightDistance    = 1,
    sightDistance       = 1,
    stealth             = true,
    upright             = true,

    capturable          = true,
    canSelfD            = false,

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
        feartarget               = true,
        soundcategory            = "<SIDE>/Infantry",
        wiki_parser              = "infantry",
        wiki_subclass_comments   = "",
        wiki_comments            = "",
        hasturnbutton            = true,
        maxammo                  = 4,
        infgun                   = true,
        pronespheremovemult      = 0.2,
        scriptAnimation          = "gun_anim",
    },

    weapons = {
        [1] = { -- Cannon
            maxAngleDif = 30,
        },
    },
}

return {
    InfantryGun = InfantryGun,
}
 
