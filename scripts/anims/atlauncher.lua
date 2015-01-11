local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"
local gun = piece "gun"
local ground = piece "ground"
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

local tags, variants, keyframes, keyframeDelays = include "anims/rifle.lua"
tags.canStandFire = true
tags.canRunFire = false
tags.canProneFire = true
local stances = {
	stand_aim = {
					turns = {
						{head, x_axis, math.rad(0)},
						{head, y_axis, math.rad(40)},
						{head, z_axis, math.rad(20)},						
						
						{ruparm, x_axis, 0},
						{ruparm, y_axis, math.rad(60)},
						{ruparm, z_axis, 0},

						{luparm, x_axis, math.rad(-80)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, math.rad(-150)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},

						{lloarm, x_axis, math.rad(-60)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
						
						{gun, x_axis, math.rad(45)},
						{gun, y_axis, 0},
						{gun, z_axis, math.rad(-20)},

						{torso, y_axis, math.rad(-40)},
						{torso, z_axis, math.rad(-10)},

						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},

						{rthigh, x_axis, 0},
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},

						{lthigh, x_axis, math.rad(-80)},
						{lthigh, y_axis, 0},
						{lthigh, z_axis, 0},
						
						{rleg, x_axis, math.rad(90)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, math.rad(80)},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},

					},
					moves = {
						{pelvis, y_axis, -2},
					},
					headingTurn = {pelvis, y_axis, 0, 1},
					pitchTurn = {torso, x_axis, math.rad(10), -1},
				},
	stand_ready_1 =	{
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, math.rad(-60)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(20)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-40)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(120)},
						{lloarm, x_axis, math.rad(30)},
						{lloarm, y_axis, math.rad(80)},
						{lloarm, z_axis, math.rad(-115)},
						{gun,    x_axis, math.rad(20)},
						{gun,    y_axis, 0},
						{gun,    z_axis, math.rad(10)},
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	stand_ready_2 = {
					turns = { -- Turns
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, 0},
						{ruparm, x_axis, math.rad(-70)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, 0},
						{luparm, y_axis, math.rad(20)},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-40)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(110)},
						{lloarm, x_axis, math.rad(30)},
						{lloarm, y_axis, math.rad(100)},
						{lloarm, z_axis, math.rad(-70)},
						{gun, x_axis, math.rad(30)},
						{gun, y_axis, 0},
						{gun, z_axis, math.rad(20)},
						{torso, x_axis, 0},
						{torso, y_axis, 0},
						{torso, z_axis, 0},
					},
				},
}



variants.stand_aim = {stances.stand_aim}
variants.stand_ready = {stances.stand_ready_1, 
						stances.stand_ready_2}
variants.run_ready = {stances.stand_ready_1, 
						stances.stand_ready_2}

return tags, variants, keyframes, keyframeDelays