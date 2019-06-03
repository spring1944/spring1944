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

local tags = {
	canProneFire = true,
	canStandFire = false,
	canRunFire = false,
	weaponPiece = piece "gun",
	showOnReady = true,
}

local stances = {
	run_1 =	{
					turns = {
						{head,   x_axis, math.rad(-10)},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-45)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-70)},
						{luparm, y_axis, math.rad(5)},
						{luparm, z_axis, math.rad(-15)},
						{rloarm, x_axis, math.rad(-15)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},
						{lloarm, x_axis, math.rad(-75)},
						{lloarm, y_axis, math.rad(20)},
						{lloarm, z_axis, math.rad(-95)},
						{gun,    x_axis, math.rad(5)},
						{gun,    y_axis, math.rad(-5)},
						{gun,    z_axis, math.rad(175)},
						{torso,  x_axis, math.rad(10)},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	stand =	{
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, 0},
						{luparm, x_axis, 0},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, 0},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},
						{lloarm, x_axis, 0},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
						{gun,    x_axis, 0},
						{gun,    y_axis, 0},
						{gun,    z_axis, math.rad(-180)},
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	prone = {
					turns = { -- Turns
						{head, x_axis, math.rad(-60)},
						{head, y_axis, 0},
						{head, z_axis, 0},

						{ruparm, x_axis, math.rad(-80)},
						{ruparm, y_axis, math.rad(20)},
						{ruparm, z_axis, math.rad(-70)},

						{luparm, x_axis, math.rad(-140)},
						{luparm, y_axis, math.rad(-30)},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, math.rad(-120)},
						{rloarm, y_axis, math.rad(30)},
						{rloarm, z_axis, 0},

						{lloarm, x_axis, math.rad(20)},
						{lloarm, y_axis, math.rad(65)},
						{lloarm, z_axis, math.rad(-40)},
						
						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-35)},
						{gun, z_axis, math.rad(-45)},

						{torso, x_axis, math.rad(-10)},
						{torso, y_axis, math.rad(20)},
						{torso, z_axis, 0},
					},
				},
	prone_aim = {
					turns = { -- Turns
						{head, x_axis, math.rad(-60)},
						{head, y_axis, 0},
						{head, z_axis, 0},

						{ruparm, x_axis, math.rad(-80)},
						{ruparm, y_axis, math.rad(20)},
						{ruparm, z_axis, math.rad(-70)},

						{luparm, x_axis, math.rad(-140)},
						{luparm, y_axis, math.rad(-30)},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, math.rad(-120)},
						{rloarm, y_axis, math.rad(30)},
						{rloarm, z_axis, 0},

						{lloarm, x_axis, math.rad(20)},
						{lloarm, y_axis, math.rad(65)},
						{lloarm, z_axis, math.rad(-40)},
						
						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-35)},
						{gun, z_axis, math.rad(-45)},

						{torso, x_axis, math.rad(-10)},
						{torso, y_axis, math.rad(20)},
						{torso, z_axis, 0},
					},
					headingTurn = {pelvis, y_axis, 0, 1},
					pitchTurn = {torso, x_axis, math.rad(-10), -0.5},
				},
	kf_prone_fire = {
					turns = {
						{ruparm , x_axis, math.rad(-88)},
						{luparm , x_axis, math.rad(-148)},
					},
					emit = true,
	},
}

local keyframes = {
	prone_fire = {stances.kf_prone_fire},
}

local keyframeDelays = {
	prone_fire = {0.033, 0.033},
}

local variants = {
	stand = {stances.stand},
	prone = {stances.prone},
	run = {stances.run_1},
	stand_aim = {stances.stand_aim},
	prone_aim = {stances.prone_aim},
	run_aim = {stances.run_aim},
}

return tags, variants, keyframes, keyframeDelays
