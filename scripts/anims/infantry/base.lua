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

local stances = {
	null = {},
	sit = {
		turns = {
			{rthigh, x_axis, -math.rad(90)},
			{lthigh, x_axis, -math.rad(90)},
			{rleg, x_axis, math.rad(90)},
			{lleg, x_axis, math.rad(90)},
			{gun, z_axis, math.rad(180)},
			{gun, x_axis, 0},
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
		},
		moves = {
			{pelvis, y_axis, -6},
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
						{ground, x_axis, 0},
						{ground, y_axis, 0},
						{ground, z_axis, 0},
					},
					moves = { -- Moves
						{pelvis, x_axis, 0},
						{pelvis, y_axis, 0},
						{pelvis, z_axis, 0},
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
						
						{ground, x_axis, 0},
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
	build = {
					headingTurn = {pelvis, y_axis, 0, 1},
				},
}

local variants = {
	null = {stances.null},
	sit = {stances.sit},
	stand_base = { stances.stand_base },
	prone_base = { stances.prone_base_1,
				   stances.prone_base_2 },
	run_base = { stances.run_base },
	crawl = { stances.crawl},
	pinned = {stances.pinned_1, stances.pinned_2, stances.pinned_3},
	build = {stances.build},
}

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

return anims, variants, keyframes, keyframeDelays