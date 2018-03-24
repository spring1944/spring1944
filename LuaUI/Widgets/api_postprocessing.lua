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

local tonemapping = {
    texture = nil,
    shader = nil,
    gamma = 0.75,
    dGamma = 1.0,
    gammaLoc = nil,
}

local filmgrain = {
    texture = nil,
    shader = nil,
    grain = 0.02,
    widthLoc = nil,
    heightLoc = nil,
    timerLoc = nil,
    widthLoc = nil,
    grainLoc = nil,
}

local scratches = {
    texture = nil,
    shader = nil,
    threshold = filmgrain.grain * filmgrain.grain * filmgrain.grain * 2000,
    thresholdLoc = nil,
    randomLoc = nil,
    timerLoc = nil,
}

local vignette = {
    texture = nil,
    shader = nil,
    vignette = {0.3, 1.0},
    vignetteLoc = nil
}

local aberration = {
    texture = nil,
    shader = nil,
    aberration = 0.1,
    widthLoc = nil,
    heightLoc = nil,
    aberrationLoc = nil
}

function widget:Initialize()
    WG.POSTPROC = {
        tonemapping = {
            texture = nil,
            shader = nil,
            gamma = 0.75,
            dGamma = 0.5,
            gammaLoc = nil,
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
            threshold = filmgrain.grain * filmgrain.grain * filmgrain.grain * 2000,
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
end

function widget:Shutdown()
    -- Don't release the generated WG data, it would break another widgets
    -- WG.POSTPROC = nil
end
