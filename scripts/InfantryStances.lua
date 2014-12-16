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

stances = {
	stand_ready_1 =	{
					{ -- Turns
						{head,   x_axis, math.rad(0)},
						{head,   y_axis, math.rad(0)},
						{head,   z_axis, math.rad(0)},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, math.rad(0)},
						{ruparm, z_axis, math.rad(0)},
						{luparm, x_axis, math.rad(0)},
						{luparm, y_axis, math.rad(0)},
						{luparm, z_axis, math.rad(0)},
						{rloarm, x_axis, math.rad(-30)},
						{rloarm, y_axis, math.rad(20)},
						{rloarm, z_axis, math.rad(50)},
						{lloarm, x_axis, math.rad(-95)},
						{lloarm, y_axis, math.rad(0)},
						{lloarm, z_axis, math.rad(0)},
						{gun,    x_axis, math.rad(0)},
						{gun,    y_axis, math.rad(0)},
						{gun,    z_axis, math.rad(0)},
						{torso,  x_axis, math.rad(0)},
						{torso,  y_axis, math.rad(0)},
						{torso,  z_axis, math.rad(0)},
					},
				},
	stand_ready_2 = {
					{ -- Turns
						{head, x_axis, math.rad(0)},
						{head, y_axis, math.rad(0)},
						{head, z_axis, math.rad(0)},
						{ruparm, x_axis, math.rad(-60)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, math.rad(0)},
						{luparm, x_axis, math.rad(10)},
						{luparm, y_axis, math.rad(0)},
						{luparm, z_axis, math.rad(0)},
						{rloarm, x_axis, math.rad(-50)},
						{rloarm, y_axis, math.rad(0)},
						{rloarm, z_axis, math.rad(110)},
						{lloarm, x_axis, math.rad(-15)},
						{lloarm, y_axis, math.rad(100)},
						{lloarm, z_axis, math.rad(-150)},
						{gun, x_axis, math.rad(-50)},
						{gun, y_axis, math.rad(0)},
						{gun, z_axis, math.rad(0)},
						{torso, x_axis, math.rad(0)},
						{torso, y_axis, math.rad(0)},
						{torso, z_axis, math.rad(0)},
					},
				},
	stand_ready_3 = {
					{ -- Turns
						{head, y_axis, math.rad(0)},
						{head, x_axis, math.rad(0)},
						{head, z_axis, math.rad(0)},
						{ruparm, x_axis, math.rad(-70)},
						{ruparm, y_axis, math.rad(-40)},
						{ruparm, z_axis, math.rad(0)},
						{luparm, x_axis, math.rad(15)},
						{luparm, y_axis, math.rad(15)},
						{luparm, z_axis, math.rad(0)},
						{rloarm, x_axis, math.rad(-40)},
						{rloarm, y_axis, math.rad(0)},
						{rloarm, z_axis, math.rad(110)},
						{lloarm, x_axis, math.rad(30)},
						{lloarm, y_axis, math.rad(90)},
						{lloarm, z_axis, math.rad(-100)},
						{gun, x_axis, math.rad(30)},
						{gun, y_axis, math.rad(0)},
						{gun, z_axis, math.rad(20)},
						{torso, y_axis, math.rad(0)},
						{torso, x_axis, math.rad(0)},
						{torso, z_axis, math.rad(0)},
					},
				},
	stand_base = {
					{ -- Turns
						{pelvis, y_axis, math.rad(0)},
						{pelvis, x_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(0)},
						{rthigh, x_axis, math.rad(0)},
						{rthigh, y_axis, math.rad(0)},
						{rthigh, z_axis, math.rad(0)},
						{lthigh, x_axis, math.rad(0)},
						{lthigh, y_axis, math.rad(0)},
						{lthigh, z_axis, math.rad(0)},
						{rleg, x_axis, math.rad(0)},
						{rleg, y_axis, math.rad(0)},
						{rleg, z_axis, math.rad(0)},
						{lleg, x_axis, math.rad(0)},
						{lleg, y_axis, math.rad(0)},
						{lleg, z_axis, math.rad(0)},
						{rfoot, x_axis, math.rad(0)},
						{rfoot, y_axis, math.rad(0)},
						{rfoot, z_axis, math.rad(0)},
						{lfoot, x_axis, math.rad(0)},
						{lfoot, y_axis, math.rad(0)},
						{lfoot, z_axis, math.rad(0)},
					},
					{ -- Moves
						{pelvis, x_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
					},
				},
	prone_ready = {
					{ -- Turns
						{head, x_axis, math.rad(-60)},
						{head, y_axis, math.rad(0)},
						{head, z_axis, math.rad(0)},

						{ruparm, x_axis, math.rad(-80)},
						{ruparm, y_axis, math.rad(20)},
						{ruparm, z_axis, math.rad(-70)},

						{luparm, x_axis, math.rad(-140)},
						{luparm, y_axis, math.rad(-30)},
						{luparm, z_axis, math.rad(0)},
						
						{rloarm, x_axis, math.rad(-120)},
						{rloarm, y_axis, math.rad(30)},
						{rloarm, z_axis, math.rad(0)},

						{lloarm, x_axis, math.rad(20)},
						{lloarm, y_axis, math.rad(65)},
						{lloarm, z_axis, math.rad(-40)},
						
						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-35)},
						{gun, z_axis, math.rad(-45)},

						{torso, x_axis, math.rad(-10)},
						{torso, y_axis, math.rad(20)},
						{torso, z_axis, math.rad(0)},
					},
				},
	prone_base_1 = {
					{ -- Turns
					    {pelvis, x_axis, math.rad(90)},
						{pelvis, y_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(0)},

						{rthigh, x_axis, math.rad(-90)},
						{rthigh, y_axis, math.rad(-85)},
						{rthigh, z_axis, math.rad(15)},
						
						{lthigh, x_axis, math.rad(0)},
						{lthigh, y_axis, math.rad(85)},
						{lthigh, z_axis, math.rad(0)},

						{rleg, x_axis, math.rad(120)},
						{rleg, y_axis, math.rad(0)},
						{rleg, z_axis, math.rad(0)},

						{lleg, x_axis, math.rad(10)},
						{lleg, y_axis, math.rad(0)},
						{lleg, z_axis, math.rad(0)},
					},
					{ --Moves
						{pelvis, y_axis, -7},
					},
				},
	prone_base_2 = {
					{ -- Turns
					    {pelvis, x_axis, math.rad(90)},
						{pelvis, y_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(0)},

						{rthigh, x_axis, math.rad(0)},
						{rthigh, y_axis, math.rad(-100)},
						{rthigh, z_axis, math.rad(0)},
						
						{lthigh, x_axis, math.rad(-90)},
						{lthigh, y_axis, math.rad(85)},
						{lthigh, z_axis, math.rad(-15)},

						{rleg, x_axis, math.rad(10)},
						{rleg, y_axis, math.rad(0)},
						{rleg, z_axis, math.rad(0)},

						{lleg, x_axis, math.rad(120)},
						{lleg, y_axis, math.rad(0)},
						{lleg, z_axis, math.rad(0)},
					},
					{ --Moves
						{pelvis, y_axis, -7} ,
					},
				},
	run_base  = {
					{ -- Turns
						{torso,  x_axis, math.rad(0)},
						{torso,  z_axis, math.rad(0)},
						
						{pelvis, x_axis, math.rad(0)},
						{pelvis, y_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(0)},
						
						{rthigh, y_axis, math.rad(0)},
						{rthigh, z_axis, math.rad(0)},
						
						{lthigh, y_axis, math.rad(0)},
						{lthigh, z_axis, math.rad(0)},
						
						{rleg, y_axis, math.rad(0)},
						{rleg, z_axis, math.rad(0)},
						
						{lleg, y_axis, math.rad(0)},
						{lleg, z_axis, math.rad(0)},
						
						{rfoot, x_axis, math.rad(0)},
						{rfoot, y_axis, math.rad(0)},
						{rfoot, z_axis, math.rad(0)},
						
						{lfoot, x_axis, math.rad(0)},
						{lfoot, y_axis, math.rad(0)},
						{lfoot, z_axis, math.rad(0)},
					},
					{ -- Moves
						{pelvis, x_axis, 0},
						{pelvis, z_axis, 0},
					},
				},
	stand_aim = {
					{ -- Turns
						{head, x_axis, math.rad(15)},
						{head, y_axis, math.rad(70)},
						{head, z_axis, math.rad(20)},
						
						{ruparm, x_axis, math.rad(-35)},
						{ruparm, y_axis, math.rad(90)},
						{ruparm, z_axis, math.rad(-50)},

						{luparm, x_axis, math.rad(-65)},
						{luparm, y_axis, math.rad(60)},
						{luparm, z_axis, math.rad(0)},
						
						{rloarm, x_axis, math.rad(-80)},
						{rloarm, y_axis, math.rad(-10)},
						{rloarm, z_axis, math.rad(25)},

						{lloarm, x_axis, math.rad(-50)},
						{lloarm, y_axis, math.rad(0)},
						{lloarm, z_axis, math.rad(-30)},
						
						{gun, x_axis, math.rad(15)},
						{gun, y_axis, math.rad(-60)},
						{gun, z_axis, math.rad(-30)},

						{torso, x_axis, math.rad(0)},
						{torso, y_axis, math.rad(20)},
						{torso, z_axis, math.rad(10)},

						{pelvis, x_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(-10)},

						{rthigh, x_axis, math.rad(5)},
						{rthigh, y_axis, math.rad(0)},
						{rthigh, z_axis, math.rad(0)},

						{lthigh, x_axis, math.rad(-15)},
						{lthigh, y_axis, math.rad(0)},
						{lthigh, z_axis, math.rad(25)},
						
						{rleg, x_axis, math.rad(5)},
						{rleg, y_axis, math.rad(0)},
						{rleg, z_axis, math.rad(0)},

						{lleg, x_axis, math.rad(20)},
						{lleg, y_axis, math.rad(0)},
						{lleg, z_axis, math.rad(0)},

					},
					{ -- Moves
						{pelvis, y_axis, 0, 100},
					},
					-- headingTurn
					{pelvis, y_axis, math.rad(-90), 1},
					-- pitchTurn
					{torso, x_axis, math.rad(-5), -1},
				},
	run_aim   = {
					{ -- Turns
						{head, x_axis, math.rad(0)},
						{head, y_axis, math.rad(0)},
						{head, z_axis, math.rad(0)},
						
						{ruparm, x_axis, math.rad(80)},
						{ruparm, y_axis, math.rad(30)},
						{ruparm, z_axis, math.rad(0)},

						{luparm, x_axis, math.rad(-60)},
						{luparm, y_axis, math.rad(-40)},
						{luparm, z_axis, math.rad(0)},

						{rloarm, x_axis, math.rad(-120)},
						{rloarm, y_axis, math.rad(0)},
						{rloarm, z_axis, math.rad(0)},

						{lloarm, x_axis, math.rad(0)},
						{lloarm, y_axis, math.rad(70)},
						{lloarm, z_axis, math.rad(-10)},

						{gun, x_axis, math.rad(-50)},
						{gun, y_axis, math.rad(0)},
						{gun, z_axis, math.rad(-30)},
						
					},
					{ -- Moves
						{pelvis, y_axis, 0, 100},
					},
					-- headingTurn
					{torso, y_axis, math.rad(0), 1},
					-- pitchTurn
					{torso, x_axis, math.rad(0), -1},
				},
	prone_aim = {
					{ -- Turns
					},
					{ -- Moves
					},
					-- headingTurn
					{pelvis, y_axis, math.rad(0), 1},
					-- pitchTurn
					{torso, x_axis, math.rad(-10), -0.5},
				},
	kf_stand_to_prone_1 = {
					{ -- Turns
						{head,   x_axis, math.rad(0)},
						{head,   y_axis, math.rad(0)},
						{head,   z_axis, math.rad(0)},
						
					    {pelvis, x_axis, math.rad(0)},
						{pelvis, y_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(0)},
						
						{rleg, x_axis, math.rad(150)},
						{rleg, y_axis, math.rad(10)},

						{lleg, x_axis, math.rad(150)},
						{lleg, y_axis, math.rad(-10)},

						{lthigh, x_axis, math.rad(-100)},
						{lthigh, y_axis, math.rad(30)},

						{rthigh, x_axis, math.rad(-100)},
						{rthigh, y_axis, math.rad(-30)},

						{ruparm, x_axis, math.rad(-40)},
						{ruparm, y_axis, math.rad(0)},
						{ruparm, z_axis, math.rad(-40)},

						{rloarm, x_axis, math.rad(-90)},
						{rloarm, y_axis, math.rad(0)},
						{rloarm, z_axis, math.rad(10)},

						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-40)},
						{gun, z_axis, math.rad(-10)},
						
						{torso, x_axis, math.rad(20)},
						{torso, y_axis, math.rad(-10)},
						{torso, z_axis, math.rad(0)},
						
						{luparm, x_axis, math.rad(-30)},
						{luparm, y_axis, math.rad(0)},
						{luparm, z_axis, math.rad(-20)},

						{lloarm, x_axis, math.rad(0)},
						{lloarm, y_axis, math.rad(0)},
						{lloarm, z_axis, math.rad(0)},
					},
					{ -- Moves
						{pelvis, y_axis, -4.8},
					}, 
				},
	kf_stand_to_prone_2 = {
					{ -- Turns
						{pelvis, x_axis, math.rad(80)},
						{pelvis, y_axis, math.rad(0)},
						{pelvis, z_axis, math.rad(0)},

						{luparm, x_axis, math.rad(-90)},
						{luparm, y_axis, math.rad(0)},
						{luparm, z_axis, math.rad(-20)},
						
						
						{lthigh, x_axis, math.rad(-20)},
						{lthigh, y_axis, math.rad(85)},
						{lthigh, z_axis, math.rad(0)},

						{lleg, x_axis, math.rad(0)},
						{lleg, y_axis, math.rad(0)},
						{lleg, z_axis, math.rad(0)},

						{rthigh, x_axis, math.rad(-20)},
						{rthigh, y_axis, math.rad(-85)},
						{rthigh, z_axis, math.rad(0)},

						{rleg, x_axis, math.rad(0)},
						{rleg, y_axis, math.rad(0)},
						{rleg, z_axis, math.rad(0)},
						
						{torso, x_axis, math.rad(0)},
						{torso, y_axis, math.rad(0)},
						{torso, z_axis, math.rad(0)},

						{head, x_axis, math.rad(-60)},
						{head, y_axis, math.rad(0)},
						{head, z_axis, math.rad(0)},

						{ruparm, x_axis, math.rad(-80)},
						{ruparm, y_axis, math.rad(10)},
						{ruparm, z_axis, math.rad(-50)},

						{rloarm, x_axis, math.rad(-100)},
						{rloarm, y_axis, math.rad(10)},
						{rloarm, z_axis, math.rad(0)},
						
						{gun, x_axis, math.rad(10)},
						{gun, y_axis, math.rad(-35)},
						{gun, z_axis, math.rad(-20)},
					},
					{ -- Moves
						{pelvis, y_axis, -3},
						{pelvis, z_axis, -1.6},
					}, 
				},
}


