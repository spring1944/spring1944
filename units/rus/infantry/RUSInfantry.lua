local RUSInf = {
	maxDamageMul		= 0.65,
	customParams = {
		flagCapRate		= 0.085,

	},
}
local Partisan = {
	maxDamageMul		= 0.40,

	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 225,

	corpse			= "ruspartisan_dead",
}

local RUS_Engineer = EngineerInf:New(RUSInf):New{
	name				= "Engineer",
}

local RUS_Commissar = EngineerInf:New(RUSInf):New{
	name				= "Engineer",
	description			= "Political Commander",
	energyStorage		= 0.01, -- TODO: needed?
	
	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 250,

    iconType            = "commissar",
	
	customParams = {
		blockfear			= true,
		flagCapRate			= 3.125,
	},
}

local RUS_Rifle = RifleInf:New(RUSInf):New{
	name				= "Mosin-Nagant M91/30 Rifle",
	weapons = {
		[1] = { -- Rifle
			name				= "MosinNagant",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

local RUS_PPSh = SMGInf:New(RUSInf):New{
	name				= "PPSh 41 Submachinegun",
	weapons = {
		[1] = { -- SMG
			name				= "PPSh",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

local RUS_DP = LMGInf:New(RUSInf):New{
	name				= "DP 28 Light Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "DP",
		},
	},
}

local RUS_Maxim = HMGInf:New(RUSInf):New{
	name				= "Maxim PM 1910 Heavy Machinegun",
	buildpic			= "RUSSandbagMG.png",
	customparams = {
		scriptanimation		= "wheeled",
	},
}

local RUS_Maxim_Sandbag = SandbagMG:New{
	name				= "Deployed Maxim PM 1910 Heavy Machinegun",
	buildpic			= "RUSSandbagMG.png",
	weapons = {
		[1] = { -- HMG
			name				= "Maxim",
		},
	},
}

local RUS_Sniper = SniperInf:New(RUSInf):New{
	name				= "Mosin-Nagant M91/30 PU Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "MosinNagantPU",
		},
	},
	customparams = {
		killvoicecategory	= "RUS/Infantry/Sniper/RUS_SNIPER_KILL",
		killvoicephasecount	= 3,
	},
}

local RUS_PTRD = ATRifleInf:New(RUSInf):New{
	name				= "PTRD",
	weapons = {
		[1] = { -- AT Rifle
			name				= "PTRD",
		},
	},
}

local RUS_RPG43 = ATGrenadeInf:New(RUSInf):New{
	name				= "RPG43",
	weapons = {
		[1] = { -- SMG
			name				= "PPSh",
		},
		[2] = { -- AT Grenade
			name				= "RPG43",
		},
	},
}

local RUS_Mortar = MedMortarInf:New(RUSInf):New{
	name				= "M1937 Mortar",
	weapons = {
		[1] = { -- HE
			name				= "M1937_Mortar",
		},
		[2] = { -- Smoke
			name				= "M1937_MortarSmoke",
		},
	},
}

local RUS_Observ = ObservInf:New(RUSInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "TT33",
		},
	},
}

-- Naval Inf
local RUS_NI_Rifle = RifleInf:New(RUSInf):New{
	name				= "SVT-40 Rifle",
	description			= "Naval Infantry Rifleman",
	maxDamageMul		= 1.05,
	weapons = {
		[1] = { -- Rifle
			name				= "SVT",
		},
		[2] = { -- Grenade
			name				= "No69",
		},
	},
}

-- Partisans
local RUS_PartisanRifle = RifleInf:New(Partisan):New{
	name				= "Mosin Nagant M91/30 Partisan",
	description			= "Very Light Defensive Ambusher",
	
	customParams = {
		flagCapRate			= 0.005,
		weapontoggle		= "ambush",
	},
	
	weapons = {
		[1] = { -- Rifle
			name				= "MosinNagant",
		},
		[2] = { -- Grenade
			name				= "Molotov",
		},
	},
}

return lowerkeys({
	-- Regular Inf
	["RUSEngineer"] = RUS_Engineer,
	["RUSCommissar"] = RUS_Commissar,
	["RUSAICommissar"] = RUS_Commissar:Clone("RUSCommissar"),
	["RUSRifle"] = RUS_Rifle,
	["RUSPPSh"] = RUS_PPSh,
	["RUSDP"] = RUS_DP,
	["RUSMaxim_Sandbag"] = RUS_Maxim_Sandbag,
	["RUSMaxim"] = RUS_Maxim,
	["RUSSniper"] = RUS_Sniper,
	["RUSPTRD"] = RUS_PTRD,
	["RUSRPG43"] = RUS_RPG43,
	["RUSMortar"] = RUS_Mortar,
	["RUSObserv"] = RUS_Observ,
	-- Naval Inf
	["RUS_NI_Rifle"] = RUS_NI_Rifle,
	-- Partisans
	["RUSPartisanRifle"] = RUS_PartisanRifle,
})
