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
                {rthigh, x_axis, 0, math.rad(180)},
                
                {lthigh, x_axis, math.rad(17), math.rad(60)},
                
                {rleg, x_axis, math.rad(25), math.rad(30)},
                {lleg, x_axis, math.rad(80), math.rad(120)},
            },
        },
        { --frame 2
            turns = { -- Turns
                {rthigh, x_axis, math.rad(30), math.rad(150)},
                
                {lthigh, x_axis, math.rad(-45), math.rad(300)},
                
                {rleg, x_axis, math.rad(45), math.rad(100)},
                {lleg, x_axis, math.rad(35), math.rad(220)},
            },
        },
        { --frame 3
            turns = {
                {lthigh, x_axis, 0, math.rad(220)},
                
                {rthigh, x_axis, math.rad(17), math.rad(90)},
                
                {lleg, x_axis, math.rad(25), math.rad(50)},
                {rleg, x_axis, math.rad(80), math.rad(180)},
            },
        },
        { --frame 4
            turns = {
                {lthigh, x_axis, math.rad(30), math.rad(150)},
                
                {rthigh, x_axis, math.rad(-45), math.rad(300)},
                
                {lleg, x_axis, math.rad(45), math.rad(100)},
                {rleg, x_axis, math.rad(35), math.rad(220)},
            },
        },
        wait = {7, 7},
    },
}

