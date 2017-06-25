local GBRInf = {
	maxDamageMul		= 1.4,
	customParams = {
		normaltex			= "",
	},
}

local GBR_HQEngineer = EngineerInf:New(GBRInf):New{
	name				= "Sapper",
}

local GBR_Rifle = RifleInf:New(GBRInf):New{
	name				= "SMLE No.4 Mk I Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "Enfield",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

local GBR_STEN = SMGInf:New(GBRInf):New{
	name				= "STEN Mk II Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "STEN",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

local GBR_BREN = LMGInf:New(GBRInf):New{
	name				= "BREN Mk II Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "Bren",
		},
	},
}

local GBR_Vickers = HMGInf:New(GBRInf):New{
	name				= "Vickers Mk I Heavy Machinegun",
}

local GBR_Vickers_Sandbag = SandbagMG:New{
	name				= "Deployed Vickers Mk I Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "Vickers",
		},
	},
}

local GBR_Sniper = SniperInf:New(GBRInf):New{
	name				= "SMLE No.4 Mk I (T) Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Enfield_T",
		},
	},
}

local GBR_PIAT = ATLauncherInf:New(GBRInf):New{
	name				= "PIAT",
	weapons = {
		[1] = { -- AT Launcher
			name				= "PIAT",
		},
	},
}

local GBR_3InMortar = MedMortarInf:New(GBRInf):New{
	name				= [[ML 3" Mortar Mk II]],
	weapons = {
		[1] = { -- HE
			name				= "ML3inMortar",
		},
		[2] = { -- Smoke
			name				= "ML3inMortarSmoke",
		},
	},
}

local GBR_Observ = ObservInf:New(GBRInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "Webley",
		},
	},
}

-- Still inheriting GBRInf even though I'm overriding the maxDamageMul,
-- so if anyone adds something there it'll change commandos as well.
local GBR_Commando = SMGInf:New(GBRInf):New{
	name				= "Commando",
	description			= "Demolitions and Infiltration Infantry",
	canManualFire		= true,
	iconType			= "commando",
	maxVelocity			= 1.8,
	
	buildDistance		= 50,
	builder				= true,
	workerTime			= 150,
	canAssist			= false,
	canReclaim			= false,
	canRepair			= false,
	cloakCost			= 0,
	cloakCostMoving		= 0,
	maxDamageMul		= 2.8,
	minCloakDistance	= 100,
	customParams		= {
		maxammo				= 2,
		weaponcost			= 50,
		weaponswithammo		= 0,	-- do not remove, needed to prevent sten and grenade from using ammo!
		flagcaprate			= 0,
	},
	weapons = {
		[1] = { -- SMG
			name				= "SilencedSTEN",
		},
		[2] = { -- Smoke Nade
			name				= "No77",
		},
	},
}

return lowerkeys({
	-- Regular Inf
	["GBRHQEngineer"] = GBR_HQEngineer,
	["GBRHQAIEngineer"] = GBR_HQEngineer:Clone("GBRHQEngineer"),
	["GBRRifle"] = GBR_Rifle,
	["GBRSTEN"] = GBR_STEN,
	["GBRBREN"] = GBR_BREN,
	["GBRVickers_Sandbag"] = GBR_Vickers_Sandbag,
	["GBRVickers"] = GBR_Vickers,
	["GBRSniper"] = GBR_Sniper,
	["GBRPIAT"] = GBR_PIAT,
	["GBR3InMortar"] = GBR_3InMortar,
	["GBRObserv"] = GBR_Observ,
	-- Glider Inf
	["GBRParaRifle"] = GBR_Rifle:New{},
	["GBRParaSTEN"] = GBR_STEN:New{},
	["GBRParaBREN"] = GBR_BREN:New{},
	["GBRParaPIAT"] = GBR_PIAT:New{},
	["GBRPara3InMortar"] = GBR_3InMortar:New{},
	["GBRParaObserv"] = GBR_Observ:New{},
	-- Commandos
	["GBRCommando"] = GBR_Commando,
	["GBRCommandoC"] = GBR_Commando:Clone("GBRCommando")
})
