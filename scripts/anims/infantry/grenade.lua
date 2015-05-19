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
	flare = rloarm,
}
local stances = {	
	stand_aim = {
					turns = { --Turns
						{ruparm , x_axis, math.rad(20)},
						{ruparm , y_axis, 0},
						{ruparm , z_axis, math.rad(-10)},
						
						{luparm , x_axis, math.rad(-70)},						
						{luparm , y_axis, 0},
						{luparm , z_axis, math.rad(20)},
					
						{rloarm , x_axis, 0},
						{rloarm , y_axis, math.rad(-90)},
						{rloarm , z_axis, 0},
					
						{lloarm , x_axis, math.rad(-5)},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, math.rad(-70)},
										
						{torso , x_axis, math.rad(-10)},
						{torso , y_axis, math.rad(-20)},
					},
	},
	kf_stand_fire_1 = {
					turns = { --Turns
						{ruparm , x_axis, 0},
						{ruparm , z_axis, math.rad(-80)},
						
						{luparm , x_axis, math.rad(-25)},
						{luparm , x_axis, math.rad(5)},
						
						{rloarm , x_axis, math.rad(-20)},
						{rloarm , z_axis, math.rad(10)},
						
						{lloarm , x_axis, math.rad(-80)},
						{lloarm , z_axis, math.rad(-10)},
						
						{torso , x_axis, 0},
						{torso , y_axis, 0},
					},
	},
	kf_stand_fire_2 = {
					turns = { --Turns
						{ruparm , y_axis, math.rad(60)},
						{ruparm , z_axis, math.rad(-80)},
						
						{luparm , x_axis, 0},
						{luparm , z_axis, math.rad(10)},
						
						{rloarm , x_axis, math.rad(-20)},
						{rloarm , z_axis, math.rad(40)},
						
						{lloarm , x_axis, 0},
						{lloarm , z_axis, math.rad(5)},
					},
	},
	run_aim = {
					turns = { --Turns
						{ruparm , x_axis, math.rad(20)},
						{ruparm , y_axis, 0},
						{ruparm , z_axis, math.rad(-10)},
						
						{luparm , x_axis, math.rad(-70)},						
						{luparm , y_axis, 0},
						{luparm , z_axis, math.rad(20)},
					
						{rloarm , x_axis, 0},
						{rloarm , y_axis, math.rad(-90)},
						{rloarm , z_axis, 0},
					
						{lloarm , x_axis, math.rad(-5)},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, math.rad(-70)},
										
						{torso , x_axis, math.rad(-10)},
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
	stand_fire = {	stances.kf_stand_fire_1, 
					stances.kf_stand_fire_2},
	run_fire = {	stances.kf_stand_fire_1, 
					stances.kf_stand_fire_2},
	prone_fire = {stances.kf_prone_fire},
}

local keyframeDelays = {
	ready_to_aim = {0.3},
	stand_fire = {0.2, 0.2, 0.1},
	run_fire = {0.2, 0.2, 0.1},
	prone_fire = {0.3, 0.2},
}

return tags, variants, keyframes, keyframeDelays