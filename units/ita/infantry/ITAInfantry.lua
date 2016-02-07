AbstractUnit('ITAInf'):Attrs{
	maxDamageMul		= 0.8,
}

AbstractUnit('Alpini'):Attrs{
	maxDamageMul		= 0.9,
	movementClass		= "KBOT_alpini",
}
AbstractUnit('Bersaglieri'):Attrs{
	maxDamageMul		= 1.3,
}

Unit('ITA_HQEngineer'):Extends('EngineerInf'):Extends('ITAInf'):Attrs{
	name				= "Field Engineer",
}

Unit('ITA_Rifle'):Extends('RifleInf'):Extends('ITAInf'):Attrs{
	name				= "Carcano Mod.91/38 Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "Mod91",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
		},
	},
}

Unit('ITA_M38'):Extends('SMGInf'):Extends('ITAInf'):Attrs{
	name				= "MAB38 Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "BerettaM38",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
		},
	},
}

Unit('ITA_Breda30'):Extends('LMGInf'):Extends('ITAInf'):Attrs{
	name				= "Breda 30 Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "Breda30",
		},
	},
}

Unit('ITA_MG'):Extends('HMGInf'):Extends('ITAInf'):Attrs{
	name				= "Breda M37 Heavy Machinegun",
	script				= "Infantry.lua",
}

Unit('ITA_MG_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed Breda M37 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "Vickers",
		},
	},
}

Unit('ITA_Sniper'):Extends('SniperInf'):Extends('ITAInf'):Attrs{
	name				= "Carcano Mod.91/38 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Mod91Sniper",
		},
	},
}

Unit('ITA_SoloAT'):Extends('ATRifleInf'):Extends('ITAInf'):Attrs{
	name				= "Solothurn S-18/100",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Solothurn",
		},
	},
}

Unit('ITA_PanzerFaust'):Extends('ATLauncherInf'):Extends('ITAInf'):Attrs{
	name				= "Panzerfaust 60",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Panzerfaust",
		},
	},
}

Unit('ITA_Mortar'):Extends('MedMortarInf'):Extends('ITAInf'):Attrs{
	name				= "81/14 Mortar",
	weapons = {
		[1] = { -- HE
			name				= "M1_81mmMortar",
		},
		[2] = { -- Smoke
			name				= "M1_81mmMortarSmoke",
		},
	},
}

Unit('ITA_Observ'):Extends('ObservInf'):Extends('ITAInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "BerettaM1934",
		},
	},
}

-- Bersaglieri
Unit('ITA_BersaglieriRifle'):Extends('ITA_Rifle'):Extends("Bersaglieri"):Attrs{
	name				= "Carcano Mod.91/41 Rifle",
	description			= "Elite Infantry armed with new rifle and heavy grenades",
	buildpic			= "ITABersaglieriRifle.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- Rifle
			name				= "Mod91_41",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
		},
		[3] = {
			name				= "bredamod42",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

Unit('ITA_BersaglieriM38'):Extends('ITA_M38'):Extends("Bersaglieri"):Attrs{
	name				= "MAB38 Submachinegun",
	description			= "Elite Close-Quarters Assault Infantry armed with heavy grenade",
	buildpic			= "ITABersaglieriM38.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- SMG
			name				= "BerettaM38",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
		},
		[3] = {
			name				= "L_type_grenade",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

Unit('ITA_EliteSoloAT'):Extends('ITA_SoloAT'):Extends("Bersaglieri"):Attrs{
	name				= "Scoped Solothurn S-18/100",
	description			= "Scoped Long Range Light Anti-Tank",
	weapons = {
		[1] = { -- AT Launcher
			name				= "ScopedSolothurn",
		},
	},
}

-- Alpini
Unit('ITA_AlpiniRifle'):Extends('ITA_Rifle'):Extends("Alpini"):Attrs{
	name				= "Carcano Mod.91/38 Rifle",
	description			= "Mountaineering Rifle Infantry armed with heavy stickgrenade",
	buildpic			= "ITAAlpiniRifle.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- Rifle
			name				= "Mod91",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
		},
		[3] = {
			name				= "L_type_grenade",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

Unit('ITA_AlpiniFNAB43'):Extends('ITA_M38'):Extends("Alpini"):Attrs{
	name				= "FNAB43 Submachinegun",
	description			= "Mountaineering Close-Quarters Assault Infantry armed with heavy grenade",
	buildpic			= "ITABersaglieriM38.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- SMG
			name				= "fnab43",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
		},
		[3] = {
			name				= "bredamod42",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

Unit('ITA_AlpiniObserv'):Extends('ITA_Observ'):Extends("Alpini"):Attrs{
	buildpic			= "ITAAlpiniObserv.png", -- have to overwrite Clone
}

Unit('ITA_AlpiniMortar'):Extends('ITA_Mortar'):Extends("Alpini"):Attrs{
	buildpic			= "ITAAlpiniMortar.png", -- have to overwrite Clone
}

