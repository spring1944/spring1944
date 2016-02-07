AbstractUnit('GBRInf'):Attrs{
	maxDamageMul		= 1.4,
}

Unit('GBR_HQEngineer'):Extends('EngineerInf'):Extends('GBRInf'):Attrs{
	name				= "Sapper",
}

Unit('GBR_Rifle'):Extends('RifleInf'):Extends('GBRInf'):Attrs{
	name				= "SMLE No.4 Mk I Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "Enfield",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

Unit('GBR_STEN'):Extends('SMGInf'):Extends('GBRInf'):Attrs{
	name				= "STEN Mk II Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "STEN",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

Unit('GBR_BREN'):Extends('LMGInf'):Extends('GBRInf'):Attrs{
	name				= "BREN Mk II Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "Bren",
		},
	},
}

Unit('GBR_Vickers'):Extends('HMGInf'):Extends('GBRInf'):Attrs{
	name				= "Vickers Mk I Heavy Machinegun",
}

Unit('GBR_Vickers_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed Vickers Mk I Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "Vickers",
		},
	},
}

Unit('GBR_Sniper'):Extends('SniperInf'):Extends('GBRInf'):Attrs{
	name				= "SMLE No.4 Mk I (T) Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Enfield_T",
		},
	},
}

Unit('GBR_PIAT'):Extends('ATLauncherInf'):Extends('GBRInf'):Attrs{
	name				= "PIAT",
	weapons = {
		[1] = { -- AT Launcher
			name				= "PIAT",
		},
	},
}

Unit('GBR_3InMortar'):Extends('MedMortarInf'):Extends('GBRInf'):Attrs{
	name				= [[ML 3" Mortar Mk II]],
	weapons = {
		[1] = { -- HE
			name				= "ML3inMortar",
		},
		[2] = { -- Smoke
			name				= "ML3inMortarSmoke",
		},
	},
}

Unit('GBR_Observ'):Extends('ObservInf'):Extends('GBRInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "Webley",
		},
	},
}

-- Still inheriting GBRInf even though I'm overriding the maxDamageMul,
-- so if anyone adds something there it'll change commandos as well.
Unit('GBR_Commando'):Extends('SMGInf'):Extends('GBRInf'):Attrs{
	name				= "Commando",
	description			= "Demolitions and Infiltration Infantry",
	canManualFire		= true,
	iconType			= "commando",
	maxVelocity			= 1.8,
	
	buildDistance		= 50,
	builder				= true,
	workerTime			= 150,
	canAssist			= false,
	canReclaim			= false,
	canRepair			= false,
	cloakCost			= 0,
	cloakCostMoving		= 0,
	maxDamageMul		= 2.8,
	minCloakDistance	= 100,
	customParams		= {
		maxammo				= 2,
		weaponcost			= 50,
		weaponswithammo		= 0,
	},
	weapons = {
		[1] = { -- SMG
			name				= "SilencedSTEN",
		},
		[2] = { -- Smoke Nade
			name				= "No77",
		},
	},
}

Unit('GBR_Commando_C'):Extends('GBR_Commando')

Unit('GBR_Para_STEN'):Extends('GBR_STEN')
Unit('GBR_Para_BREN'):Extends('GBR_BREN')
Unit('GBR_Para_PIAT'):Extends('GBR_PIAT')
Unit('GBR_Para_3InMortar'):Extends('GBR_3InMortar')
Unit('GBR_Para_Observ'):Extends('GBR_Observ')
