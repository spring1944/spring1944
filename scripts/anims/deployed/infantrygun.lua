-- GUN

local ground = piece "ground"
local carriage = piece "carriage"
local wheels = piece "wheels"
local sleeve = piece "sleeve"
local barrel = piece "barrel"
local flare = piece "flare"

-- CREW

local crewman1 = piece "crewman1"
local pelvis1 = piece "pelvis1"
local torso1 = piece "torso1"
local head1 = piece "head1"
local luparm1 = piece "luparm1"
local lloarm1 = piece "lloarm1"
local ruparm1 = piece "ruparm1"
local rloarm1 = piece "rloarm1"
local rthigh1 = piece "rthigh1"
local rleg1 = piece "rleg1"
local rfoot1 = piece "rfoot1"
local lthigh1 = piece "lthigh1"
local lleg1 = piece "lleg1"
local lfoot1 = piece "lfoot1"

local crewman2 = piece "crewman2"
local pelvis2 = piece "pelvis2"
local torso2 = piece "torso2"
local head2 = piece "head2"
local luparm2 = piece "luparm2"
local lloarm2 = piece "lloarm2"
local ruparm2 = piece "ruparm2"
local rloarm2 = piece "rloarm2"
local rthigh2 = piece "rthigh2"
local rleg2 = piece "rleg2"
local rfoot2 = piece "rfoot2"
local lthigh2 = piece "lthigh2"
local lleg2 = piece "lleg2"
local lfoot2 = piece "lfoot2"

local tags = {
	headingPiece = carriage,
	pitchPiece = sleeve,
	defaultTraverseSpeed = math.rad(10),
	defaultElevateSpeed = math.rad(15),	
}

