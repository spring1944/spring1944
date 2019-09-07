local ITAInf = {
	maxDamageMul		= 0.8,
	customParams = {

	},
}
local Alpini = {
	maxDamageMul		= 1.25,
	movementClass		= "KBOT_alpini",
}
local Bersaglieri = {
	maxDamageMul		= 1.15,
}

local ITA_HQEngineer = EngineerInf:New(ITAInf):New{
	name				= "Field Engineer",
}

local ITA_Rifle = RifleInf:New(ITAInf):New{
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

local ITA_M38 = SMGInf:New(ITAInf):New{
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

local ITA_Breda30 = LMGInf:New(ITAInf):New{
	name				= "Breda 30 Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "Breda30",
		},
	},
}

local ITA_MG = HMGInf:New(ITAInf):New{
	name				= "Breda M37 Heavy Machinegun",
}

local ITA_MG_Sandbag = SandbagMG:New{
	name				= "Deployed Breda M37 Heavy Machinegun",
	buildpic			= "ITAMG.png",
	weapons = {
		[1] = { -- HMG
			name				= "BredaM37",
		},
	},
	customparams = {
		customanims			= "itahmg",
	},
}

local ITA_Sniper = SniperInf:New(ITAInf):New{
	name				= "Carcano Mod.91/38 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Mod91Sniper",
		},
	},
}

local ITA_SoloAT = ATRifleInf:New(ITAInf):New{
	name				= "Solothurn S-18/100",
	iconType			= "itasolo",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Solothurn",
		},
	},
}

local ITA_PanzerFaust = ATLauncherInf:New(ITAInf):New{
	name				= "Panzerfaust 60",
	weapons = {
		[1] = { -- AT Launcher
			name				= "Panzerfaust",
		},
	},
}

local ITA_Mortar = MedMortarInf:New(ITAInf):New{
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

local ITA_Observ = ObservInf:New(ITAInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "BerettaM1934",
		},
	},
}

-- Bersaglieri
local ITA_BersaglieriRifle = ITA_Rifle:Clone("ITARifle"):New(Bersaglieri):New{
	name				= "Carcano Mod.91/41 Rifle",
	description			= "Elite Infantry armed with new rifle and heavy grenades",
	buildpic			= "ITABersaglieriRifle.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- Rifle
			name				= "Mod91_41",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
			onlytargetcategory     = "INFANTRY SOFTVEH",
		},
		[3] = {
			name				= "bredamod42",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

local ITA_BersaglieriM38 = ITA_M38:Clone("ITAM38"):New(Bersaglieri):New{
	name				= "MAB38 Submachinegun",
	description			= "Elite Close-Quarters Assault Infantry armed with heavy grenade",
	buildpic			= "ITABersaglieriM38.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- SMG
			name				= "BerettaM38",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
			onlytargetcategory     = "INFANTRY SOFTVEH",
		},
		[3] = {
			name				= "L_type_grenade",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING SOFTVEH OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

local ITA_EliteSoloAT = ITA_SoloAT:Clone("ITASoloAT"):New(Bersaglieri):New{
	name				= "Scoped Solothurn S-18/100",
	description			= "Scoped Long Range Light Anti-Tank",
	iconType			= "itascopedsolo",
	buildpic			= "ITAeliteSoloAT.png",
	weapons = {
		[1] = { -- AT Launcher
			name				= "ScopedSolothurn",
		},
	},
}

-- Alpini
local ITA_AlpiniRifle = ITA_Rifle:Clone("ITARifle"):New(Alpini):New{
	name				= "Breda Mod. 1935 PG Rifle",
	description			= "Mountaineering Rifle Infantry armed with heavy stickgrenade",
	buildpic			= "ITAAlpiniRifle.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- Rifle
			name				= "Breda_35PG",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
			onlytargetcategory     = "INFANTRY SOFTVEH",
		},
		[3] = {
			name				= "L_type_grenade",
			onlyTargetCategory	= "BUILDING OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

local ITA_AlpiniFNAB43 = ITA_M38:Clone("ITAM38"):New(Alpini):New{
	name				= "FNAB43 Submachinegun",
	description			= "Mountaineering Close-Quarters Assault Infantry armed with heavy grenade",
	buildpic			= "itaalpinifnab43.png", -- have to overwrite Clone
	weapons = {
		[1] = { -- SMG
			name				= "fnab43",
		},
		[2] = { -- Grenade
			name				= "OTO_model35",
			onlytargetcategory     = "INFANTRY SOFTVEH",
		},
		[3] = {
			name				= "bredamod42",
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING OPENVEH HARDVEH SHIP DEPLOYED",
			mainDir				= [[0 0 1]],
		},
	},
}

local ITA_AlpiniObserv = ITA_Observ:Clone("ITAObserv"):New(Alpini):New{
	buildpic			= "ITAAlpiniObserv.png", -- have to overwrite Clone
}

local ITA_AlpiniMortar = ITA_Mortar:Clone("ITAMortar"):New(Alpini):New{
	buildpic			= "ITAAlpiniMortar.png", -- have to overwrite Clone
}

return lowerkeys({
	-- Regular Inf
	["ITAHQEngineer"] = ITA_HQEngineer,
	["ITAHQAIEngineer"] = ITA_HQEngineer:Clone("ITAHQEngineer"),
	["ITARifle"] = ITA_Rifle,
	["ITAM38"] = ITA_M38,
	["ITABreda30"] = ITA_Breda30,
	["ITAMG_DugIn"] = ITA_MG_Sandbag,
	["ITAMG"] = ITA_MG,
	["ITASniper"] = ITA_Sniper,
	["ITASoloAT"] = ITA_SoloAT,
	["ITAPanzerFaust"] = ITA_PanzerFaust,
	["ITAMortar"] = ITA_Mortar,
	["ITAObserv"] = ITA_Observ,
	-- Bersaglieri
	["ITABersaglieriRifle"] = ITA_BersaglieriRifle,
	["ITABersaglieriM38"] = ITA_BersaglieriM38,
	["ITAEliteSoloAT"] = ITA_EliteSoloAT,
	-- Alpini
	["ITAAlpiniRifle"] = ITA_AlpiniRifle,
	["ITAAlpiniFNAB43"] = ITA_AlpiniFNAB43,
	["ITAAlpiniObserv"] = ITA_AlpiniObserv,
	["ITAAlpiniMortar"] = ITA_AlpiniMortar,
})
