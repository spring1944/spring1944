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

local DEFAULT_TURN_SPEED = math.rad(300)
local DEFAULT_MOVE_SPEED = 100


local function Concat(t1, t2)
	local c = {}
	if t1 then
		for _, v in pairs(t1) do c[#c + 1] = v end
	end
	if t2 then
		for _, v in pairs(t2) do c[#c + 1] = v end
	end
	return c
end

local function Merge(t1, t2)
	local merged = {}
	local l = math.max(#t1, #t2)
	for i = 1,l do
		merged[i] = Concat(t1[i], t2[i])
	end
	return merged
end

anims = {
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
					},
				},
				{ --frame 2
					moves = {
						{pelvis, y_axis, 1, 5},
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
					},
				},
				{ --frame 4
					moves = {
						{pelvis, y_axis, 1, 5},
					},
				},
				wait = {5,6},
			},
	run_aim = {
				{ --frame 1
					turns = {
						{rleg, x_axis, math.rad(85), math.rad(540)},
						{lleg, x_axis, math.rad(10), math.rad(630)},
						{lthigh, x_axis, math.rad(30), math.rad(270)},
						{rthigh, x_axis, math.rad(-60), math.rad(270)},
					},
					moves = {
						{pelvis, y_axis, 0, 5},
					}, -- Moves
				},
				{ --frame 2
					moves = { -- Moves
						{pelvis, y_axis, 1, 5},
					},
				},
				{ --frame 3
					turns = { -- Turns
						{rleg, x_axis, math.rad(10), math.rad(630)},
						{lleg, x_axis, math.rad(85), math.rad(540)},
						{lthigh, x_axis, math.rad(-60), math.rad(270)},
						{rthigh, x_axis, math.rad(30), math.rad(270)},
					},
					moves = { -- Moves
						{pelvis, y_axis, 0, 5},
					},
				},
				{ --frame 4
					moves = { -- Moves
						{pelvis, y_axis, 1, 5},
					},
				},
				wait = {5,6},
			},
	crawl = {
		{ --frame 1
			turns = { --Turns
				{head , y_axis, math.rad(30), math.rad(150)},
				{head , z_axis, math.rad(-40), math.rad(150)},
				
				{ruparm , x_axis, math.rad(-80), math.rad(150)},
				{ruparm , y_axis, math.rad(-60), math.rad(150)},
				
				{luparm , x_axis, math.rad(-100), math.rad(150)},
				{luparm , y_axis, math.rad(50), math.rad(150)},
				
				{rloarm , x_axis, math.rad(-120), math.rad(150)},
				{rloarm , y_axis, math.rad(30), math.rad(150)},				
				
				{lloarm , x_axis, math.rad(-60), math.rad(150)},
				{lloarm , y_axis, math.rad(-10), math.rad(150)},
				
				{gun , x_axis, math.rad(-40), math.rad(150)},
				{gun , y_axis, math.rad(45), math.rad(150)},
				
				{torso , y_axis, math.rad(-20), math.rad(75)},
				{torso , z_axis, math.rad(-20), math.rad(75)},
				
				{pelvis , y_axis, math.rad(15), math.rad(75)},
				{pelvis , z_axis, math.rad(15), math.rad(75)},
				
				{rthigh , x_axis, math.rad(-90), math.rad(210)},
				{rthigh , y_axis, math.rad(-85), math.rad(210)},
				{rthigh , z_axis, math.rad(15), math.rad(210)},
				
				{lthigh , x_axis, 0, math.rad(210)},
				{lthigh , y_axis, math.rad(100), math.rad(210)},
				{lthigh , z_axis, 0, math.rad(210)},
				
				{rleg , x_axis, math.rad(120), math.rad(210)},
				
				{lleg , x_axis, math.rad(10), math.rad(210)},
			},
		},
		{ -- frame 2
			turns = { -- Turns
				{head , y_axis, math.rad(-30), math.rad(150)},
				{head , z_axis, math.rad(40), math.rad(150)},
				
				{ruparm , x_axis, math.rad(-100), math.rad(150)},
				{ruparm , y_axis, math.rad(-50), math.rad(150)},
								
				{luparm , x_axis, math.rad(-80), math.rad(150)},
				{luparm , y_axis, math.rad(60), math.rad(150)},
				
				{rloarm , x_axis, math.rad(-60), math.rad(150)},
				{rloarm , y_axis, math.rad(10), math.rad(150)},
				
				{lloarm , x_axis, math.rad(-120), math.rad(150)},
				{lloarm , y_axis, math.rad(-30), math.rad(150)},
				
				{gun , x_axis, math.rad(-105), math.rad(150)},
				{gun , y_axis, math.rad(35), math.rad(150)},
				
				{torso , y_axis, math.rad(20), math.rad(75)},	
				{torso , z_axis, math.rad(20), math.rad(75)},
				
				{pelvis , y_axis, math.rad(-15), math.rad(75)},
				{pelvis , z_axis, math.rad(-15), math.rad(75)},
				
				{rthigh , x_axis, 0, math.rad(210)},
				{rthigh , y_axis, math.rad(-100), math.rad(210)},
				{rthigh , z_axis, 0, math.rad(210)},
				
				{lthigh , x_axis, math.rad(-90), math.rad(210)},
				{lthigh , y_axis, math.rad(85), math.rad(210)},
				{lthigh , z_axis, math.rad(-15), math.rad(210)},
				
				{rleg , x_axis, math.rad(10), math.rad(210)},
				
				{lleg , x_axis, math.rad(120), math.rad(210)},
			},
		},
		wait = {12, 14},
	},
	pinned_1 = {
		{ --frame 1
			turns = { --Turns
				{head , x_axis, 0, math.rad(120)},
				
				{torso , x_axis, math.rad(10), math.rad(120)},
				
				{ruparm , z_axis, math.rad(-100), math.rad(120)},
				
				{luparm , x_axis, math.rad(180), math.rad(120)},
	
				{rloarm , y_axis, math.rad(10), math.rad(120)},
				
				{rthigh , x_axis, math.rad(-10), math.rad(120)},
				{rthigh , y_axis, 0, math.rad(120)},
								
				{lthigh , x_axis, math.rad(-10), math.rad(120)},
				{lthigh , z_axis, 0, math.rad(120)},
				
				{rleg , x_axis, math.rad(30), math.rad(120)},

				{lleg , x_axis, math.rad(30), math.rad(120)},
			},
			moves = { -- Moves
				{pelvis, y_axis, -6.5 , 3001},
			},
		},
		{ --frame 2 (delay)
		},
		{ --frame 3
			turns = { --Turns
				{head , x_axis, math.rad(-60), math.rad(90)},
				
				{torso , x_axis, 0, math.rad(90)},
				
				{ruparm , z_axis, math.rad(-80), math.rad(90)},
				
				{luparm , x_axis, math.rad(220), math.rad(90)},
				
				{rloarm , y_axis, math.rad(30), math.rad(90)},
				
				{rthigh , x_axis, math.rad(-40), math.rad(90)},
				{rthigh , y_axis, math.rad(-100), math.rad(90)},
				
				{lthigh , x_axis, 0, math.rad(90)},
				{lthigh , z_axis, math.rad(10), math.rad(90)},
				
				{rleg , x_axis, math.rad(50), math.rad(90)},
				
				{lleg , x_axis, math.rad(20), math.rad(90)},
			},
			moves = { -- Moves
				{pelvis , y_axis, -6.3 , 3001},
			},
		},
		wait = {57,63},
	},
	pinned_3 = {
		{ --frame 1
			turns = { --Turns
				{torso , x_axis, math.rad(30), math.rad(40)},

				{rthigh , x_axis, math.rad(-70), math.rad(40)},

				{lthigh , x_axis, math.rad(-70), math.rad(40)},
			},
		},
		{ --frame 2
			turns = { --Turns
				{torso , x_axis, math.rad(50), math.rad(40)},
				
				{rthigh , x_axis, math.rad(-60), math.rad(40)},
				
				{lthigh , x_axis, math.rad(-60), math.rad(40)},
			},
		},
		wait = {7, 10},
	},
}

