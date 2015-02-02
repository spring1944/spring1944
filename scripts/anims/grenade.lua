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
	aimOnLoaded = true,
}
local stances = {	
	stand_aim = {
					turns = { --Turns
						{ruparm , x_axis, math.rad(20)},
						{ruparm , y_axis, 0},
						{ruparm , z_axis, math.rad(-55)},
						
						{luparm , x_axis, 0},						
						{luparm , y_axis, math.rad(-20)},
						{luparm , z_axis, math.rad(80)},
					
						{rloarm , x_axis, math.rad(-35)},
						{rloarm , y_axis, 0},
						{rloarm , z_axis, math.rad(-85)},
					
						{lloarm , x_axis, math.rad(-20)},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, 0},
										
						{torso , x_axis, math.rad(-10)},
						{torso , y_axis, math.rad(-20)},
					},
	},
	kf_stand_fire = {
					turns = { --Turns
						{ruparm , x_axis, math.rad(60)},
						{ruparm , y_axis, math.rad(35)},
						{ruparm , z_axis, math.rad(-70)},
						
						{luparm , y_axis, math.rad(50)},
						{luparm , z_axis, math.rad(55)},
						
						{rloarm , y_axis, math.rad(15)},
						
						{lloarm , x_axis, math.rad(-40)},
						
						{torso , x_axis, 0, math.rad(150)},
					},
	},
	run_aim = {
					turns = { --Turns
						{ruparm , x_axis, math.rad(20)},
						{ruparm , y_axis, 0},
						{ruparm , z_axis, math.rad(-55)},
						
						{luparm , x_axis, 0},						
						{luparm , y_axis, math.rad(-20)},
						{luparm , z_axis, math.rad(80)},
					
						{rloarm , x_axis, math.rad(-35)},
						{rloarm , y_axis, 0},
						{rloarm , z_axis, math.rad(-85)},
					
						{lloarm , x_axis, math.rad(-20)},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, 0},
										
						{torso , x_axis, math.rad(-10)},
					},
	},
	kf_run_fire = {
					turns = { --Turns
						{ruparm , x_axis, math.rad(60)},
						{ruparm , y_axis, math.rad(35)},
						{ruparm , z_axis, math.rad(-70)},
						
						{luparm , y_axis, math.rad(50)},
						{luparm , z_axis, math.rad(55)},
						
						{rloarm , y_axis, math.rad(15)},
						
						{lloarm , x_axis, math.rad(-40)},
						
						{torso , x_axis, 0, math.rad(150)},
					},
	},
	prone_aim = {
					turns = { --Turns
						{luparm , x_axis, 0},
						{luparm , y_axis, math.rad(80)},
						{luparm , z_axis, 0},
					},
	},
	kf_prone_fire = {
					turns = {
						{luparm , x_axis, math.rad(-160)},
					},
	},
}

local variants = {
	stand_aim = { stances.stand_aim},
	run_aim = {stances.run_aim},
	prone_aim = { stances.prone_aim},
}

local keyframes = {
	stand_fire = {stances.kf_stand_fire},
	run_fire = {stances.kf_run_fire},
	prone_fire = {stances.kf_prone_fire},
}

local keyframeDelays = {
	ready_to_aim = {0.3},
	stand_fire = {0.3, 0.2},
	run_fire = {0.3, 0.2},
	prone_fire = {0.3, 0.2},
}

return tags, variants, keyframes, keyframeDelays