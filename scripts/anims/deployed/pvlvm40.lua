-- CREW
local crewman = piece "crewman"
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
local turret = piece "turret"
local sleeve = piece "sleeve"


local tags = {
	headingPiece = turret,
	pitchPiece = sleeve,
}

local poses = {
	ready =	{
				},
	pinned = {
				},
	
}

local keyframes = {
}

local keyframeDelays = {
}


return tags, poses, keyframes, keyframeDelays