stances = {
	null = {},
	stand_ready_1 =	{
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
						{rloarm, x_axis, math.rad(-30)},
						{rloarm, y_axis, math.rad(20)},
						{rloarm, z_axis, math.rad(50)},
						{lloarm, x_axis, math.rad(-95)},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
						{gun,    x_axis, 0},
						{gun,    y_axis, 0},
						{gun,    z_axis, 0},
						{torso,  x_axis, 0},
						{torso,  y_axis, 0},
						{torso,  z_axis, 0},
					},
				},
	stand_ready_2 = {
					turns = { -- Turns
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, 0},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(10)},
						{luparm, y_axis, 0},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-50)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(110)},
						{lloarm, x_axis, math.rad(-15)},
						{lloarm, y_axis, math.rad(100)},
						{lloarm, z_axis, math.rad(-150)},
						{gun, x_axis, math.rad(-50)},
						{gun, y_axis, 0},
						{gun, z_axis, 0},
						{torso, x_axis, 0},
						{torso, y_axis, 0},
						{torso, z_axis, 0},
					},
				},
	stand_ready_3 = {
					turns = { -- Turns
						{head, y_axis, 0},
						{head, x_axis, 0},
						{head, z_axis, 0},
						{ruparm, x_axis, math.rad(-70)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, 0},
						{luparm, x_axis, math.rad(15)},
						{luparm, y_axis, math.rad(15)},
						{luparm, z_axis, 0},
						{rloarm, x_axis, math.rad(-40)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(110)},
						{lloarm, x_axis, math.rad(30)},
						{lloarm, y_axis, math.rad(90)},
						{lloarm, z_axis, math.rad(-100)},
						{gun, x_axis, math.rad(30)},
						{gun, y_axis, 0},
						{gun, z_axis, math.rad(20)},
						{torso, y_axis, 0},
						{torso, x_axis, 0},
						{torso, z_axis, 0},
					},
				},
	stand_base = {
					turns ={ -- Turns
						{pelvis, y_axis, 0},
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
						{rfoot, x_axis, 0},
						{rfoot, y_axis, 0},
						{rfoot, z_axis, 0},
						{lfoot, x_axis, 0},
						{lfoot, y_axis, 0},
						{lfoot, z_axis, 0},
					},
					moves = { -- Moves
						{pelvis, x_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
					},
				},
	prone_ready = {
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
	prone_base_1 = {
					turns = { -- Turns
					    {pelvis, x_axis, math.rad(90)},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},

						{rthigh, x_axis, math.rad(-90)},
						{rthigh, y_axis, math.rad(-85)},
						{rthigh, z_axis, math.rad(15)},
						
						{lthigh, x_axis, 0},
						{lthigh, y_axis, math.rad(85)},
						{lthigh, z_axis, 0},

						{rleg, x_axis, math.rad(120)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, math.rad(10)},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},
						
						{ground , x_axis, 0},
					},
					moves = { --Moves
						{pelvis, y_axis, -7},
						{ground, y_axis, 0},
					},
				},
	prone_base_2 = {
					turns = { -- Turns
					    {pelvis, x_axis, math.rad(90)},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},

						{rthigh, x_axis, 0},
						{rthigh, y_axis, math.rad(-100)},
						{rthigh, z_axis, 0},
						
						{lthigh, x_axis, math.rad(-90)},
						{lthigh, y_axis, math.rad(85)},
						{lthigh, z_axis, math.rad(-15)},

						{rleg, x_axis, math.rad(10)},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},

						{lleg, x_axis, math.rad(120)},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},
						
						{ground , x_axis, 0},
					},
					moves = { --Moves
						{pelvis, y_axis, -7} ,
						{ground, y_axis, 0},
					},
				},
	crawl = {
					turns = {
						{head , x_axis, math.rad(-60)},
						
						{ruparm , z_axis, 0},
						
						{luparm , z_axis, 0},
						
						{rloarm , z_axis, 0},
						
						{lloarm , z_axis, 0},
						
						{gun , z_axis, 0},
						
						{torso , x_axis, math.rad(-10)},
						
						{rleg , y_axis, 0},
						{rleg , z_axis, 0},
						
						{lleg , y_axis, 0},
						{lleg , z_axis, 0},
					},
					anim = anims.crawl,
	},
	run_base  = {
					turns = { -- Turns
						{torso,  x_axis, 0},
						{torso,  z_axis, 0},
						
						{pelvis, x_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
						
						{rthigh, y_axis, 0},
						{rthigh, z_axis, 0},
						
						{lthigh, y_axis, 0},
						{lthigh, z_axis, 0},
						
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},
						
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},
						
						{rfoot, x_axis, 0},
						{rfoot, y_axis, 0},
						{rfoot, z_axis, 0},
						
						{lfoot, x_axis, 0},
						{lfoot, y_axis, 0},
						{lfoot, z_axis, 0},
					},
					moves = { -- Moves
						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},
					},
					anim = anims.run,
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

						{torso, x_axis, 0},
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
						{pelvis, y_axis, 0, 100},
					},
					headingTurn = {pelvis, y_axis, math.rad(-90), 1},
					pitchTurn = {torso, x_axis, math.rad(-5), -1},
				},
	run_aim   = {
					turns = { -- Turns
						{head, x_axis, 0},
						{head, y_axis, 0},
						{head, z_axis, 0},
						
						{ruparm, x_axis, math.rad(80)},
						{ruparm, y_axis, math.rad(30)},
						{ruparm, z_axis, 0},

						{luparm, x_axis, math.rad(-60)},
						{luparm, y_axis, math.rad(-40)},
						{luparm, z_axis, 0},

						{rloarm, x_axis, math.rad(-120)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, 0},

						{lloarm, x_axis, 0},
						{lloarm, y_axis, math.rad(70)},
						{lloarm, z_axis, math.rad(-10)},

						{gun, x_axis, math.rad(-50)},
						{gun, y_axis, 0},
						{gun, z_axis, math.rad(-30)},
						
					},
					moves = { -- Moves
						{pelvis, y_axis, 0, 100},
					},
					headingTurn = {torso, y_axis, 0, 1},
					pitchTurn = {torso, x_axis, 0, -1},
					anim = anims.run_aim,
				},
	prone_aim = {
					headingTurn = {pelvis, y_axis, 0, 1},
					pitchTurn = {torso, x_axis, math.rad(-10), -0.5},
				},
	kf_stand_to_prone_1 = {
					turns = { -- Turns
						{head,   x_axis, 0},
						{head,   y_axis, 0},
						{head,   z_axis, 0},
						
					    {pelvis, x_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
						
						{rleg, x_axis, math.rad(150)},
						{rleg, y_axis, math.rad(10)},

						{lleg, x_axis, math.rad(150)},
						{lleg, y_axis, math.rad(-10)},

						{lthigh, x_axis, math.rad(-100)},
						{lthigh, y_axis, math.rad(30)},

						{rthigh, x_axis, math.rad(-100)},
						{rthigh, y_axis, math.rad(-30)},

						{ruparm, x_axis, math.rad(-40)},
						{ruparm, y_axis, 0},
						{ruparm, z_axis, math.rad(-40)},

						{rloarm, x_axis, math.rad(-90)},
						{rloarm, y_axis, 0},
						{rloarm, z_axis, math.rad(10)},

						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-40)},
						{gun, z_axis, math.rad(-10)},
						
						{torso, x_axis, math.rad(20)},
						{torso, y_axis, math.rad(-10)},
						{torso, z_axis, 0},
						
						{luparm, x_axis, math.rad(-30)},
						{luparm, y_axis, 0},
						{luparm, z_axis, math.rad(-20)},

						{lloarm, x_axis, 0},
						{lloarm, y_axis, 0},
						{lloarm, z_axis, 0},
					},
					moves = { -- Moves
						{pelvis, y_axis, -4.8},
					}, 
				},
	kf_stand_to_prone_2 = {
					turns = { -- Turns
						{pelvis, x_axis, math.rad(80)},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},

						{luparm, x_axis, math.rad(-90)},
						{luparm, y_axis, 0},
						{luparm, z_axis, math.rad(-20)},
						
						
						{lthigh, x_axis, math.rad(-20)},
						{lthigh, y_axis, math.rad(85)},
						{lthigh, z_axis, 0},

						{lleg, x_axis, 0},
						{lleg, y_axis, 0},
						{lleg, z_axis, 0},

						{rthigh, x_axis, math.rad(-20)},
						{rthigh, y_axis, math.rad(-85)},
						{rthigh, z_axis, 0},

						{rleg, x_axis, 0},
						{rleg, y_axis, 0},
						{rleg, z_axis, 0},
						
						{torso, x_axis, 0},
						{torso, y_axis, 0},
						{torso, z_axis, 0},

						{head, x_axis, math.rad(-60)},
						{head, y_axis, 0},
						{head, z_axis, 0},

						{ruparm, x_axis, math.rad(-80)},
						{ruparm, y_axis, math.rad(10)},
						{ruparm, z_axis, math.rad(-50)},

						{rloarm, x_axis, math.rad(-100)},
						{rloarm, y_axis, math.rad(10)},
						{rloarm, z_axis, 0},
						
						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-35)},
						{gun, z_axis, math.rad(-20)},
					},
					moves = { -- Moves
						{pelvis, y_axis, -3},
						{pelvis, z_axis, -1.6},
					}, 
				},
	pinned_1 = {
					turns = { --Turns
						{head , y_axis, (0)},
						{head , z_axis, 0},
						
						{torso , y_axis, 0},
						{torso , z_axis, math.rad(-10)},
						
						{ruparm , x_axis, math.rad(-90)},
						{ruparm , y_axis, 0},
						
						{luparm , y_axis, 0},
						{luparm , z_axis, math.rad(10)},
						
						{rloarm , x_axis, 0},
						{rloarm , z_axis, math.rad(20)},
						
						{lloarm , x_axis, 0},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, math.rad(-60)},
						
						{gun , x_axis, math.rad(60)},
						{gun , y_axis, 0},
						{gun , z_axis, 0},
						
						{pelvis , x_axis, math.rad(80)},
						
						{rthigh , z_axis, 0},
						
						{lthigh , y_axis, 0},
						
						{rleg , y_axis, 0},
						{rleg , z_axis, 0},
						
						{lleg , y_axis, 0},
						{lleg , z_axis, 0},
					},
					anim = anims.pinned_1,
				},
	pinned_2 = {
					turns = {
						{head , x_axis, math.rad(70)},
						{head , y_axis, 0},
						{head , z_axis, 0},
						
						{ruparm , x_axis, math.rad(-190)},
						{ruparm , y_axis, 0},
						{ruparm , z_axis, 0},
							
						{luparm , x_axis, math.rad(-90)},
						{luparm , y_axis, math.rad(20)},
						{luparm , z_axis, 0},
							
						{rloarm , x_axis, 0},
						{rloarm , y_axis, 0},
						{rloarm , z_axis, math.rad(90)},
						
						{lloarm , x_axis, 0},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, math.rad(-90)},
						
						{gun , x_axis, 0},
						{gun , y_axis, 0},
						{gun , z_axis, 0},
						
						{torso , x_axis, 0},
						{torso , y_axis, 0},
						{torso , z_axis, 0},
							
						{pelvis , y_axis, math.rad(40)},
						{pelvis , x_axis, 0},
						{pelvis , y_axis, math.rad(40)},
									
						{rthigh , x_axis, math.rad(-60)},
						{rthigh , y_axis, math.rad(50)},
						{rthigh , z_axis, 0},
							
						{lthigh , x_axis, 0},
						{lthigh , y_axis, math.rad(30)},
						{lthigh , z_axis, 0},
						
						{rleg , x_axis, math.rad(150)},
						{rleg , y_axis, 0},
						{rleg , z_axis, 0},
							
						{lleg , x_axis, 0},
						{lleg , y_axis, math.rad(30)},
						{lleg , z_axis, 0},
														
						{ground , x_axis, math.rad(80)},
					},
					moves = {
						{ground , y_axis, 1},
					},
				},
	pinned_3 = {
					turns = { --Turns
						{head , x_axis, math.rad(70)},
						{head , y_axis, 0},
						{head , z_axis, 0},
						
						{torso , y_axis, 0},
						{torso , z_axis, 0},
						
						{ruparm , x_axis, math.rad(-190)},
						{ruparm , y_axis, 0},
						{ruparm , z_axis, 0},
						
						{luparm , x_axis, math.rad(-90)},
						{luparm , y_axis, math.rad(-20)},
						{luparm , z_axis, 0},
						
						{rloarm , x_axis, 0},
						{rloarm , y_axis, math.rad(10)},
						{rloarm , z_axis, math.rad(90)},
						
						{lloarm , x_axis, 0},
						{lloarm , y_axis, 0},
						{lloarm , z_axis, math.rad(-80)},
						
						{gun , x_axis, 0},
						{gun , y_axis, 0},
						{gun , z_axis, 0},
						
						{pelvis , x_axis, 0},
						{pelvis , y_axis, math.rad(90)},
						
						{rthigh , y_axis, 0},
						{rthigh , z_axis, 0},
						
						{lthigh , y_axis, 0},
						{lthigh , z_axis, 0},
						
						{rleg , x_axis, math.rad(80)},
						{rleg , y_axis, 0},
						{rleg , z_axis, 0},
						
						{lleg , x_axis, math.rad(130)},
						{lleg , y_axis, math.rad(30)},
						{lleg , z_axis, 0},
												
						{ground , x_axis, math.rad(80)},						
					},
					moves = { -- Moves
						{pelvis, y_axis, -5},
					},
					anim = anims.pinned_3,
				},
	kf_stand_grenading_1 = {
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
	kf_stand_grenading_2 = {
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
	kf_run_grenading_1 = {
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
					anim = anims.run
	},
	kf_run_grenading_2 = {
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
					anim = anims.run
	},
	kf_prone_grenading_1 = {
					turns = { --Turns
						{luparm , x_axis, 0},
						{luparm , y_axis, math.rad(80)},
						{luparm , z_axis, 0},
					},
	},
	kf_prone_grenading_2 = {
					turns = {
						{luparm , x_axis, math.rad(-160)},
					},
	},
}



-- local stancesArray = {}
-- local stancesMap = {}
-- local stancesNames = {}

-- for name, stance in pairs(stances) do
	-- stancesArray[#stancesArray + 1] = stance
	-- stancesMap[name] = #stancesArray
	-- stancesNames[#stancesArray] = name
-- end

local variants = {
	null = {stances.null},
	stand_base = { stances.stand_base },
	prone_base = { stances.prone_base_1,
				   stances.prone_base_2 },
	run_base = { stances.run_base },
	crawl = { stances.crawl },
	stand_ready = { stances.stand_ready_1,
					stances.stand_ready_2,
					stances.stand_ready_3},
	prone_ready = { stances.prone_ready},
	run_ready = { stances.stand_ready_1,
				  stances.stand_ready_2,
				  stances.stand_ready_3},
	stand_aim = { stances.stand_aim},
	prone_aim = { stances.prone_aim},
	run_aim = {stances.run_aim},
	pinned = {stances.pinned_1, stances.pinned_2, stances.pinned_3},
}

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

local function GetManipulationArray(manipulationData)
	local manipulationArray = {}
	for p, axes in pairs(manipulationData) do
		for axis, value in pairs(axes) do
			manipulationArray[#manipulationArray + 1] = {p, axis, value}
		end
	end
	return manipulationArray
end 

local function GetStanceManipulationData(manipulationArrays, deb)
	local tData = GetManipulationData(manipulationArrays.turns, deb)
	local mData = GetManipulationData(manipulationArrays.moves, deb)
	GetManipulationArray(tData)
	return tData, mData
end



local function ApplyManipulationData(base, data)
	for p, axes in pairs(data) do
		for axis, dataValue in pairs(axes) do
			if base[p] and base[p][axis] then
				base[p][axis] = dataValue
			end
		end
	end
end

local function RebaseManipulationData(base, data)
	for p, axes in pairs(base) do
		for axis, baseValue in pairs(axes) do
			if not data[p] then
				data[p] = {[axis] = baseValue}
			elseif not data[p][axis] then
				data[p][axis] = baseValue
			end
		end
	end
end

local poses = {}
local poseVariants = {}
local poseNames = {}
local function CreatePose(baseName, actionName, poseName)
	local pVariants = {}
	local base = variants[baseName]
	local action = variants[actionName]
	local i = 1
	for _, baseStance in pairs(base) do
		for _, actionStance in pairs(action) do
			local baseTurnData, baseMoveData = GetStanceManipulationData(baseStance)
			local actionTurnData, actionMoveData = GetStanceManipulationData(actionStance)
			RebaseManipulationData(baseTurnData, actionTurnData)
			RebaseManipulationData(baseMoveData, actionMoveData)
			local turns = GetManipulationArray(actionTurnData)
			local moves = GetManipulationArray(actionMoveData)
			 poses[#poses + 1] = {   turns = turns,
									 moves = moves,
									 headingTurn = actionStance.headingTurn, 
									 pitchTurn = actionStance.pitchTurn,
									 anim = actionStance.anim or baseStance.anim}
			pVariants[#pVariants + 1] = #poses
			poseNames[#poses] = poseName .. i
			i = i + 1
		end
	end
	poseVariants[poseName] = pVariants
end

CreatePose("stand_base", "stand_ready", "stand_ready")
CreatePose("stand_base", "stand_aim", "stand_aim")
CreatePose("prone_base", "prone_ready", "prone_ready")
CreatePose("prone_base", "prone_aim", "prone_aim")
CreatePose("run_base", "stand_ready", "run_ready")
CreatePose("run_base", "run_aim", "run_aim")
CreatePose("null", "crawl", "crawl")
CreatePose("null", "pinned", "pinned")
poseVariants.stand_grenading = poseVariants.stand_ready
poseVariants.run_grenading = poseVariants.run_ready
poseVariants.prone_grenading = poseVariants.prone_ready

local keyframes = {
	stand_to_prone = {stances.kf_stand_to_prone_1,
					  stances.kf_stand_to_prone_2},
	prone_to_stand = {stances.kf_stand_to_prone_2,
					  stances.kf_stand_to_prone_1},
	stand_grenading = {stances.kf_stand_grenading_1,
					   stances.kf_stand_grenading_2},
	run_grenading = {stances.kf_run_grenading_1,
				     stances.kf_run_grenading_2},
	prone_grenading = {stances.kf_prone_grenading_1,
				       stances.kf_prone_grenading_2},
	default = {},
}
local keyframeDelays = {
	stand_to_prone = {0.2, 0.1, 0.1},
	prone_to_stand = {0.1, 0.2, 0.2},
	stand_grenading = {0.3, 0.3, 0.3},
	run_grenading = {0.3, 0.3, 0.3},
	prone_grenading = {0.3, 0.3, 0.3},
	default = {0.1},
}

local PI = math.pi
local TAU = 2 * PI



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

local function CreateTransitionFrame(fromTurnData, fromMoveData, toTurnData, toMoveData, duration)

	local transitionTurns = {}
	
	for p, axes in pairs(toTurnData) do
		for axis, toValue in pairs(axes) do
			if fromTurnData[p] and fromTurnData[p][axis] then
				local fromValue = fromTurnData[p][axis]
				local diff = GetTurnDiff(fromValue, toValue)
				if diff > 0 then
					transitionTurns[#transitionTurns + 1] = {p, axis, toValue, diff / duration}
				else
					transitionTurns[#transitionTurns + 1] = {p, axis, toValue, DEFAULT_TURN_SPEED}
				end
			else
				transitionTurns[#transitionTurns + 1] = {p, axis, toValue, DEFAULT_TURN_SPEED}
			end
		end
	end
	
	local transitionMoves = {}
	
	for p, axes in pairs(toMoveData) do
		for axis, toValue in pairs(axes) do
			if fromMoveData[p] and fromMoveData[p][axis] then
				local fromValue = fromMoveData[p][axis]
				local diff = math.abs(toValue - fromValue)
				if diff > 0 then
					transitionMoves[#transitionMoves + 1] = {p, axis, toValue, diff / duration}
				else
					transitionMoves[#transitionMoves + 1] = {p, axis, toValue, DEFAULT_MOVE_SPEED}
				end
			else
				transitionMoves[#transitionMoves + 1] = {p, axis, toValue, DEFAULT_MOVE_SPEED}
			end
		end
	end
	
	if #transitionTurns == 0 then
		transitionTurns = nil
	end
	if #transitionMoves == 0 then
		transitionMoves = nil
	end
	
	return transitionTurns, transitionMoves
end

local function FlattenArray(startTurnData, startMoveData, stancesArray, transition, delays)
	local currentTurnData = startTurnData
	local currentMoveData = startMoveData
	
	for _, stance in pairs(stancesArray) do
		local tData, mData = GetStanceManipulationData(stance)
		local i = #transition + 1
		local turns, moves = CreateTransitionFrame(currentTurnData, currentMoveData, tData, mData, delays[i])
		transition[i] = {duration = delays[i] * 1000, 
						 turns = turns,
						 moves = moves}
		ApplyManipulationData(currentTurnData, tData)
		ApplyManipulationData(currentMoveData, tData)
	end
	return currentTurnData, currentMoveData
end

local function CreateTransition(startPoseID, intermediateStances, endPoseID, delays)
	if #intermediateStances + 1 ~= #delays then
		Spring.Echo("Error: bad parameters for transition", startPoseID, endPoseID, #intermediateStances, #delays)
	end
	local affectedPieces = {}
	local currentTurnData, currentMoveData = GetStanceManipulationData(poses[startPoseID])
	local transition = {}
	currentTurnData, currentMoveData = FlattenArray(currentTurnData, currentMoveData, intermediateStances, transition, delays)
	local endTurnData, endMoveData = GetStanceManipulationData(poses[endPoseID])
	local endPose = poses[endPoseID]
	local headingTurn = endPose.headingTurn
	
	if headingTurn then
		--Spring.Echo("heading in", poseNames[endPoseID])
		headingTurn = {unpack(headingTurn)}
		headingTurn[#headingTurn + 1] = DEFAULT_TURN_SPEED
		--Spring.Echo(unpack(headingTurn))
	end
	local pitchTurn = endPose.pitchTurn
	if pitchTurn then
		--Spring.Echo("pitch in", poseNames[endPoseID])
		pitchTurn = {unpack(pitchTurn)}
		pitchTurn[#pitchTurn + 1] = DEFAULT_TURN_SPEED
		--Spring.Echo(unpack(pitchTurn))
	end
	
	local lastDelay = delays[#delays]
	local turns, moves = CreateTransitionFrame(currentTurnData, currentMoveData, endTurnData, endMoveData, lastDelay)
	
	
	 transition[#transition + 1] = {duration = lastDelay * 1000,
									turns = turns,
									moves = moves,
									headingTurn = headingTurn, 
									pitchTurn = pitchTurn,
									anim = endPose.anim}
	
	return transition
end

local transitions = {}

local function CreateVariantTransitions(startVariant, endVariant, intermediateStances, delays)
	if not intermediateStances then
		intermediateStances = keyframes.default
	end
	if not delays then
		delays = keyframeDelays.default
	end
	for _, startPoseID in pairs(startVariant) do
		for _, endPoseID in pairs(endVariant) do
			local transition = CreateTransition(startPoseID, intermediateStances, endPoseID, delays)
			if not transitions[startPoseID] then
				transitions[startPoseID] = {[endPoseID] = transition}
			else
				transitions[startPoseID][endPoseID] = transition
			end
		end
	end
end

CreateVariantTransitions(poseVariants.stand_ready, poseVariants.stand_ready)
CreateVariantTransitions(poseVariants.stand_ready, poseVariants.prone_ready, keyframes.stand_to_prone, keyframeDelays.stand_to_prone)
CreateVariantTransitions(poseVariants.stand_ready, poseVariants.run_ready)
CreateVariantTransitions(poseVariants.stand_ready, poseVariants.stand_aim)
CreateVariantTransitions(poseVariants.stand_ready, poseVariants.stand_grenading, keyframes.stand_grenading, keyframeDelays.stand_grenading)

CreateVariantTransitions(poseVariants.stand_aim, poseVariants.stand_ready)
CreateVariantTransitions(poseVariants.stand_aim, poseVariants.stand_aim)
CreateVariantTransitions(poseVariants.stand_aim, poseVariants.prone_aim, keyframes.stand_to_prone, keyframeDelays.stand_to_prone)
CreateVariantTransitions(poseVariants.stand_aim, poseVariants.run_aim)

CreateVariantTransitions(poseVariants.prone_ready, poseVariants.stand_ready, keyframes.prone_to_stand, keyframeDelays.prone_to_stand)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.prone_ready)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.prone_aim)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.crawl)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.pinned)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.prone_grenading, keyframes.prone_grenading, keyframeDelays.prone_grenading)

CreateVariantTransitions(poseVariants.prone_aim, poseVariants.prone_ready)
CreateVariantTransitions(poseVariants.prone_aim, poseVariants.stand_aim, keyframes.prone_to_stand, keyframeDelays.prone_to_stand)
CreateVariantTransitions(poseVariants.prone_aim, poseVariants.prone_aim)

CreateVariantTransitions(poseVariants.run_ready, poseVariants.stand_ready)
CreateVariantTransitions(poseVariants.run_ready, poseVariants.run_ready)
CreateVariantTransitions(poseVariants.run_ready, poseVariants.run_aim)
CreateVariantTransitions(poseVariants.run_ready, poseVariants.run_grenading, keyframes.run_grenading, keyframeDelays.run_grenading)


CreateVariantTransitions(poseVariants.run_aim, poseVariants.run_ready)
CreateVariantTransitions(poseVariants.run_aim, poseVariants.stand_aim)
CreateVariantTransitions(poseVariants.run_aim, poseVariants.run_aim)

CreateVariantTransitions(poseVariants.crawl, poseVariants.prone_ready)

CreateVariantTransitions(poseVariants.pinned, poseVariants.prone_ready)

return poses, poseVariants, anims, transitions