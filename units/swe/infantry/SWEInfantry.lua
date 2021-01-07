local SWEInf = {
	maxDamageMul		= 1.4,
	customParams = {

	},
}

local SWE_HQEngineer = EngineerInf:New(SWEInf):New{
	name				= "Ingenjörer",
}

local SWE_Rifle = RifleInf:New(SWEInf):New{
	name				= "6,5 mm Gevär m/38",
	weapons = {
		[1] = { -- Rifle
			name				= "Gevar_M_38",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

local SWE_AgM42 = RifleInf:New(SWEInf):New{
	name				= "6,5 mm Automatgevär m/42",
	weapons = {
		[1] = { -- Rifle
			name				= "AgM42",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

local SWE_KPistM3739 = SMGInf:New(SWEInf):New{
	name				= "9mm Kulsprutepistol m/37-39",
	weapons = {
		[1] = { -- SMG
			name				= "KPistM3738",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

local SWE_KgM37 = RifleInf:New(SWEInf):New{
	name				= "Kulsprutegevär m/37 Light Machinegun",
	description			= "Long Range Assault/Light Fire Support Unit",
	iconType			= "bar",
	weapons = {
		[1] = { -- LMG
			name				= "BAR",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},		
	},
}

local SWE_MG = HMGInf:New(SWEInf):New{
	name				= "Kulsprutegevär m/36 Heavy Machinegun",
}

local SWE_MG_Sandbag = SandbagMG:New{
	name				= "Deployed Kulsprutegevär m/36 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "ksp_m1936_deployed",
		},
	},
}

local SWE_Sniper = SniperInf:New(SWEInf):New{
	name				= "6,5 mm Gevär m/41 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Gevar_M_38_Sniper",
		},
	},
}

local SWE_PSkottM45 = ATLauncherInf:New(SWEInf):New{
	name				= "Pansarskott m/45",
	weapons = {
		[1] = { -- AT Launcher
			name				= "PanzerFaust",
		},
	},
}

local SWE_PvGM42 = ATRifleInf:New(SWEInf):New{
	name				= "Pansarvärnsgevär m/42",
	iconType			= "itasolo",
	weapons = {
		[1] = { -- AT Rifle
			name				= "pvgm42",
		},
	},
}

local SWE_Mortar = MedMortarInf:New(SWEInf):New{
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

local SWE_Observ = ObservInf:New(SWEInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "HusqvarnaM40",
		},
	},
}

local SWE_Crew = CrewInf:New(SWEInf):New{
	weapons = {
		[1] = { -- Pistol
			name				= "HusqvarnaM40",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

-- Swedish partisan
local Partisan = {
	maxDamageMul		= 0.40,

	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 225,
	corpse			= "ruspsoldier_dead",
}

local SWE_Partisan = RifleInf:New(Partisan):New{
	name				= "HVA M/96 Partisan",
	description			= "Very Light Defensive Ambusher",

	customParams = {
		flagCapRate			= 0.005,
		weapontoggle		= "ambush",
	},

	weapons = {
		[1] = { -- Rifle
			name				= "HVAM96",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

-- inf-mobile 20mm
local SWE_PvlvM40_Mobile = HMGInf:New(SWEInf):New{
	name			= "20 mm maskinkanon M.40 S",
	description		= "AT/AA gun",
	buildpic		= "SWEPvLvM40_AT.png",
	buildCostMetal			= 938,
	iconType		= "rusptrd",
	customparams = {
		scriptanimation		= "wheeled",
	},
}

return lowerkeys({
	-- Regular Inf
	["SWEEngineer"] = SWE_HQEngineer,
	["SWERifle"] = SWE_Rifle,
	["SWEAgM42"] = SWE_AgM42,
	["SWEKPistM3739"] = SWE_KPistM3739,
	["SWEKgM37"] = SWE_KgM37,
	["SWEMG_Sandbag"] = SWE_MG_Sandbag,
	["SWEMG"] = SWE_MG,
	["SWESniper"] = SWE_Sniper,
	["SWEPvGM42"] = SWE_PvGM42,
	["SWEPSkottM45"] = SWE_PSkottM45,
	["SWEMortar"] = SWE_Mortar,
	["SWEObserv"] = SWE_Observ,
	["SWECrew"] = SWE_Crew,
	["SWEPvlvM40"] = SWE_PvlvM40_Mobile,
	["SWEPartisan"] = SWE_Partisan,
})
