local GERInf = {
	maxDamageMul		= 1.1,
	customParams = {

	},
}

local GER_HQEngineer = EngineerInf:New(GERInf):New{
	name				= "Feldpionier",
}

local GER_Rifle = RifleInf:New(GERInf):New{
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

local GER_MP40 = SMGInf:New(GERInf):New{
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

local GER_MG42 = LMGInf:New(GERInf):New{
	name				= "MG42 Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "MG42",
		},
	},
}


local GER_MG42_Sandbag = SandbagMG:New{
	name				= "Deployed MG42 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "MG42_deployed",
			maxAngleDif			= 90,
		},
	},
}

local GER_Sniper = SniperInf:New(GERInf):New{
	name				= "K98k Heckenschutze",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "k98kscope",
		},
	},
}

local GER_PanzerFaust = ATLauncherInf:New(GERInf):New{
	name				= "Panzerfaust 60",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Panzerfaust",
		},
	},
}

local GER_PanzerSchrek = ATLauncherInf:New(GERInf):New{
	name				= "Panzerschrek RPzB 54",
	description			= "Heavy Anti-Tank Infantry",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Panzerschrek",
		},
	},
}

local GER_GrW34 = MedMortarInf:New(GERInf):New{
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

local GER_Observ = ObservInf:New(GERInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "WaltherP38",
		},
	},
}

local GER_Crew = CrewInf:New(GERInf):New{
	weapons = {
		[1] = { -- Pistol
			name				= "WaltherP38",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}


return lowerkeys({
	-- Regular Inf
	["GERHQEngineer"] = GER_HQEngineer,
	["GERHQAIEngineer"] = GER_HQEngineer:Clone("GERHQEngineer"),
	["GERRifle"] = GER_Rifle,
	["GERMP40"] = GER_MP40,
	["GERMG42"] = GER_MG42,
	["GERMG42_Sandbag"] = GER_MG42_Sandbag,
	["GERSniper"] = GER_Sniper,
	["GERPanzerfaust"] = GER_PanzerFaust,
	["GERPanzerschrek"] = GER_PanzerSchrek,
	["GERGrW34"] = GER_GrW34,
	["GERObserv"] = GER_Observ,
	["GERCrew"] = GER_Crew,
})
