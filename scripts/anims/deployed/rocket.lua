-- CREW
local crewman1 = piece "crewman1"
local head1 = piece "head1"
local torso1 = piece "torso1"
local pelvis1 = piece "pelvis1"

local luparm1 = piece "luparm1"
local lloarm1 = piece "lloarm1"

local ruparm1 = piece "ruparm1"
local rloarm1 = piece "rloarm1"

local lthigh1 = piece "lthigh1"
local lleg1 = piece "lleg1"

local rthigh1 = piece "rthigh1"
local rleg1 = piece "rleg1"

-- GUN
local base = piece "base"
local carriage = piece "carriage"
local backblast = piece "backblast"
local tubes = piece "tubes"


local tags, poses, keyframes, keyframeDelays = include "anims/deployed/gun.lua"
tags.pitchPiece = tubes
tags.defaultTraverseSpeed = math.rad(3)
tags.defaultElevateSpeed = math.rad(10)

return tags, poses, keyframes, keyframeDelays