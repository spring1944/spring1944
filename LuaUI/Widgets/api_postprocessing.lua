function widget:GetInfo()
    return {
        name = "Post-processing API",
        desc = "Post-processing effects data storage (DO NOT DISABLE)",
        author = "Jose Luis Cercos-Pita",
        date = "24-3-2018",
        license = "GPLv2",
        layer = -math.huge,
        enabled = true,
        handler = true,
        api = true,
        alwaysStart = true,
    }
end

WG.POSTPROC = {
    tonemapping = {
        texture = nil,
        shader = nil,
        gamma = 0.75,
        dGamma = 0.0,
        gammaLoc = nil,
    },
    grayscale = {
        texture = nil,
        shader = nil,
        enabled = false,
        sepia = 0.5,
        sepiaLoc = nil,
    },
    filmgrain = {
        texture = nil,
        shader = nil,
        grain = 0.02,
        widthLoc = nil,
        heightLoc = nil,
        timerLoc = nil,
        widthLoc = nil,
        grainLoc = nil,
    },
    scratches = {
        texture = nil,
        shader = nil,
        threshold = 0.0,
        thresholdLoc = nil,
        randomLoc = nil,
        timerLoc = nil,
    },
    vignette = {
        texture = nil,
        shader = nil,
        vignette = {0.3, 1.0},
        vignetteLoc = nil,
    },
    aberration = {
        texture = nil,
        shader = nil,
        aberration = 0.1,
        widthLoc = nil,
        heightLoc = nil,
        aberrationLoc = nil,
    },
}

function widget:Initialize()
end

function widget:Shutdown()
end

function widget:GetConfigData(data)
    return {
        gamma      = WG.POSTPROC.tonemapping.gamma,
        dgamma     = WG.POSTPROC.tonemapping.dGamma,
        grain      = WG.POSTPROC.filmgrain.grain,
        scratches  = WG.POSTPROC.scratches.threshold,
        vignette   = WG.POSTPROC.vignette.vignette[2],
        aberration = WG.POSTPROC.aberration.aberration,
        grayscale  = WG.POSTPROC.grayscale.enabled,
        sepia      = WG.POSTPROC.grayscale.sepia
    }
end

function widget:SetConfigData(data)
    WG.POSTPROC.tonemapping.gamma     = data.gamma      or WG.POSTPROC.tonemapping.gamma
    WG.POSTPROC.tonemapping.dGamma    = data.dgamma     or WG.POSTPROC.tonemapping.dGamma
    WG.POSTPROC.filmgrain.grain       = data.grain      or WG.POSTPROC.filmgrain.grain
    WG.POSTPROC.scratches.threshold   = data.scratches  or WG.POSTPROC.scratches.threshold
    WG.POSTPROC.vignette.vignette[2]  = data.vignette   or WG.POSTPROC.vignette.vignette[2]
    WG.POSTPROC.aberration.aberration = data.aberration or WG.POSTPROC.aberration.aberration
    WG.POSTPROC.grayscale.enabled     = data.grayscale  or WG.POSTPROC.grayscale.enabled
    WG.POSTPROC.grayscale.sepia       = data.sepia      or WG.POSTPROC.grayscale.sepia
end
