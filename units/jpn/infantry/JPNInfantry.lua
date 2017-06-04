local JPNInf = {
	maxDamageMul		= 0.94,
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
	name				= "Type 99 Light Machinegun",
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
	buildpic			= "JPNType92HMG.png",
	weapons = {
		[1] = { -- HMG
			name				= "Type92MG",
		},
	},
	customparams = {
		customanims			= "jpnhmg",
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
	acceleration		= 0.5,
	weapons = {
		[1] = { -- SMG
			name				= "Type100SMG",
		},
		[2] = { -- AT Grenade
			name				= "Type3AT",
		},
	},
}

local JPN_Type4AT = ATLauncherInf:New(JPNInf):New{
	name				= "Type 4 AT Rocket Launcher",
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

local JPN_Type4Mortar_Mobile = MedMortarInf:New(JPNInf):New{
	name				= "Type 4 200mm Mortar",
	buildCostMetal		= 1500,
	iconType			= "artillery",

	customParams = {
		canareaattack		= false,
		scriptanimation		= "mg",
		maxammo				= 1,
	},
}

local JPN_Type4Mortar_Stationary = Deployed:New{
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

return lowerkeys({
	-- Regular Inf
	["JPNHQEngineer"] = JPN_HQEngineer,
	["JPNHQAIEngineer"] = JPN_HQEngineer:Clone("JPNHQEngineer"),
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
	["JPNType4Mortar_Mobile"] = JPN_Type4Mortar_Mobile,
	["JPNType4Mortar_Stationary"] = JPN_Type4Mortar_Stationary,
})
