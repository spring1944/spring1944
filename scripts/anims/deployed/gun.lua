-- CREW
local crewman1 = piece "crewman1"
local head1 = piece "head1"
local torso1 = piece "torso1"
local pelvis1 = piece "pelvis1"

local luparm1 = piece "luparm1"
local lloarm1 = piece "lloarm1"

local ruparm1 = piece "ruparm1"
local rloarm1 = piece "rloarm1"

local lthigh1 = piece "lthigh1"
local lleg1 = piece "lleg1"

local rthigh1 = piece "rthigh1"
local rleg1 = piece "rleg1"

-- GUN
local base = piece "base"
local carriage = piece "carriage"
local sleeve = piece "sleeve"
local barrel = piece "barrel"
local flare = piece "flare"
local brakeleft = piece "brakeleft"
local brakeright = piece "brakeright"

local tags = {
	headingPiece = carriage,
	pitchPiece = sleeve,
	defaultTraverseSpeed = math.rad(10),
	defaultElevateSpeed = math.rad(15),
	fearPinned = 10,
}

local poses = {
	ready =	{
					turns = {
						{head1, x_axis, 0},
						
						{ruparm1, x_axis, 0},
						{ruparm1, y_axis, 0},
						{ruparm1, z_axis, 0},
						
						{luparm1, x_axis, 0},
						{luparm1, y_axis, 0},
						{luparm1, z_axis, 0},

						{rloarm1, x_axis, 0},
						
						{lloarm1, x_axis, math.rad(-45)},
						
						{torso1, x_axis, 0},
						{torso1, y_axis, math.rad(40)},	
					},
					moves = {
						{crewman1, y_axis, 0},
					}
				},
	pinned = {
					turns = { -- Turns
						{head1, x_axis, math.rad(20)},
						
						{ruparm1, x_axis, math.rad(-90)},
						{ruparm1, z_axis, math.rad(-30)},
						
						{luparm1, x_axis, math.rad(-90)},
						{luparm1, z_axis, math.rad(30)},

						{rloarm1, x_axis, math.rad(-115)},
						{rloarm1, z_axis, math.rad(25)},
						
						{lloarm1, x_axis, math.rad(-115)},
						{lloarm1, z_axis, math.rad(-25)},
						
						{torso1, x_axis, math.rad(40)},
						{torso1, y_axis, math.rad(-20)},						
					},
				},
	kf_fire_1 = {
					turns = {
					--	{ruparm1, x_axis, math.rad(-90)},
						{ruparm1, y_axis, math.rad(20)},
						
						{torso1, y_axis, math.rad(80)},
					},
				},
	kf_fire_2 = {
					--delay
				},
	kf_fire_3 = {
					turns = {
						{ruparm1, x_axis, math.rad(0)},
						{ruparm1, y_axis, math.rad(0)},
						
						{torso1, y_axis, math.rad(40)},
					},
				},
	kf_fire_4 = {
				--delay
				},
	kf_fire_5 = {
					turns = {
						{ruparm1, x_axis, math.rad(-120)},
						{ruparm1, y_axis, math.rad(20)},
						
						{luparm1, x_axis, math.rad(-75)},
						
						{torso1, x_axis, math.rad(30)},
						{torso1, y_axis, math.rad(80)},
					},
				},
	-- kf_fire_5 = {
					-- --delay
				-- },
	kf_fire_6 = {
					turns = {
						{ruparm1, x_axis, math.rad(-60)},
						
						{luparm1, x_axis, math.rad(-25)},
						
						{torso1, y_axis, math.rad(45)},
					},
				},
	-- kf_fire_7 = {
					-- --delay
				-- },
	
}

local keyframes = {
	fire = {poses.kf_fire_1,
			poses.kf_fire_2,
			poses.kf_fire_3,
			poses.kf_fire_4,
			poses.kf_fire_5,
			poses.kf_fire_6,
			-- poses.kf_fire_7,
			}
}

local keyframeDelays = {
	fire = {0.1, 0.1, 0.1, 0.2, 0.5, 0.5, 0.4},
}


return tags, poses, keyframes, keyframeDelays