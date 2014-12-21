local JPNInf = {
	maxDamageMul		= 0.8,
}

local JPN_HQEngineer = EngineerInf:New(JPNInf):New{
	name				= "Field",
}

local JPN_Rifle = RifleInf:New(JPNInf):New{
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

local JPN_Type100SMG = SMGInf:New(JPNInf):New{
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

local JPN_Type99LMG = LMGInf:New(JPNInf):New{
	name				= "BREN Mk II Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "Type97MG",
		},
	},
}

local JPN_Type92HMG = HMGInf:New(JPNInf):New{
	name				= "Type 92 Heavy Machinegun",
}

local JPN_Type92HMG_Sandbag = SandbagMG:New{
	name				= "Deployed Type 92 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "Type92",
		},
	},
}

local JPN_Sniper = SniperInf:New(JPNInf):New{
	name				= "Arisaka 99 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Arisaka99Sniper",
		},
	},
}

local JPN_Type3AT = ATGrenadeInf:New(JPNInf):New{
	name				= "Type 3 AT Grenade",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Type4AT",
		},
	},
}

local JPN_Type4AT = ATLauncherInf:New(JPNInf):New{
	name				= "Type 4 AT Rocket Launcher",
	script				= "gbrpiat.cob",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Type4AT",
		},
	},
}

local JPN_KneeMortar = LightMortarInf:New(JPNInf):New{
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

local JPN_Mortar = MedMortarInf:New(JPNInf):New{
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

local JPN_Observ = ObservInf:New(JPNInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "NambuType14",
		},
	},
}

return lowerkeys({
	-- Regular Inf
	["JPNHQEngineer"] = JPN_HQEngineer,
	["JPNRifle"] = JPN_Rifle,
	["JPNType100SMG"] = JPN_Type100SMG,
	["JPNType99LMG"] = JPN_Type99LMG,
	["JPNType92HMG_DugIn"] = JPN_Type92HMG_Sandbag,
	["JPNType92HMG"] = JPN_Type92HMG,
	["JPNSniper"] = JPN_Sniper,
	["JPNType3AT"] = JPN_Type3AT,
	["JPNType4AT"] = JPN_Type4AT,
	["JPNKneeMortar"] = JPN_KneeMortar,
	["JPNMortar"] = JPN_Mortar,
	["JPNObserv"] = JPN_Observ,
})
