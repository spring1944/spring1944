AbstractUnit('GERInf'):Attrs{
	maxDamageMul		= 1.1,
}

Unit('GER_HQEngineer'):Extends('EngineerInf'):Extends('GERInf'):Attrs{
	name				= "Feldpionier",
}

Unit('GER_Rifle'):Extends('RifleInf'):Extends('GERInf'):Attrs{
	name				= "Karabiner 98K Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "k98k",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

Unit('GER_MP40'):Extends('SMGInf'):Extends('GERInf'):Attrs{
	name				= "MP40 Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "MP40",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

Unit('GER_MG42'):Extends('LMGInf'):Extends('GERInf'):Attrs{
	name				= "MG42 Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "MG42",
		},
	},
}


Unit('GER_MG42_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed MG42 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "MG42_deployed",
			maxAngleDif			= 90,
		},
	},
}

Unit('GER_Sniper'):Extends('SniperInf'):Extends('GERInf'):Attrs{
	name				= "K98k Heckenschutze",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "k98kscope",
		},
	},
}

Unit('GER_PanzerFaust'):Extends('ATLauncherInf'):Extends('GERInf'):Attrs{
	name				= "Panzerfaust 60",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Panzerfaust",
		},
	},
}

Unit('GER_PanzerSchrek'):Extends('ATLauncherInf'):Extends('GERInf'):Attrs{
	name				= "Panzerschrek RPzB 54",
	description			= "Heavy Anti-Tank Infantry",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Panzerschrek",
		},
	},
}

Unit('GER_GrW34'):Extends('MedMortarInf'):Extends('GERInf'):Attrs{
	name				= "8cm GrW 34 Mortar",
	weapons = {
		[1] = { -- HE
			name				= "GrW34_8cmMortar",
		},
		[2] = { -- Smoke
			name				= "GrW34_8cmMortarSmoke",
		},
	},
}

Unit('GER_Observ'):Extends('ObservInf'):Extends('GERInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "WaltherP38",
		},
	},
}


