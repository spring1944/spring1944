
AbstractUnit('USInf'):Attrs{
	maxDamageMul		= 1.0,
}

AbstractUnit('USPara'):Attrs{
	maxDamageMul		= 1.4,
}

Unit('US_HQEngineer'):Extends('EngineerInf'):Extends('USInf'):Attrs{
	name				= "Field Engineer",
}

Unit('US_Rifle'):Extends('RifleInf'):Extends('USInf'):Attrs{
	name				= "M1 Garand Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "M1Garand",
		},
		[2] = { -- Grenade
			name				= "Mk2",
		},
	},
}

Unit('US_Thompson'):Extends('SMGInf'):Extends('USInf'):Attrs{
	name				= "M1A1 Thompson Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "Thompson",
		},
		[2] = { -- Grenade
			name				= "Mk2",
		},
	},
}

Unit('US_BAR'):Extends('RifleInf'):Extends('USInf'):Attrs{
	name				= "BAR M1918A2 Light Machinegun",
	description			= "Long Range Assault/Light Fire Support Unit",
	weapons = {
		[1] = { -- LMG
			name				= "BAR",
		},
		[2] = { -- Grenade
			name				= "Mk2",
		},
	},
}

Unit('US_MG'):Extends('LMGInf'):Extends('USInf'):Attrs{
	name				= "Browning M1919A4 Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "M1919A4Browning",
		},
	},
}

Unit('US_MG_Sandbag'):Extends('SandbagMG'):Attrs{
	name				= "Deployed Vickers Mk I Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "m1919a4browning_deployed",
			maxAngleDif			= 90,
		},
	},
}

Unit('US_Sniper'):Extends('SniperInf'):Extends('USInf'):Attrs{
	name				= "M1903A4 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "M1903Springfield",
		},
	},
}

Unit('US_Bazooka'):Extends('ATLauncherInf'):Extends('USInf'):Attrs{
	name				= "M9A1 Bazooka",
	weapons = {
		[1] = { -- AT Launcher
			name				= "M9A1Bazooka",
		},
	},
}

Unit('US_Flamethrower'):Extends('FlameInf'):Extends('USInf'):Attrs{
	name				= "M2 Flamethrower",
	weapons = {
		[1] = { -- Flamethrower
			name				= "M2Flamethrower",
		},
	},	
}

Unit('US_Mortar'):Extends('MedMortarInf'):Extends('USInf'):Attrs{
	name				= "81mm M1 Mortar",
	weapons = {
		[1] = { -- HE
			name				= "M1_81mmMortar",
		},
		[2] = { -- Smoke
			name				= "M1_81mmMortarSmoke",
		},
	},
}

Unit('US_Observ'):Extends('ObservInf'):Extends('USInf'):Attrs{
	weapons = {
		[2] = { -- Pistol
			name				= "m1911a1colt",
		},
	},
}

Unit('US_Paratrooper'):Extends('Infantry'):Attrs{
	script = "<NAME>.cob"
}

