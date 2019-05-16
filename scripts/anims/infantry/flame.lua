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
	canRunFire = true,
	weaponPiece = piece "gun",
	showOnReady = true,
}

local stances = {
	run_1 = {
					turns = {
						{head,   x_axis, math.rad(-20)},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-50)},
						{ruparm, y_axis, math.rad(-90)},
						{ruparm, z_axis, math.rad(30)},
						{luparm, x_axis, 0},
						{luparm, y_axis, math.rad(5)},
						{luparm, z_axis, math.rad(10)},
						{rloarm, x_axis, math.rad(-45)},
						{rloarm, y_axis, math.rad(30)},
						{rloarm, z_axis, math.rad(100)},
						{lloarm, x_axis, math.rad(-205)},
						{lloarm, y_axis, math.rad(-90)},
						{lloarm, z_axis, math.rad(95)},
						{gun,    x_axis, 0},
						{gun,    y_axis, math.rad(10)},
						{gun,    z_axis, math.rad(25)},
						{torso,  x_axis, math.rad(20)},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	stand = {
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-70)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(25)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-40)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(110)},
						{lloarm, x_axis, math.rad(-95)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
						{gun,    x_axis, math.rad(30)},
						{gun,    y_axis, 0},
						{gun,    z_axis, math.rad(20)},
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
	stand_aim = {
					turns = {
						{head, x_axis, math.rad(15)},
						{head, y_axis, math.rad(70)},
						{head, z_axis, math.rad(20)},
						
						{ruparm, x_axis, math.rad(-35)},
						{ruparm, y_axis, math.rad(90)},
						{ruparm, z_axis, math.rad(-50)},

						{luparm, x_axis, math.rad(-65)},
						{luparm, y_axis, math.rad(60)},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, math.rad(-80)},
						{rloarm, y_axis, math.rad(-10)},
						{rloarm, z_axis, math.rad(25)},

						{lloarm, x_axis, math.rad(-50)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, math.rad(-30)},
						
						{gun, x_axis, math.rad(15)},
						{gun, y_axis, math.rad(-60)},
						{gun, z_axis, math.rad(-30)},

						{torso, y_axis, math.rad(20)},
						{torso, z_axis, math.rad(10)},

						{pelvis, x_axis, 0},
						{pelvis, z_axis, math.rad(-10)},

						{rthigh, x_axis, math.rad(5)},
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},

						{lthigh, x_axis, math.rad(-15)},
						{lthigh, y_axis, 0},
						{lthigh, z_axis, math.rad(25)},
						
						{rleg, x_axis, math.rad(5)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, math.rad(20)},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},

					},
					moves = {
						{pelvis, y_axis, 0},
					},
					headingTurn = {pelvis, y_axis, math.rad(-90), 1},
					pitchTurn = {torso, x_axis, math.rad(-5), -1},
				},
	run_aim   = {
					turns = { -- Turns
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, 0},
						
						{ruparm, x_axis, math.rad(50)},
						{ruparm, y_axis, math.rad(43)},
						{ruparm, z_axis, 0},

						{luparm, x_axis, math.rad(-60)},
						{luparm, y_axis, math.rad(-25)},
						{luparm, z_axis, 0},

						{rloarm, x_axis, math.rad(-120)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},

						{lloarm, x_axis, math.rad(-15)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, math.rad(-25)},

						{gun, x_axis, math.rad(-20)},
						{gun, y_axis, 0},
						{gun, z_axis, math.rad(-40)},
						
					},
					moves = { -- Moves
						{pelvis, y_axis, 0, 100},
					},
					headingTurn = {torso, y_axis, 0, 1},
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
	},
	kf_run_fire = {
	},
	kf_prone_fire = {
	},
}

local keyframes = {
	stand_fire = {stances.kf_stand_fire},
	run_fire = {stances.kf_run_fire},
	prone_fire = {stances.kf_prone_fire},
}

local keyframeDelays = {
	stand_fire = {0.033, 0.033},
	run_fire = {0.033, 0.033},
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
