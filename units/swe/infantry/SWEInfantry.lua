AbstractUnit('SWEInf'):Attrs{
	maxDamageMul		= 1.4,
}

Unit('SWE_HQEngineer'):Extends('EngineerInf'):Extends('SWEInf'):Attrs{
	name				= "Ingenjörer",
}

Unit('SWE_Rifle'):Extends('RifleInf'):Extends('SWEInf'):Attrs{
	name				= "6,5 mm Gevär m/38",
	weapons = {
		[1] = { -- Rifle
			name				= "Enfield",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

Unit('SWE_AgM42'):Extends('RifleInf'):Extends('SWEInf'):Attrs{
	name				= "6,5 mm Automatgevär m/42",
	weapons = {
		[1] = { -- Rifle
			name				= "M1Garand",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

Unit('SWE_KPistM3739'):Extends('SMGInf'):Extends('SWEInf'):Attrs{
	name				= "9mm Kulsprutepistol m/37-39",
	weapons = {
		[1] = { -- SMG
			name				= "STEN",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

Unit('SWE_KgM37'):Extends('RifleInf'):Extends('SWEInf'):Attrs{
	name				= "Kulsprutegevär m/37 Light Machinegun",
	description			= "Long Range Assault/Light Fire Support Unit",
	weapons = {
		[1] = { -- LMG
			name				= "BAR",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},		
	},
}

Unit('SWE_MG'):Extends('HMGInf'):Extends('SWEInf'):Attrs{
	name				= "Kulsprutegevär m/36 Heavy Machinegun",
}

Unit('SWE_MG_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed Kulsprutegevär m/36 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "m1919a4browning_deployed",
		},
	},
}

Unit('SWE_Sniper'):Extends('SniperInf'):Extends('SWEInf'):Attrs{
	name				= "6,5 mm Gevär m/41 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Enfield_T",
		},
	},
}

Unit('SWE_PSkottM45'):Extends('ATLauncherInf'):Extends('SWEInf'):Attrs{
	name				= "Pansarskott m/45",
	weapons = {
		[1] = { -- AT Launcher
			name				= "PanzerFaust",
		},
	},
}

Unit('SWE_PvGM42'):Extends('ATRifleInf'):Extends('SWEInf'):Attrs{
	name				= "Pansarvärnsgevär m/42",
	weapons = {
		[1] = { -- AT Rifle
			name				= "Solothurn",
		},
	},
}

Unit('SWE_Mortar'):Extends('MedMortarInf'):Extends('SWEInf'):Attrs{
	name				= "8 cm Granatkastare m/29-34",
	weapons = {
		[1] = { -- HE
			name				= "ML3inMortar",
		},
		[2] = { -- Smoke
			name				= "ML3inMortarSmoke",
		},
	},
}

Unit('SWE_Observ'):Extends('ObservInf'):Extends('SWEInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "WaltherP38",
		},
	},
}


