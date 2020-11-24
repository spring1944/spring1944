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
	canStandFire = true,
	canRunFire = false,
	weaponPiece = piece "gun",
	showOnReady = true,
}

local stances = {
	stand_1 =	{
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-30)},
						{ruparm, y_axis, math.rad(20)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-70)},
						{luparm, y_axis, math.rad(25)},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-130)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},
						{lloarm, x_axis, math.rad(-80)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, math.rad(-40)},
						{gun,    x_axis, 0},
						{gun,    y_axis, 0},
						{gun,    z_axis, 0},
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	stand_2 = {
					turns = { -- Turns
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-40)},
						{ruparm, y_axis, math.rad(50)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-20)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-100)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(20)},
						{lloarm, x_axis, math.rad(-135)},
						{lloarm, y_axis, math.rad(-15)},
						{lloarm, z_axis, 0},
						{gun,    x_axis, 0},
						{gun,    y_axis, 0},
						{gun,    z_axis, 0},
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	stand_3 = {
					turns = { -- Turns
						{head, y_axis, 0},
						{head, x_axis, 0},
						{head, z_axis, 0},
						{ruparm, x_axis, math.rad(-40)},
						{ruparm, y_axis, math.rad(30)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-10)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, 0},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(20)},
						{lloarm, x_axis, math.rad(-40)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, math.rad(-20)},
						{gun, x_axis, 0},
						{gun, y_axis, 0},
						{gun, z_axis, 0},
						{torso, y_axis, 0},
						{torso, x_axis, 0},
						{torso, z_axis, 0},
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
	stand_aim = {
					turns = {
						{head, x_axis, math.rad(15)},
						{head, y_axis, 0},
						{head, z_axis, 0},

						{luparm, x_axis, math.rad(-45)},
						{luparm, y_axis, math.rad(10)},
						{luparm, z_axis, math.rad(-25)},
						
						{lloarm, x_axis, math.rad(10)},
						{lloarm, y_axis, math.rad(65)},
						{lloarm, z_axis, math.rad(-60)},

						{ruparm, x_axis, math.rad(-75)},
						{ruparm, y_axis, math.rad(80)},
						{ruparm, z_axis, math.rad(-55)},
						
						{rloarm, x_axis, math.rad(-10)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},

						{gun, x_axis, math.rad(5)},
						{gun, y_axis, math.rad(-10)},
						{gun, z_axis, math.rad(15)},

						{torso, y_axis, math.rad(-20)},
						{torso, z_axis, math.rad(5)},

						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},

						{rthigh, x_axis, math.rad(-5)},
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},

						{lthigh, x_axis, math.rad(10)},
						{lthigh, y_axis, 0},
						{lthigh, z_axis, 0},
						
						{rleg, x_axis, math.rad(-5)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, 0},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},

						{lfoot, x_axis, math.rad(-10)},
						{lfoot, y_axis, 0},
						{lfoot, z_axis, 0},
					},
					moves = {
						{pelvis, y_axis, 0},
					},
					headingTurn = {pelvis, y_axis, 0, 1},
					pitchTurn = {torso, x_axis, 0, -1},
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
	kf_stand_fire = {
					turns = {
						{rloarm , x_axis, math.rad(-20)},
					},
					emit = true,
	},
	kf_prone_fire = {
					turns = {
						{ruparm , x_axis, math.rad(-95)},
						{luparm , x_axis, math.rad(-150)},
					},
					emit = true,
	},
}

local keyframes = {
	stand_fire = {stances.kf_stand_fire},
	prone_fire = {stances.kf_prone_fire},
}

local keyframeDelays = {
	stand_fire = {0.033, 0.033},
	prone_fire = {0.033, 0.033},
}

local variants = {
	stand = { stances.stand_1,
					stances.stand_2,
					stances.stand_3},
	prone = { stances.prone},
	run = { stances.stand_1,
				  stances.stand_2,
				  stances.stand_3},
	stand_aim = { stances.stand_aim},
	prone_aim = { stances.prone_aim},
}

return tags, variants, keyframes, keyframeDelays
