local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"

local mortarbase = piece "mortarbase"
local mortartube = piece "mortartube"
local mortarstand = piece "mortarstand"

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
	canProneFire = false,
	canStandFire = true,
	canRunFire = false,
	weaponPiece = piece "gun",
	showOnReady = true,
}

local anims = {
	run = {
				{ --frame 1
					turns = { -- Turns
						{rleg, x_axis, math.rad(85), math.rad(540)},
						{lleg, x_axis, math.rad(10), math.rad(630)},
						{lthigh, x_axis, math.rad(30), math.rad(270)},
						{rthigh, x_axis, math.rad(-60), math.rad(270)},
						{torso, y_axis, math.rad(10), math.rad(90)},
					},
					moves = {
						{pelvis, y_axis, 0, 5},
						{mortarbase, y_axis, 10, 5},
					},
				},
				{ --frame 2
					moves = {
						{pelvis, y_axis, 1, 5},
						{mortarbase, y_axis, 11, 5},
					},
				},
				{ --frame 3
					turns = {
						{rleg, x_axis, math.rad(10), math.rad(630)},
						{lleg, x_axis, math.rad(85), math.rad(540)},
						{lthigh, x_axis, math.rad(-60), math.rad(270)},
						{rthigh, x_axis, math.rad(30), math.rad(270)},
						{torso, y_axis, math.rad(-10), math.rad(90)},
					},
					moves = {
						{pelvis, y_axis, 0, 5},
						{mortarbase, y_axis, 10, 5},
					},
				},
				{ --frame 4
					moves = {
						{pelvis, y_axis, 1, 5},
						{mortarbase, y_axis, 11, 5},
					},
				},
				wait = {5,6},
			},
}