local anims = {
	run = {
				{ --frame 1
					turns = { -- Turns
						{rthigh1, x_axis, 0, math.rad(180)},
						
						{lthigh1, x_axis, math.rad(17), math.rad(60)},
						
						{rleg1, x_axis, math.rad(25), math.rad(30)},
						{lleg1, x_axis, math.rad(80), math.rad(120)},
						
						{rthigh2, x_axis, 0, math.rad(180)},
						
						{lthigh2, x_axis, math.rad(17), math.rad(60)},
						
						{rleg2, x_axis, math.rad(25), math.rad(30)},
						{lleg2, x_axis, math.rad(80), math.rad(120)},
					},
				},
				{ --frame 2
					turns = { -- Turns
						{rthigh1, x_axis, math.rad(30), math.rad(150)},
						
						{lthigh1, x_axis, math.rad(-45), math.rad(300)},
						
						{rleg1, x_axis, math.rad(45), math.rad(100)},
						{lleg1, x_axis, math.rad(35), math.rad(220)},
						
						{rthigh2, x_axis, math.rad(30), math.rad(150)},
						
						{lthigh2, x_axis, math.rad(-45), math.rad(300)},
						
						{rleg2, x_axis, math.rad(45), math.rad(100)},
						{lleg2, x_axis, math.rad(35), math.rad(220)},
					},
				},
				{ --frame 3
					turns = {
						{lthigh1, x_axis, 0, math.rad(220)},
						
						{rthigh1, x_axis, math.rad(17), math.rad(90)},
						
						{lleg1, x_axis, math.rad(25), math.rad(50)},
						{rleg1, x_axis, math.rad(80), math.rad(180)},
						
						{lthigh2, x_axis, 0, math.rad(220)},
						
						{rthigh2, x_axis, math.rad(17), math.rad(90)},
						
						{lleg2, x_axis, math.rad(25), math.rad(50)},
						{rleg2, x_axis, math.rad(80), math.rad(180)},
					},
				},
				{ --frame 4
					turns = {
						{lthigh1, x_axis, math.rad(30), math.rad(150)},
						
						{rthigh1, x_axis, math.rad(-45), math.rad(300)},
						
						{lleg1, x_axis, math.rad(45), math.rad(100)},
						{rleg1, x_axis, math.rad(35), math.rad(220)},
						
						{lthigh2, x_axis, math.rad(30), math.rad(150)},
						
						{rthigh2, x_axis, math.rad(-45), math.rad(300)},
						
						{lleg2, x_axis, math.rad(45), math.rad(100)},
						{rleg2, x_axis, math.rad(35), math.rad(220)},
					},
				},
				wait = {7, 7},
			},
}
do --Interpolating anims.run

	local PI = math.pi
	local TAU = 2 * PI
	local interpolatedRun = {}
	local function GetTurnDiff(f, t)
		if f and t then
			local diff = t - f
			if diff > PI then
				diff = TAU - diff
			end
			if diff < -PI then
				diff = diff + TAU
			end
			return math.abs(diff)
		end
	end

	local function GetManipulationData(manipulationArray)
		local data = {}
		if not manipulationArray then
			return data
		end
		for _, params in pairs(manipulationArray) do
			local p, axis, target = unpack(params)
			if not data[p] then
				data[p] = {}
			end
			data[p][axis] = target
		end
		return data
	end 

	for i=1,#anims.run do
		local prevTurns = anims.run[((i - 2) % #anims.run) + 1].turns
		local fromTurnData = GetManipulationData(prevTurns)
		
		local currentTurns = anims.run[i].turns
		local toTurnData = GetManipulationData(currentTurns)
		
		local duration = anims.run.wait[1] / 30.0
		
		local interpolatedTurns = {}
		
		for p, axes in pairs(toTurnData) do
			for axis, toValue in pairs(axes) do
				local fromValue = fromTurnData[p][axis]
				local diff = GetTurnDiff(fromValue, toValue)
				interpolatedTurns[#interpolatedTurns + 1] = {p, axis, toValue, diff / duration}
			end
		end
		interpolatedRun[#interpolatedRun + 1] = {turns = interpolatedTurns}
	end
	
	interpolatedRun.wait = anims.run.wait
	anims.run = interpolatedRun
end

local poses = {
	ready =	{
					turns = {
						{head1, x_axis, 0},
						
						{ruparm1, x_axis, math.rad(-25)},
						{ruparm1, y_axis, math.rad(15)},
						{ruparm1, z_axis, 0},
						
						{luparm1, x_axis, math.rad(-40)},
						{luparm1, y_axis, math.rad(-15)},
						{luparm1, z_axis, 0},
						
						{rloarm1, x_axis, math.rad(-50)},
						
						{lloarm1, x_axis, math.rad(-45)},
						
						{torso1, x_axis, math.rad(10)},
						{torso1, y_axis, math.rad(40)},
						
						{rthigh1, x_axis, math.rad(-90)},
						
						{lthigh1, x_axis, 0},
						
						{rleg1, x_axis, math.rad(90)},
						{lleg1, x_axis, math.rad(90)},
						

						{head2, x_axis, 0},
						
						{ruparm2, x_axis, math.rad(-30)},
						{ruparm2, y_axis, math.rad(15)},
						
						{luparm2, x_axis, math.rad(-60)},
						{luparm2, y_axis, math.rad(35)},
						{luparm2, z_axis, 0},
						
						{rloarm2, x_axis, math.rad(-40)},
						
						{lloarm2, x_axis, math.rad(-45)},
						
						
						{torso2, x_axis, math.rad(10)},
						{torso2, y_axis, math.rad(-45)},
						
						{rthigh2, x_axis, math.rad(-90)},
						
						{lthigh2, x_axis, 0},
						
						{rleg2, x_axis, math.rad(90)},
						{lleg2, x_axis, math.rad(90)},
						
					},
					moves = {
						{crewman1, y_axis, -3},
						{crewman2, y_axis, -3},
					}
				},
	pinned = {
					turns = { -- Turns
						{head1, x_axis, math.rad(-20)},
						
						{ruparm1, x_axis, math.rad(-90)},
						{ruparm1, z_axis, math.rad(-20)},
						
						{luparm1, x_axis, math.rad(-90)},
						{luparm1, z_axis, math.rad(20)},

						{rloarm1, x_axis, math.rad(-115)},
						
						{lloarm1, x_axis, math.rad(-115)},
						
						{torso1, y_axis, math.rad(40)},

						{rthigh1, x_axis, math.rad(-50)},
						
						{lthigh1, x_axis, math.rad(-50)},						
						
						{rleg1, x_axis, math.rad(130)},
						
						{lleg1, x_axis, math.rad(130)},
						
						
						
						{head2, x_axis, math.rad(-20)},
						
						{ruparm2, x_axis, math.rad(-90)},
						{ruparm2, z_axis, math.rad(-20)},
						
						{luparm2, x_axis, math.rad(-90)},
						{luparm2, z_axis, math.rad(20)},

						{rloarm2, x_axis, math.rad(-115)},
						
						{lloarm2, x_axis, math.rad(-115)},
						
						{torso2, x_axis, math.rad(10)},
						{torso2, y_axis, math.rad(-45)},

						{rthigh2, x_axis, math.rad(-90)},
						
						{rleg2, x_axis, math.rad(90)},
						
						{lleg2, x_axis, math.rad(90)},						
					},
				},

	run = {
					turns = {
						{head1, x_axis, math.rad(-15)},
						
						{ruparm1, x_axis, math.rad(-25)},
						{ruparm1, y_axis, math.rad(15)},
						
						{luparm1, x_axis, math.rad(-40)},
						{luparm1, y_axis, math.rad(-15)},
						
						{rloarm1, x_axis, math.rad(-50)},
						
						{lloarm1, x_axis, math.rad(-50)},
						
						{torso1, x_axis, math.rad(30)},
						{torso1, y_axis, math.rad(40)},
					
					
						{head2, x_axis, math.rad(-15)},
						
						{ruparm2, x_axis, math.rad(-30)},
						{ruparm2, y_axis, math.rad(15)},
						
						{luparm2, x_axis, math.rad(-45)},
						{luparm2, y_axis, math.rad(-15)},
						
						{rloarm2, x_axis, math.rad(-40)},
						
						{lloarm2, x_axis, math.rad(-45)},
						
						{torso2, x_axis, math.rad(30)},
						{torso2, y_axis, math.rad(-40)},
					
						{carriage, y_axis, 0},
						
						{sleeve, x_axis, 0},
					},
					moves = {
						{crewman1, y_axis, 0},
						{crewman2, y_axis, 0},
					},
					anim = anims.run
				},
				
	kf_fire_1 = {
					turns = {
						{torso2, y_axis, math.rad(-60)},
						
						{ruparm2, x_axis, math.rad(90)},
						{rloarm2, x_axis, math.rad(-90)},
					},

	},
	kf_fire_2 = {
		-- delay
	},
	kf_fire_3 = {
					turns = {
						{torso1, y_axis, math.rad(40)},	
						
						{ruparm1, x_axis, 0},
						{ruparm1, y_axis, 0},
	
					},
	},
	
	kf_fire_4 = {
					turns = {
						{torso1, x_axis, math.rad(30)},
						{torso1, y_axis, math.rad(80)},
						
						{ruparm1, x_axis, math.rad(-100)},
						{ruparm1, y_axis, math.rad(20)},
						
						{luparm1, x_axis, math.rad(-75)},
						
						{torso2, y_axis, math.rad(-45)},
						
						{rloarm2, x_axis, math.rad(-30)},	
						{ruparm2, x_axis, math.rad(-40)},
					},
	},
	
	kf_fire_5 = {
					turns = {
						{torso1, y_axis, math.rad(45)},
						
						{ruparm1, x_axis, math.rad(-60)},
						
						{luparm1, x_axis, math.rad(-25)},
	
					},
	},
	
	kf_fire_6 = {
		-- delay
	},
}

local keyframes = {
	fire = {poses.kf_fire_1,
			poses.kf_fire_2,
			poses.kf_fire_3,
			poses.kf_fire_4,
			poses.kf_fire_5,
			poses.kf_fire_6,
			}
}

local keyframeDelays = {
	fire = {0.05, 0.1, 0.1, 0.5, 0.5, 0.5, 0.1},
}


return tags, poses, keyframes, keyframeDelays