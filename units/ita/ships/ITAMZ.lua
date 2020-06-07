local ITA_MZ = TankLandingCraftComposite:New{
	name					= "Motozattera",
	acceleration			= 0.15,
	brakeRate				= 0.14,
	buildCostMetal			= 2000, --5500, why so much cheaper than MFP?
	collisionVolumeOffsets	= [[0.0 -30.0 0.0]],
	collisionVolumeScales	= [[60.0 50.0 220.0]],
	maxDamage				= 23900,
	maxReverseVelocity		= 0.72,
	maxVelocity				= 2, -- 1.3 in fbi, all other LCT are 2
	transportMass			= 4600,
	turnRate				= 35,	
	loadingRadius			= 350,
	unloadSpread			= 10,
	weapons = {	
		[1] = {
			name				= "Ansaldo76mmL40HE",
		},
	},
	customparams = {
		children = {
			"itamz_turret_76mm",
			"ITAMZ_Turret_20mm",
			"ITAMZ_Turret_20mm_Rear",
		},
		supplyRange				= 350, -- override, smaller radius as armed
		-- other LCT don't have armour values currently - not sure what impact this will have on their resilience?
		armour = {
			base = {
				front = {
					thickness		= 6,
				},
				rear = {
					thickness		= 16,
				},
				side = {
					thickness 		= 16,
				},
				top = {
					thickness		= 6,
				},
			},
		},

		deathanim = {
			["x"] = {angle = 10, speed = 5},
		},
		customanims = "ita_mz",
	},
}

local ITA_MZ_Turret_76mm = OpenBoatTurret:New{
	name					= "Ansaldo 76mm Turret",
	description				= "76mm Turret",
	objectName				= "<SIDE>/itamz_turret_76mm.s3o",
	weapons = {	
		[1] = {
			name				= "Ansaldo76mmL40HE",
			maxAngleDif			= 270,
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		maxammo					= 8,

		barrelrecoildist		= 2,
		barrelrecoilspeed		= 10,
		turretturnspeed			= 10,
		elevationspeed			= 10,
		facing 					= 2,
		defaultheading1			= math.rad(180),
	},
}

local ITA_MZ_Turret_20mm = OpenBoatTurret:New{
	name					= "20mm Turret",
	description				= "AA Turret",
	objectName				= "<SIDE>/ITAGabbiano_Turret_20mm.s3o",
	weapons = {	
		[1] = {
			name				= "BredaM3520mmAA",
			maxAngleDif			= 270,
			onlyTargetCategory	= "AIR",
			mainDir				= [[0 0 1]],
		},
		[2] = {
			name				= "BredaM3520mmHE",
			maxAngleDif			= 270,
			mainDir				= [[0 0 1]],
		},
	},
	customparams = {
		maxammo					= 14,
		barrelrecoildist		= 3,
		barrelrecoilspeed		= 20,
		turretturnspeed			= 45,
		elevationspeed			= 45,
		aaweapon				= 1,
    },
}

local ITA_MZ_Turret_20mm_Rear = ITA_MZ_Turret_20mm:New{
	weapons = {	
		[1] = {
			mainDir				= [[0 0 -1]],
		},
		[2] = {
			mainDir				= [[0 0 -1]],
		},
	},
	customparams = {
		facing 					= 2,
		defaultheading1				= math.rad(180),
	},
}

return lowerkeys({
	["ITAMZ"] = ITA_MZ,
	["itamz_turret_76mm"] = ITA_MZ_Turret_76mm,
	["ITAMZ_Turret_20mm"] = ITA_MZ_Turret_20mm,
	["ITAMZ_Turret_20mm_Rear"] = ITA_MZ_Turret_20mm_Rear,
})