local stances = {
	sit = {
		turns = {
			{rthigh, x_axis, -math.rad(90)},
			{lthigh, x_axis, -math.rad(90)},
			{rleg, x_axis, math.rad(90)},
			{lleg, x_axis, math.rad(90)},
			{mortarbase, x_axis, math.rad(270)},
			{mortarbase, y_axis, math.rad(90)},
			{mortarbase, z_axis, 0},
			{ruparm, x_axis, 0},
			{ruparm, y_axis, 0},
			{ruparm, z_axis, 0},
			{rloarm, x_axis, 0},
			{rloarm, y_axis, 0},
			{rloarm, z_axis, 0},
			{luparm, x_axis, 0},
			{luparm, y_axis, 0},
			{luparm, z_axis, 0},
			{lloarm, x_axis, 0},
			{lloarm, y_axis, 0},
			{lloarm, z_axis, 0},
			{head, x_axis, 0},
			{head, y_axis, 0},
			{head, z_axis, 0},
		},
		moves = {
			{pelvis, y_axis, -6},
			{mortarbase, x_axis, 2.3},
			{mortarbase, y_axis, 0},
			{mortarbase, z_axis, -4},
		},
	},
	stand =	{
					turns = {
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, math.rad(-30)},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-20)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-20)},
						{rloarm, y_axis, math.rad(-80)},
						{rloarm, z_axis, math.rad(140)},
						{lloarm, x_axis, 0},
						{lloarm, y_axis, math.rad(50)},
						{lloarm, z_axis, math.rad(-60)},
						{mortarbase, x_axis, math.rad(-140)},
						{mortarbase, y_axis, math.rad(25)},
						{mortarbase, z_axis, math.rad(-60)},
						{mortartube, x_axis, 0},
						{mortartube, y_axis, 0},
						{mortartube, z_axis, 0},
						{mortarstand, x_axis, 0},
						{mortarstand, y_axis, 0},
						{mortarstand, z_axis, 0},
						{torso, y_axis, 0},
						{torso, x_axis, 0},
						{torso, z_axis, 0},
						{pelvis, x_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
					},
					moves = {
						{mortarbase, y_axis, 10},
						{mortarbase, z_axis, 0},
					},
				},
	run =	{
					turns = {
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, math.rad(-30)},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(-20)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-20)},
						{rloarm, y_axis, math.rad(-80)},
						{rloarm, z_axis, math.rad(140)},
						{lloarm, x_axis, 0},
						{lloarm, y_axis, math.rad(50)},
						{lloarm, z_axis, math.rad(-60)},
						{mortarbase, x_axis, math.rad(-140)},
						{mortarbase, y_axis, math.rad(25)},
						{mortarbase, z_axis, math.rad(-60)},
						{mortartube, x_axis, 0},
						{mortartube, y_axis, 0},
						{mortartube, z_axis, 0},
						{mortarstand, x_axis, 0},
						{mortarstand, y_axis, 0},
						{mortarstand, z_axis, 0},
						{torso, y_axis, 0},
						{torso, x_axis, 0},
						{torso, z_axis, 0},
						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},
					},
					moves = {
						{mortarbase, z_axis, 0},
					},
					anim = anims.run,
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
						
						{mortarbase, x_axis, 0},
						{mortarbase, y_axis, math.rad(90)},
						{mortarbase, z_axis, 0},

						{torso, x_axis, math.rad(-10)},
						{torso, y_axis, math.rad(20)},
						{torso, z_axis, 0},
					},
					moves = {
						{mortarbase, x_axis, 0},
						{mortarbase, y_axis, 0},
						{mortarbase, z_axis, 3.2},
					},
				},
	stand_aim = {
					turns = {
						{head, x_axis, math.rad(10)},
						{head, y_axis, 0},
						{head, z_axis, 0},
						
						{ruparm, x_axis, math.rad(-40)},
						{ruparm, y_axis, math.rad(15)},
						{ruparm, z_axis, 0},

						{luparm, x_axis, math.rad(-90)},
						{luparm, y_axis, math.rad(-20)},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, 0}, 
						{rloarm, y_axis, 0}, 
						{rloarm, z_axis, 0}, 

						{lloarm, x_axis, 0},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
						
						{mortarbase, x_axis, 0},
						{mortarbase, y_axis, 0},
						{mortarbase, z_axis, 0},

						{mortarstand, x_axis, math.rad(-50)},						
						
						{torso, x_axis, 0, math.rad(100)},
						{torso, y_axis, 0},

						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},

						{rthigh, x_axis, 0},
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},

						{lthigh, x_axis, math.rad(-100)},
						{lthigh, y_axis, 0},
						{lthigh, z_axis, 0},
						
						{rleg, x_axis, math.rad(110)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, math.rad(100)},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},

					},
					moves = {
						{pelvis, y_axis, -3.2},
						{mortarbase, x_axis, 0},
						{mortarbase, y_axis, 0},
						{mortarbase, z_axis, 0},

					},
					headingTurn = {ground, y_axis, 0, 1},
					pitchTurn = {mortartube, x_axis, 0, -1},
				},
	kf_stand_fire_1 = {
					turns = {
						{head, x_axis, math.rad(30)},
						
						{ruparm, x_axis, math.rad(-30)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, 0},
						
						{luparm, x_axis, math.rad(-30)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, math.rad(-150)},
						{rloarm, y_axis, math.rad(40)},
						{rloarm, z_axis, 0},
						
						{lloarm, x_axis, math.rad(-150)},
						{lloarm, y_axis, math.rad(-40)},
						{lloarm, z_axis, 0},
						
						{torso, y_axis, math.rad(-40)},
					},
					emit = true,
	},
	kf_stand_fire_2 = {
		--delay
	},
}

local keyframes = {
	stand_fire = {stances.kf_stand_fire_1,
	              stances.kf_stand_fire_2},
}

local keyframeDelays = {
	stand_fire = {0.2, 0.5, 0.2},
}

local variants = {
	sit = {stances.sit},
	stand = {stances.stand},
	prone = {stances.prone},
	run = {stances.run},
	stand_aim = {stances.stand_aim},
	pinned = {stances.prone},
}

return tags, variants, keyframes, keyframeDelays