anims = {
	run = {
				{ --frame 1
					{ -- Turns
						{rleg, x_axis, math.rad(85), math.rad(540)},
						{lleg, x_axis, math.rad(10), math.rad(630)},
						{lthigh, x_axis, math.rad(30), math.rad(270)},
						{rthigh, x_axis, math.rad(-60), math.rad(270)},
						{torso, y_axis, math.rad(10), math.rad(90)},
					},
					{
						{pelvis, y_axis, 0, 5},
					}, -- Moves
				},
				{ --frame 2
					{}, -- Turns
					{ -- Moves
						{pelvis, y_axis, 1, 5},
					},
				},
				{ --frame 3
					{ -- Turns
						{rleg, x_axis, math.rad(10), math.rad(630)},
						{lleg, x_axis, math.rad(85), math.rad(540)},
						{lthigh, x_axis, math.rad(-60), math.rad(270)},
						{rthigh, x_axis, math.rad(30), math.rad(270)},
						{torso, y_axis, math.rad(-10), math.rad(90)},
					},
					{ -- Moves
						{pelvis, y_axis, 0, 5},
					},
				},
				{ --frame 4
					{}, -- Turns
					{ -- Moves
						{pelvis, y_axis, 1, 5},
					},
				},
			},
	run_aim = {
				{ --frame 1
					{ -- Turns
						{rleg, x_axis, math.rad(85), math.rad(540)},
						{lleg, x_axis, math.rad(10), math.rad(630)},
						{lthigh, x_axis, math.rad(30), math.rad(270)},
						{rthigh, x_axis, math.rad(-60), math.rad(270)},
					},
					{
						{pelvis, y_axis, 0, 5},
					}, -- Moves
				},
				{ --frame 2
					{}, -- Turns
					{ -- Moves
						{pelvis, y_axis, 1, 5},
					},
				},
				{ --frame 3
					{ -- Turns
						{rleg, x_axis, math.rad(10), math.rad(630)},
						{lleg, x_axis, math.rad(85), math.rad(540)},
						{lthigh, x_axis, math.rad(-60), math.rad(270)},
						{rthigh, x_axis, math.rad(30), math.rad(270)},
					},
					{ -- Moves
						{pelvis, y_axis, 0, 5},
					},
				},
				{ --frame 4
					{}, -- Turns
					{ -- Moves
						{pelvis, y_axis, 1, 5},
					},
				},
			},
	stand_to_prone_1 = {
				{ --frame 1
					{ -- Turns
						{head,   x_axis, math.rad(0), math.rad(400)},
						{head,   y_axis, math.rad(0), math.rad(400)},
						{head,   z_axis, math.rad(0), math.rad(400)},
						
					    {pelvis, x_axis, math.rad(0), math.rad(400)},
						{pelvis, y_axis, math.rad(0), math.rad(400)},
						{pelvis, z_axis, math.rad(0), math.rad(400)},
						
						{rleg, x_axis, math.rad(150), math.rad(750)},
						{rleg, y_axis, math.rad(10), math.rad(45)},

						{lleg, x_axis, math.rad(150), math.rad(750)},
						{lleg, y_axis, math.rad(-10), math.rad(45)},

						{lthigh, x_axis, math.rad(-100), math.rad(450)},
						{lthigh, y_axis, math.rad(30), math.rad(135)},

						{rthigh, x_axis, math.rad(-100), math.rad(450)},
						{rthigh, y_axis, math.rad(-30), math.rad(135)},

						{ruparm, x_axis, math.rad(-40), math.rad(240)},
						{ruparm, y_axis, math.rad(0), math.rad(240)},
						{ruparm, z_axis, math.rad(-40), math.rad(240)},

						{rloarm, x_axis, math.rad(-90), math.rad(500)},
						{rloarm, y_axis, math.rad(0), math.rad(500)},
						{rloarm, z_axis, math.rad(10), math.rad(500)},

						{gun, x_axis, math.rad(10), math.rad(1000)},
						{gun, y_axis, math.rad(-40), math.rad(1000)},
						{gun, z_axis, math.rad(-10), math.rad(1000)},
						
						{torso, x_axis, math.rad(20), math.rad(180)},
						{torso, y_axis, math.rad(-10), math.rad(90)},
						{torso, z_axis, math.rad(0), math.rad(180)},
						
						{luparm, x_axis, math.rad(-30), math.rad(500)},
						{luparm, y_axis, math.rad(0), math.rad(500)},
						{luparm, z_axis, math.rad(-20), math.rad(500)},

						{lloarm, x_axis, math.rad(0), math.rad(1000)},
						{lloarm, y_axis, math.rad(0), math.rad(1000)},
						{lloarm, z_axis, math.rad(0), math.rad(1000)},
					},
					{
						{pelvis, y_axis, -4.8, 20},
					}, -- Moves
				},
			},
	stand_to_prone_2 = 
			{
				{ --frame 2
					{ -- Turns
					    {pelvis, x_axis, math.rad(80), math.rad(400)},
						{pelvis, y_axis, math.rad(0), math.rad(400)},
						{pelvis, z_axis, math.rad(0), math.rad(400)},

						{luparm, x_axis, math.rad(-90), math.rad(280)},
						{luparm, y_axis, math.rad(0), math.rad(280)},
						{luparm, z_axis, math.rad(-20), math.rad(280)},
						
						
						{lthigh, x_axis, math.rad(-20), math.rad(400)},
						{lthigh, y_axis, math.rad(85), math.rad(300)},
						{lthigh, z_axis, math.rad(0), math.rad(300)},

						{lleg, x_axis, math.rad(0), math.rad(800)},
						{lleg, y_axis, math.rad(0), math.rad(800)},
						{lleg, z_axis, math.rad(0), math.rad(800)},

						{rthigh, x_axis, math.rad(-20), math.rad(400)},
						{rthigh, y_axis, math.rad(-85), math.rad(300)},
						{rthigh, z_axis, math.rad(0), math.rad(300)},

						{rleg, x_axis, math.rad(0), math.rad(800)},
						{rleg, y_axis, math.rad(0), math.rad(800)},
						{rleg, z_axis, math.rad(0), math.rad(800)},
						
						{torso, x_axis, math.rad(0), math.rad(300)},
						{torso, y_axis, math.rad(0), math.rad(300)},
						{torso, z_axis, math.rad(0), math.rad(300)},

						{head, x_axis, math.rad(-60), math.rad(300)},
						{head, y_axis, math.rad(0), math.rad(300)},
						{head, z_axis, math.rad(0), math.rad(300)},

						{ruparm, x_axis, math.rad(-80), math.rad(300)},
						{ruparm, y_axis, math.rad(10), math.rad(300)},
						{ruparm, z_axis, math.rad(-50), math.rad(300)},

						{rloarm, x_axis, math.rad(-100), math.rad(300)},
						{rloarm, y_axis, math.rad(10), math.rad(300)},
						{rloarm, z_axis, math.rad(0), math.rad(300)},
						
						{gun, x_axis, math.rad(10), math.rad(600)},
						{gun, y_axis, math.rad(-35), math.rad(600)},
						{gun, z_axis, math.rad(-20), math.rad(600)},
					},
					{ -- Moves
						{pelvis, y_axis, -3, 10},
						{pelvis, z_axis, -1.6, 7},
					}, 
				},
			}
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
	stand_base = { stances.stand_base },
	prone_base = { stances.prone_base_1,
				   stances.prone_base_2 },
	run_base = { stances.run_base },
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
	local turns, moves = unpack(manipulationArrays)
	local tData = GetManipulationData(turns, deb)
	local mData = GetManipulationData(moves, deb)
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
			poses[#poses + 1] = {turns, moves, actionStance[3], actionStance[4]}
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

local keyframes = {
	stand_to_prone = {stances.kf_stand_to_prone_1,
					  stances.kf_stand_to_prone_2},
	prone_to_stand = {stances.kf_stand_to_prone_2,
					  stances.kf_stand_to_prone_1},
	default = {},
}
local keyframeDelays = {
	stand_to_prone = {0.2, 0.1, 0.1},
	prone_to_stand = {0.1, 0.2, 0.2},
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

local function Interpolate(fromTurnData, fromMoveData, toTurnData, toMoveData, duration)

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
	
	return transitionTurns, transitionMoves
end

local function FlattenArray(startTurnData, startMoveData, stancesArray, transition, delays)
	local currentTurnData = startTurnData
	local currentMoveData = startMoveData
	
	for _, stance in pairs(stancesArray) do
		local tData, mData = GetStanceManipulationData(stance)
		local i = #transition + 1
		local turns, moves = Interpolate(currentTurnData, currentMoveData, tData, mData, delays[i])
		transition[i] = {delays[i] * 1000, turns, moves}
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
	local headingTurn = poses[endPoseID][3]
	
	if headingTurn then
		Spring.Echo("heading in", poseNames[endPoseID])
		headingTurn = {unpack(headingTurn)}
		headingTurn[#headingTurn + 1] = DEFAULT_TURN_SPEED
		Spring.Echo(unpack(headingTurn))
	end
	local pitchTurn = poses[endPoseID][4]
	if pitchTurn then
		Spring.Echo("pitch in", poseNames[endPoseID])
		pitchTurn = {unpack(pitchTurn)}
		pitchTurn[#pitchTurn + 1] = DEFAULT_TURN_SPEED
		Spring.Echo(unpack(pitchTurn))
	end
	
	local lastDelay = delays[#delays]
	local turns, moves = Interpolate(currentTurnData, currentMoveData, endTurnData, endMoveData, lastDelay)
	
	
	transition[#transition + 1] = {lastDelay * 1000, turns, moves, headingTurn, pitchTurn}
	
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

CreateVariantTransitions(poseVariants.stand_aim, poseVariants.stand_ready)
CreateVariantTransitions(poseVariants.stand_aim, poseVariants.stand_aim)
CreateVariantTransitions(poseVariants.stand_aim, poseVariants.prone_aim, keyframes.stand_to_prone, keyframeDelays.stand_to_prone)
CreateVariantTransitions(poseVariants.stand_aim, poseVariants.run_aim)

CreateVariantTransitions(poseVariants.prone_ready, poseVariants.stand_ready, keyframes.prone_to_stand, keyframeDelays.prone_to_stand)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.prone_ready)
CreateVariantTransitions(poseVariants.prone_ready, poseVariants.prone_aim)

CreateVariantTransitions(poseVariants.prone_aim, poseVariants.prone_ready)
CreateVariantTransitions(poseVariants.prone_aim, poseVariants.stand_aim, keyframes.prone_to_stand, keyframeDelays.prone_to_stand)
CreateVariantTransitions(poseVariants.prone_aim, poseVariants.prone_aim)

CreateVariantTransitions(poseVariants.run_ready, poseVariants.stand_ready)
CreateVariantTransitions(poseVariants.run_ready, poseVariants.run_ready)
CreateVariantTransitions(poseVariants.run_ready, poseVariants.run_aim)

CreateVariantTransitions(poseVariants.run_aim, poseVariants.run_ready)
CreateVariantTransitions(poseVariants.run_aim, poseVariants.stand_aim)
CreateVariantTransitions(poseVariants.run_aim, poseVariants.run_aim)


return poses, poseVariants, anims, transitions