AbstractUnit('JPNInf'):Attrs{
	maxDamageMul		= 0.8,
}

Unit('JPN_HQEngineer'):Extends('EngineerInf'):Extends('JPNInf'):Attrs{
	name				= "Field",
}

Unit('JPN_Rifle'):Extends('RifleInf'):Extends('JPNInf'):Attrs{
	name				= "Arisaka Type 99 Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "Arisaka99",
		},
		[2] = { -- Grenade
			name				= "Type99Grenade",
		},
	},
}

Unit('JPN_Type100SMG'):Extends('SMGInf'):Extends('JPNInf'):Attrs{
	name				= "Type 100 Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "Type100SMG",
		},
		[2] = { -- Grenade
			name				= "Type99Grenade",
		},
	},
}

Unit('JPN_Type99LMG'):Extends('LMGInf'):Extends('JPNInf'):Attrs{
	name				= "BREN Mk II Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "Type97MG",
		},
	},
}

Unit('JPN_Type92HMG'):Extends('HMGInf'):Extends('JPNInf'):Attrs{
	name				= "Type 92 Heavy Machinegun",
	script				= "Infantry.lua",
}

Unit('JPN_Type92HMG_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed Type 92 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "Type92MG",
		},
	},
}

Unit('JPN_Sniper'):Extends('SniperInf'):Extends('JPNInf'):Attrs{
	name				= "Arisaka 99 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Arisaka99Sniper",
		},
	},
}

Unit('JPN_Type3AT'):Extends('ATGrenadeInf'):Extends('JPNInf'):Attrs{
	name				= "Type 3 AT Grenade",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Type3AT",
		},
	},
}

Unit('JPN_Type4AT'):Extends('ATLauncherInf'):Extends('JPNInf'):Attrs{
	name				= "Type 4 AT Rocket Launcher",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Type4AT",
		},
	},
}

Unit('JPN_KneeMortar'):Extends('LightMortarInf'):Extends('JPNInf'):Attrs{
	name				= "Type 10 Grenade Discharger",
	weapons = {
		[1] = { -- HE
			name				= "KneeMortar",
		},
		[2] = { -- Smoke
			name				= "KneeMortar_Smoke",
		},
	},
}

Unit('JPN_Mortar'):Extends('MedMortarInf'):Extends('JPNInf'):Attrs{
	name				= "Type 97 81mm Mortar",
	weapons = {
		[1] = { -- HE
			name				= "Type97_81mmMortarHE",
		},
		[2] = { -- Smoke
			name				= "Type97_81mmMortarSmoke",
		},
	},
}

Unit('JPN_Observ'):Extends('ObservInf'):Extends('JPNInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "NambuType14",
		},
	},
}

Unit('JPN_Type4Mortar_Mobile'):Extends('MedMortarInf'):Extends('JPNInf'):Attrs{
	name				= "Type 4 200mm Mortar",
	buildCostMetal		= 1500,
	iconType			= "artillery",
	
	customParams = {
		canareaattack		= false,
		scriptanimation		= "mg",
		maxammo				= 1,
	},
}

Unit('JPN_Type4Mortar_Stationary'):Extends('Deployed'):Attrs{
	name				= "Type 4 200mm Mortar",
	description			= "Deployed Heavy Rocket Mortar",
	corpse				= "GERNebelwerfer_Destroyed", -- TODO: corpse
	buildCostMetal		= 1500,
	iconType			= "artillery",
	noAutoFire			= true,
	script				= "<NAME>.cob", -- TODO: use deployed.lua
	customParams = {
		canareaattack		= true,
		canfiresmoke		= true,
		maxammo				= 1,
		weapontoggle		= "smoke",
		--scriptAnimation		= "gun",
	},
	
	weapons = {
		[1] = {
			name				= "Type4RocketMortarHE",
			maxAngleDif			= 35,
		},
		[2] = {
			name				= "Type4RocketMortarSmoke",
			maxAngleDif			= 35,
		},
	},
}