local stances = {
    stand_1 = {
        turns = {
            {pelvis, x_axis, 0},
            {pelvis, y_axis, 0},
            {pelvis, z_axis, 0},

            {torso,  x_axis, math.rad(35)},
            {torso,  y_axis, math.rad(-12)},
            {torso,  z_axis, math.rad(-7)},

            {head,  x_axis, math.rad(-25)},
            {head,  y_axis, math.rad(15)},
            {head,  z_axis, math.rad(-5)},

            {luparm,  x_axis, math.rad(-63)},
            {luparm,  y_axis, math.rad(-17)},
            {luparm,  z_axis, math.rad(23)},

            {ruparm,  x_axis, math.rad(-76)},
            {ruparm,  y_axis, math.rad(-35)},
            {ruparm,  z_axis, math.rad(45)},

            {lloarm,  x_axis, math.rad(-48)},
            {lloarm,  y_axis, math.rad(-8)},
            {lloarm,  z_axis, math.rad(15)},

            {rloarm,  x_axis, math.rad(-5)},
            {rloarm,  y_axis, math.rad(99)},
            {rloarm,  z_axis, math.rad(-75)},

            {rthigh, x_axis, math.rad(10)},
            {rthigh, y_axis, 0},
            {rthigh, z_axis, math.rad(-5)},
            
            {lthigh, x_axis, math.rad(-20)},
            {lthigh, y_axis, 0},
            {lthigh, z_axis, 0},
            
            {rleg, x_axis, math.rad(20)},
            {rleg, y_axis, math.rad(2)},
            {rleg, z_axis, 0},
            
            {lleg, x_axis, math.rad(15)},
            {lleg, y_axis, 0},
            {lleg, z_axis, 0},
            
            {rfoot, x_axis, math.rad(-30)},
            {rfoot, y_axis, math.rad(-3)},
            {rfoot, z_axis, math.rad(1)},
            
            {lfoot, x_axis, math.rad(5)},
            {lfoot, y_axis, 0},
            {lfoot, z_axis, 0},
        },
        moves = { -- Moves
            {pelvis, x_axis, 0},
            {pelvis, y_axis, -1.06},
            {pelvis, z_axis, 0},
        },
    },
    prone_1 = {
        turns = {
            {pelvis, x_axis, 0},
            {pelvis, y_axis, 0},
            {pelvis, z_axis, 0},

            {torso,  x_axis, math.rad(34)},
            {torso,  y_axis, math.rad(-12)},
            {torso,  z_axis, math.rad(-7)},

            {head,  x_axis, math.rad(-25)},
            {head,  y_axis, math.rad(15)},
            {head,  z_axis, math.rad(-5)},

            {luparm,  x_axis, math.rad(-77)},
            {luparm,  y_axis, math.rad(-104)},
            {luparm,  z_axis, math.rad(112)},

            {ruparm,  x_axis, math.rad(-74)},
            {ruparm,  y_axis, math.rad(-104)},
            {ruparm,  z_axis, math.rad(106)},

            {lloarm,  x_axis, math.rad(-63)},
            {lloarm,  y_axis, math.rad(-9)},
            {lloarm,  z_axis, math.rad(18)},

            {rloarm,  x_axis, math.rad(-5)},
            {rloarm,  y_axis, math.rad(100)},
            {rloarm,  z_axis, math.rad(-75)},

            {rthigh, x_axis, math.rad(-35)},
            {rthigh, y_axis, math.rad(-60)},
            {rthigh, z_axis, math.rad(-5)},
            
            {lthigh, x_axis, math.rad(-45)},
            {lthigh, y_axis, 0},
            {lthigh, z_axis, 0},
            
            {rleg, x_axis, math.rad(80)},
            {rleg, y_axis, math.rad(26)},
            {rleg, z_axis, math.rad(22)},
            
            {lleg, x_axis, math.rad(80)},
            {lleg, y_axis, 0},
            {lleg, z_axis, 0},
            
            {rfoot, x_axis, math.rad(-30)},
            {rfoot, y_axis, math.rad(-3)},
            {rfoot, z_axis, math.rad(1)},
            
            {lfoot, x_axis, math.rad(-45)},
            {lfoot, y_axis, math.rad(-5)},
            {lfoot, z_axis, math.rad(2)},
        },
        moves = { -- Moves
            {pelvis, x_axis, 0},
            {pelvis, y_axis, -2.36},
            {pelvis, z_axis, 0},
        },
    },
    pinned_1 = {
        turns = {
            {pelvis, x_axis, 0},
            {pelvis, y_axis, 0},
            {pelvis, z_axis, 0},

            {torso,  x_axis, math.rad(50)},
            {torso,  y_axis, math.rad(-1)},
            {torso,  z_axis, math.rad(-1)},

            {head,  x_axis, math.rad(33)},
            {head,  y_axis, math.rad(-18)},
            {head,  z_axis, math.rad(-12)},

            {luparm,  x_axis, math.rad(-65)},
            {luparm,  y_axis, math.rad(-62)},
            {luparm,  z_axis, math.rad(95)},

            {ruparm,  x_axis, math.rad(-50)},
            {ruparm,  y_axis, math.rad(-175)},
            {ruparm,  z_axis, math.rad(166)},

            {lloarm,  x_axis, math.rad(-75)},
            {lloarm,  y_axis, math.rad(-176)},
            {lloarm,  z_axis, math.rad(177)},

            {rloarm,  x_axis, math.rad(-6)},
            {rloarm,  y_axis, math.rad(83)},
            {rloarm,  z_axis, math.rad(-95)},

            {rthigh, x_axis, math.rad(-55)},
            {rthigh, y_axis, math.rad(-30)},
            {rthigh, z_axis, 0},
            
            {lthigh, x_axis, math.rad(-70)},
            {lthigh, y_axis, 0},
            {lthigh, z_axis, 0},
            
            {rleg, x_axis, math.rad(95)},
            {rleg, y_axis, 0},
            {rleg, z_axis, 0},
            
            {lleg, x_axis, math.rad(80)},
            {lleg, y_axis, 0},
            {lleg, z_axis, 0},
            
            {rfoot, x_axis, math.rad(-40)},
            {rfoot, y_axis, 0},
            {rfoot, z_axis, 0},
            
            {lfoot, x_axis, math.rad(-10)},
            {lfoot, y_axis, 0},
            {lfoot, z_axis, 0},
        },
        moves = { -- Moves
            {pelvis, x_axis, 0},
            {pelvis, y_axis, -2.0},
            {pelvis, z_axis, 0},
        },
    },
    run_1  = {
        turns = { -- Turns
            {pelvis, x_axis, 0},
            {pelvis, y_axis, 0},
            {pelvis, z_axis, 0},

            {torso,  x_axis, math.rad(35)},
            {torso,  y_axis, math.rad(-12)},
            {torso,  z_axis, math.rad(-7)},

            {head,  x_axis, math.rad(-25)},
            {head,  y_axis, math.rad(15)},
            {head,  z_axis, math.rad(-5)},

            {luparm,  x_axis, math.rad(-63)},
            {luparm,  y_axis, math.rad(-17)},
            {luparm,  z_axis, math.rad(23)},

            {ruparm,  x_axis, math.rad(-76)},
            {ruparm,  y_axis, math.rad(-35)},
            {ruparm,  z_axis, math.rad(45)},

            {lloarm,  x_axis, math.rad(-48)},
            {lloarm,  y_axis, math.rad(-8)},
            {lloarm,  z_axis, math.rad(15)},

            {rloarm,  x_axis, math.rad(-5)},
            {rloarm,  y_axis, math.rad(99)},
            {rloarm,  z_axis, math.rad(-75)},

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
            {pelvis, y_axis, -1.06},
            {pelvis, z_axis, 0},
        },
        anim = anims.run,
    },
}

local variants = {
    stand = { stances.stand_1 },
    prone = { stances.prone_1 },
    pinned = { stances.pinned_1 },
    run = { stances.run_1 },
    crawl = { stances.run_1 },
}

return variants
