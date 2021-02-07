-- The Gun without crew members enough
local InfantryGun = Unit:New{
    category            = "MINETRIGGER DEPLOYED",
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
        damageGroup              = "guns",
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
}

local ATInfGun = InfantryGun:New{
    iconType            = "atartillery",
    buildCostMetal      = 840,

    weapons = {
        [1] = { -- AP
            maxAngleDif = 10,
        },
    },
    customParams = {
        wiki_subclass_comments = [[This unit is an Anti-Tank gun, which can
only engaged enemy vehicles. AT guns are quite inexpensive, so they can be
always considered to defend against vehicles.]],
    },
}

local FGInfGun = InfantryGun:New{
    buildCostMetal      = 1300,

    weapons = {
        [1] = { -- HE
            maxAngleDif = 5,
        },
        [2] = { -- AP
            maxAngleDif = 5,
        },
    },
    customParams = {
        weapontoggle           = "priorityAPHE",
        wiki_subclass_comments = [[This unit is a field gun, useful to both
hostigate infantry and defend against light vehicles.]],
    },
}

local HInfGun = InfantryGun:New{
    buildCostMetal      = 1800,
    maxVelocity         = 0.1,
    turnRate            = 30,

    weapons = {
        [1] = { -- HE
            maxAngleDif = 5,
        },
        [2] = { -- Smoke
            maxAngleDif = 5,
        },
    },
    customParams = {
        canAreaAttack          = true,
        weapontoggle           = "smoke",
        wiki_subclass_comments = [[This unit is a heavy gun, designed to inflict
significant damage at the enemy positions. When a heavy gun is directed against
an enemy building, it is a matter of time that such building becomes silenced.
Heavy guns can be also targeted against enemy static positions.]],
    },
}

local RInfGun = InfantryGun:New{
    buildCostMetal      = 3600,
    maxVelocity         = 0.1,
    turnRate            = 20,

    weapons = {
        [1] = { -- Rocket
            maxAngleDif = 5,
        },
    },
    customParams = {
        scriptAnimation        = "rocket",
        turretturnspeed        = 16,
        wiki_subclass_comments = [[This unit is a rockets launcher. Rockets are
an excellent way to deal heavy damage in little time. Unfortunatelly, rocket
launchers have not a long firing range, so they should be deployed dangerously
close to the enemy. On top of that, rocket launchers are usually expensive and
very ammo demanding.
But if you have a good chance to discharge rockets in the enemy position, you
definitively must do that.]],
    },
}

return {
    InfantryGun = InfantryGun,
    ATInfGun = ATInfGun,
    FGInfGun = FGInfGun,
    HInfGun = HInfGun,
    RInfGun = RInfGun,
}
 
