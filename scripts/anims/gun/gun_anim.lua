-- GUN

local ground = piece "ground"
local carriage = piece "carriage"
local wheels = piece "wheels"
local sleeve = piece "sleeve"
local barrel = piece "barrel"
local flare = piece "flare"

-- CREW

local crewman = {}
local i = 0
while true do
    i = i + 1
    local pstr = "crewman" .. tostring(i)
    local p = piece(pstr)
    if p == nil then
        break
    end
    crewman[i] = p
end

local tags = {
    headingPiece = carriage,
    pitchPiece = sleeve,
}

local anims = {
    run = {}
}

local poses = {
    ready = {},
    pinned = {},
    run = {},
                
    kf_fire_1 = {},
    kf_fire_2 = {},
    kf_fire_3 = {},
    
    kf_fire_4 = {},
    
    kf_fire_5 = {},
    
    kf_fire_6 = {},
}

local keyframes = {
    fire = {poses.kf_fire_1,
            poses.kf_fire_2,
            poses.kf_fire_3,
            poses.kf_fire_4,
            poses.kf_fire_5,
            poses.kf_fire_6,
            }
}

local keyframeDelays = {
    fire = {0.05, 0.1, 0.1, 0.5, 0.5, 0.5, 0.3},
}


return tags, poses, keyframes, keyframeDelays
