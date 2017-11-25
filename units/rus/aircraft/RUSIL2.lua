local RUS_IL2 = FighterBomber:New(ArmouredPlane):New{
	name				= "IL-2M Shturmovik",
	description			= "Attack Aircraft",
	buildCostMetal		= 3375,
	maxDamage			= 436,

	maxAcc				= 0.474,
	maxAileron			= 0.004,
	maxBank				= 0.75,
	maxElevator			= 0.002,
	maxPitch			= 0.03,
	maxRudder			= 0.0019,
	maxVelocity			= 14,

	customParams = {
		enginesound			= "p51b-",
		enginesoundnr		= 16,
		maxammo				= 4,
		maxFuel				= 180,

	},

	weapons = {
		[1] = {
			name				= "RS82Rocket",
			maxAngleDif			= 30,
		},
		[2] = {
			name				= "RS82Rocket",
			maxAngleDif			= 30,
			slaveTo				= 1,
		},
		[3] = {
			name				= "bomb",
			mainDir				= [[0 -0.18 1]],
			maxAngleDif			= 30,
		},
		[4] = {
			name				= "bomb",
			mainDir				= [[0 -0.18 1]],
			maxAngleDif			= 30,
			slaveTo				= 3,
		},
		[5] = {
			name				= "VYa23mm",
			maxAngleDif			= 10,
		},
		[6] = {
			name				= "VYa23mm",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},
		[7] = {
			name				= "ShKAS1941",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},
		[8] = {
			name				= "ShKAS1941",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},
		[9] = {
			name				= "MaximAA",
			maxAngleDif			= 90,
			mainDir				= [[0 1 -1]],
		},
	},
}

local RUS_IL2PTAB = RUS_IL2:Clone("RUSIl2"):New{
	name				= "IL-2M Shturmovik with PTAB",
	description			= "Anti-tank Aircraft",
	buildpic			= "RUSIL2PTAB.png", -- override clone
	weapons = {
		[1] = {
			name				= "NOWEAPON",
		},
		[2] = {
			name				= "PTAB",
			maxAngleDif			= 30,
		},
		[3] = {
			name				= "NOWEAPON",
		},
		[4] = {
			name				= "NOWEAPON",
		},
	},
	customParams = {

	},
}

return lowerkeys({
	["RUSIL2"] = RUS_IL2,
	["RUSIL2PTAB"] = RUS_IL2PTAB,
})
