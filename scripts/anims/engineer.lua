local head = piece "head"
local torso = piece "torso"
local pelvis = piece "pelvis"
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

local detector = piece "detector"
Spring.Echo("bla", detector)

local MUZZLEFLASH = 1024 + 7

local tags = {
	canProneFire = false,
	canStandFire = true,
	canRunFire = false,
	weaponPiece = detector,
	showOnReady = false,
}
local anims = {
	run = {
				{ --frame 1
					turns = { -- Turns
						{ruparm, x_axis, math.rad(60), math.rad(270)},
						{luparm, x_axis, math.rad(-20), math.rad(270)},
					
						{rleg, x_axis, math.rad(85), math.rad(540)},
						{lleg, x_axis, math.rad(10), math.rad(630)},
						{lthigh, x_axis, math.rad(30), math.rad(270)},
						{rthigh, x_axis, math.rad(-60), math.rad(270)},
						{torso, y_axis, math.rad(10), math.rad(90)},
					},
					moves = {
						{pelvis, y_axis, 0, 5},
					},
				},
				{ --frame 2
					moves = {
						{pelvis, y_axis, 1, 5},
					},
				},
				{ --frame 3
					turns = {
						{ruparm, x_axis, math.rad(-20), math.rad(270)},
						{luparm, x_axis, math.rad(60), math.rad(270)},
					
						{rleg, x_axis, math.rad(10), math.rad(630)},
						{lleg, x_axis, math.rad(85), math.rad(540)},
						{lthigh, x_axis, math.rad(-60), math.rad(270)},
						{rthigh, x_axis, math.rad(30), math.rad(270)},
						{torso, y_axis, math.rad(-10), math.rad(90)},
					},
					moves = {
						{pelvis, y_axis, 0, 5},
					},
				},
				{ --frame 4
					moves = {
						{pelvis, y_axis, 1, 5},
					},
				},
				wait = {5,6},
			},
			
	-- clear_mines = {
		
	-- }
} 

local stances = {
	stand =	{
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						{ruparm, x_axis, math.rad(-40)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, math.rad(10)},
						{luparm, x_axis, math.rad(-40)},
						{luparm, y_axis, 0},
						{luparm, z_axis, math.rad(-10)},
						{rloarm, x_axis, 0},
						{rloarm, y_axis, math.rad(-10)},
						{rloarm, z_axis, math.rad(90)},
						{lloarm, x_axis, 0},
						{lloarm, y_axis, math.rad(10)},
						{lloarm, z_axis, math.rad(-90)},
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	run = {
					turns = {
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						
						{ruparm, y_axis, 0},
						{ruparm, z_axis, 0},
						
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						
						{rloarm, x_axis, math.rad(-100)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},
						
						{lloarm, x_axis, math.rad(-100)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
						
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
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
						
						{torso, x_axis, math.rad(-10)},
						{torso, y_axis, math.rad(20)},
						{torso, z_axis, 0},
					},
				},
	clear_mines = {
					turns = {

					},
					moves = {
					},
				},
}

local keyframes = {
}

local keyframeDelays = {
}

local variants = {
	stand = { stances.stand},
	prone = { stances.prone},
	run = {stances.run},
	stand_aim_engineer = { stances.clear_mines},
}

local customFunctions = {
	StartClearMines = (function ()
		StartAiming("engineer")
	end),
	StopClearMines = (function ()
		StopAiming()
	end),
}

return tags, variants, keyframes, keyframeDelays, customFunctions