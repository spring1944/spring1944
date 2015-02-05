-- CREW
local crewman1 = piece "crewman1"
local crewman2 = piece "crewman2"

-- GUN
local base = piece "base"
local stand = piece "stand"
local turret = piece "turret"
local sleeve = piece "sleeve"
local barrel = piece "barrel"
local flare = piece "flare"

local tags = {
	headingPiece = turret,
	pitchPiece = sleeve,
	defaultTraverseSpeed = math.rad(800),
	defaultElevateSpeed = math.rad(615),
}

local poses
if crewman1 and crewman2 then
	poses = {
		ready =	{
						turns = {
							{crewman1, x_axis, 0},
							{crewman2, x_axis, 0},
						},
					},
		pinned = {
							{crewman1, x_axis, math.rad(70)},
							{crewman2, x_axis, math.rad(70)},
					},
		
	}
else
	poses = {
		ready =	{
						turns = {
						},
					},
		pinned = {
					},
		
	}
end

local keyframes = {
	fire = {}
}

local keyframeDelays = {
	fire = {0},
}


return tags, poses, keyframes, keyframeDelays