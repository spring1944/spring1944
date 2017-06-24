local GER_Flak_Tower = HQ:New(Bunker):New{
	name					= "Flakturm G",
	buildCostMetal			= 40000,
	collisionVolumeScales	= [[150 30 110]],
	collisionVolumeOffsets	= [[0 -13 0]],
    -- this will rarely be needed
    corpse                  = "gerflakturmg_dead",
	footprintX				= 10,
	footprintZ				= 10,
	maxDamage				= 12500,

	idleAutoHeal			= 30,
	
	energyMake				= 50,
	metalMake				= 50,
	
	transportCapacity		= 12,
	usePieceCollisionVolumes	= true,

	-- Transport tags
	transportSize		= 1, -- assumes footprint of BoatChild == 1
	isFirePlatform 		= true,

    workerTime          = 50,
    
	customparams = {
		mother				= true,
        children            = {
            "GER_Flak40_Twin_Child",
            "GER_Flak40_Twin_Child",
            "GER_Flak40_Twin_Child",
            "GER_Flak40_Twin_Child",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
            "GERMAL_Turret_Quad20mm",
        },
		supplyrange			= 1000,
	},

	--[[
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "Flak40_12_8cm_HE",
		},
	},
	]]--

	yardmap					= [[oooooooooo 
								oooooooooo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo 
								ooyyyyyyoo]],
}

local GER_Flak40_Twin_Base = Building:New{
    name                    = "12.8cm Flak40 Zwilling",
    buildCostMetal          = 4000,
    maxDamage               = 4000,
    corpse                  = "gerflak40_twin_turret_destroyed",
    script				    = "BoatChild.lua",
    weapons = {
        [1] = {
            name            = "Flak40_12_8cm_HE",
        },
        [2] = {
            name            = "Flak40_12_8cm_HE",
            slaveTo         = 1,
        },        
    },
	customparams = {
		maxammo					= 18,

		barrelrecoildist		= 16,
		barrelrecoilspeed		= 32,
		turretturnspeed			= 12,
		elevationspeed			= 15,
    },
}

-- child version of the same
local GER_Flak40_Twin_Child = OpenBoatTurret:New(GER_Flak40_Twin_Base, true):New{
    objectName                  = "<SIDE>/GERFlak40_Twin_Turret.s3o",
}

-- Spambot HQ
local spam_hq = GER_Flak_Tower:New{
	buildPic	= "gerflakturmg.png",
	objectName	= "GER/GERFlakTurmG.s3o",
}

return lowerkeys({
	["GERFlakTurmG"] = GER_Flak_Tower,
    ["GERFlak40_Twin_Turret"] = GER_Flak40_Twin_Base,
    ["GER_Flak40_Twin_Child"] = GER_Flak40_Twin_Child,
	["spam_hq"] = spam_hq,
})
