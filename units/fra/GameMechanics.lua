local fraFlag = Null:New{
    name              = "fraFlag",
    description       = "Flag decorator (US)",
    activateWhenBuilt = true,
    hideDamage        = true,
    iconType          = "none",
    levelGround       = false,
    maxVelocity       = 0,
    objectName        = "GEN/fraflag.dae",
    script            = "FlagDeco.lua", -- atm defaults to .cob
    sightDistance     = 0,
    windGenerator     = 0.00001, -- needed for WindChanged callin
    yardmap           = "y",
    customParams = {
        dontCount = 1,
        flag      = false,
        normaltex = "unittextures/flag-nullnormals.png",
    },
}

return lowerkeys({
    ["fraFlag"] = fraFlag,
})
