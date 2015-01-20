local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"
local binoculars = piece "binoculars"
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
	weaponPiece = piece "binoculars",
	showOnReady = true,
}

local stances = {
	stand_aim = {
					turns = {
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, 0},

						{luparm, x_axis, math.rad(-70)},
						{luparm, y_axis, math.rad(20)},
						{luparm, z_axis, 0},
						
						{lloarm, x_axis, math.rad(-110)},
						{lloarm, y_axis, math.rad(-35)},
						{lloarm, z_axis, 0},
						
						{binoculars, x_axis, math.rad(-10)},
						{binoculars, y_axis, math.rad(10)},
						{binoculars, z_axis, math.rad(30)},

						{torso, y_axis, 0},
						{torso, z_axis, 0},

						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},

						{rthigh, x_axis, 0},
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},

						{lthigh, x_axis, 0},
						{lthigh, y_axis, 0},
						{lthigh, z_axis, 0},
						
						{rleg, x_axis, 0},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, 0},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},

					},
					moves = {
						{pelvis, y_axis, 0},
					},
					headingTurn = {pelvis, y_axis, 0, 1},
					pitchTurn = {torso, x_axis, 0, -1},
				},
}

local variants = {
	stand_aim = { stances.stand_aim},
}

return tags, variants