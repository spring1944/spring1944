-- CREW
local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"
local flare = piece "flare"

local luparm = piece "luparm"
local lloarm = piece "lloarm"

local ruparm = piece "ruparm"
local rloarm = piece "rloarm"

local lthigh = piece "lthigh"
local lleg = piece "lleg"
local lfoot = piece "lfoot"

local rthigh = piece "rthigh"
local rleg = piece "rleg"
local rfoot = piece "rfoot"

-- MG
local gun = piece "gun"
local turret = piece "turret"
local tripod = piece "tripod"

local tags = {
	headingPiece = turret or gun,
	pitchPiece = turret or gun,
	defaultTraverseSpeed = math.rad(35),
	defaultElevateSpeed = math.rad(35),
}

local poses = {
	ready =	{
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-85)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-85)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, 0},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(25)},
						{lloarm, x_axis, 0},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, math.rad(-25)},
						{torso,  x_axis, math.rad(25)},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},
						{rthigh, x_axis, math.rad(-10)},
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},
						{lthigh, x_axis, math.rad(-90)},
						{lthigh, y_axis, 0},
						{lthigh, z_axis, 0},
						{rleg, x_axis, math.rad(110)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},
						{lleg, x_axis, math.rad(90)},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},
					},
					moves = {
						{pelvis, y_axis, -3.5},
					},					
				},
	pinned = {
					turns = {
						{head,   x_axis, math.rad(-30)},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-120)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, math.rad(-30)},
						
						{luparm, x_axis, math.rad(-120)},
						{luparm, y_axis, 0},
						{luparm, z_axis, math.rad(30)},

						{rloarm, x_axis, math.rad(-115)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(25)},
						
						{lloarm, x_axis, math.rad(-115)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, math.rad(-25)},

						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
						{pelvis, x_axis, math.rad(90)},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
						{rthigh, x_axis, math.rad(-5)},
						{rthigh, y_axis, math.rad(-70)},
						{rthigh, z_axis, 0},
						{lthigh, x_axis, math.rad(-5)},
						{lthigh, y_axis, math.rad(70)},
						{lthigh, z_axis, 0},
						{rleg, x_axis, 0},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},
						{lleg, x_axis, 0},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},
					},
					moves = {
						{pelvis, y_axis, -7},
					},	
				},
}

local keyframes = {
	fire = {}
}

local keyframeDelays = {
	fire = {0},
}


return tags, poses, keyframes, keyframeDelays