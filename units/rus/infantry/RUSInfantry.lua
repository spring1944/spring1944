
AbstractUnit('RUSInf'):Attrs{
	maxDamageMul		= 0.65,
	customParams = {
		flagCapRate		= 0.085,
	},
}

AbstractUnit('Partisan'):Attrs{
	maxDamageMul		= 0.40,

	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 225,
}

Unit('RUS_Engineer'):Extends('EngineerInf'):Extends('RUSInf'):Attrs{
	name				= "Engineer",
}

Unit('RUS_Commissar'):Extends('EngineerInf'):Extends('RUSInf'):Attrs{
	name				= "Engineer",
	description			= "Political Commander",
	energyStorage		= 0.01, -- TODO: needed?
	
	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 250,

    iconType            = "commissar",
	
	customParams = {
		blockfear			= true,
		flagCapRate			= 3.125,
	},
}

Unit('RUS_Rifle'):Extends('RifleInf'):Extends('RUSInf'):Attrs{
	name				= "Mosin-Nagant M91/30 Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "MosinNagant",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

Unit('RUS_PPSh'):Extends('SMGInf'):Extends('RUSInf'):Attrs{
	name				= "PPSh 41 Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "PPSh",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

Unit('RUS_DP'):Extends('LMGInf'):Extends('RUSInf'):Attrs{
	name				= "DP 28 Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "DP",
		},
	},
}

Unit('RUS_Maxim'):Extends('HMGInf'):Extends('RUSInf'):Attrs{
	name				= "Maxim PM 1910 Heavy Machinegun",
	buildpic			= "RUSSandbagMG.png",
}

Unit('RUS_Maxim_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed Maxim PM 1910 Heavy Machinegun",
	buildpic			= "RUSSandbagMG.png",
	weapons = {
		[1] = { -- HMG
			name				= "Maxim",
		},
	},
}

Unit('RUS_Sniper'):Extends('SniperInf'):Extends('RUSInf'):Attrs{
	name				= "Mosin-Nagant M91/30 PU Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "MosinNagantPU",
		},
	},
	customparams = {
		killvoicecategory	= "RUS/Infantry/Sniper/RUS_SNIPER_KILL",
		killvoicephasecount	= 3,
	},
}

Unit('RUS_PTRD'):Extends('ATRifleInf'):Extends('RUSInf'):Attrs{
	name				= "PTRD",
	weapons = {
		[1] = { -- AT Rifle
			name				= "PTRD",
		},
	},
}

Unit('RUS_RPG43'):Extends('ATGrenadeInf'):Extends('RUSInf'):Attrs{
	name				= "RPG43",
	customparams = {
		scriptanimation		= "smg",
	},
	weapons = {
		[1] = { -- AT Grenade
			name				= "RPG43",
		},
	},
}

Unit('RUS_Mortar'):Extends('MedMortarInf'):Extends('RUSInf'):Attrs{
	name				= "M1937 Mortar",
	weapons = {
		[1] = { -- HE
			name				= "M1937_Mortar",
		},
		[2] = { -- Smoke
			name				= "M1937_MortarSmoke",
		},
	},
}

Unit('RUS_Observ'):Extends('ObservInf'):Extends('RUSInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "TT33",
		},
	},
}

-- Naval Inf
Unit('RUS_NI_Rifle'):Extends('RifleInf'):Extends('RUSInf'):Attrs{
	name				= "SVT-40 Rifle",
	description			= "Naval Infantry Rifleman",
	weapons = {
		[1] = { -- Rifle
			name				= "SVT",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

-- Partisans
Unit('RUS_PartisanRifle'):Extends('RifleInf'):Extends('Partisan'):Attrs{
	name				= "Mosin Nagant M91/30 Partisan",
	description			= "Very Light Defensive Ambusher",
	
	customParams = {
		flagCapRate			= 0.005,
		weapontoggle		= "ambush",
	},
	
	weapons = {
		[1] = { -- Rifle
			name				= "MosinNagant",
		},
		[2] = { -- Grenade
			name				= "Molotov",
		},
	},
}

