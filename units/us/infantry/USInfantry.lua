local USInf = {
	maxDamageMul		= 1.0,
	customParams = {

	},
}

local USPara = {
	maxDamageMul		= 1.4,
}

local US_HQEngineer = EngineerInf:New(USInf):New{
	name				= "Field Engineer",
}

local US_Rifle = RifleInf:New(USInf):New{
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

local US_Thompson = SMGInf:New(USInf):New{
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

local US_BAR = RifleInf:New(USInf):New{
	name				= "BAR M1918A2 Light Machinegun",
	description			= "Long Range Assault/Light Fire Support Unit",
	iconType			= "bar",
	weapons = {
		[1] = { -- LMG
			name				= "BAR",
		},
		[2] = { -- Grenade
			name				= "Mk2",
		},
	},
}

local US_MG = LMGInf:New(USInf):New{
	name				= "Browning M1919A4 Machinegun",
	weapons = {
		[1] = { -- LMG
			name				= "M1919A4Browning",
		},
	},
}

local US_MG_Sandbag = SandbagMG:New{
	name				= "Browning M1919A4 Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "m1919a4browning_deployed",
			maxAngleDif			= 90,
		},
	},
}

local US_Sniper = SniperInf:New(USInf):New{
	name				= "M1903A4 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "M1903Springfield",
		},
	},
}

local US_Bazooka = ATLauncherInf:New(USInf):New{
	name				= "M9A1 Bazooka",
	weapons = {
		[1] = { -- AT Launcher
			name				= "M9A1Bazooka",
		},
	},
}

local US_Flamethrower = FlameInf:New(USInf):New{
	name				= "M2 Flamethrower",
	weapons = {
		[1] = { -- Flamethrower
			name				= "M2Flamethrower",
		},
	},	
}

local US_Mortar = MedMortarInf:New(USInf):New{
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

local US_Observ = ObservInf:New(USInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "m1911a1colt",
		},
	},
}

local US_Crew = CrewInf:New(USInf):New{
	weapons = {
		[1] = { -- Pistol
			name				= "m1911a1colt",
		},
		[2] = { -- Grenade
			name				= "Mk2",
		},
	},
}

local US_Paratrooper = Infantry:New{
	script = "<NAME>.cob"
}

return lowerkeys({
	-- Regular Inf
	["USHQEngineer"] = US_HQEngineer,
	["USRifle"] = US_Rifle,
	["USThompson"] = US_Thompson,
	["USBAR"] = US_BAR,
	["USMG"] = US_MG,
	["USMG_Sandbag"] = US_MG_Sandbag,
	["USSniper"] = US_Sniper,
	["USBazooka"] = US_Bazooka,
	["USMortar"] = US_Mortar,
	["USFlamethrower"] = US_Flamethrower,
	["USObserv"] = US_Observ,
	["USCrew"] = US_Crew,
	-- Paratroopers
	["USParaRifle"] = US_Rifle:New(USPara),
	["USParaThompson"] = US_Thompson:New(USPara),
	["USParaBAR"] = US_BAR:New(USPara),
	["USParaMG"] = US_MG:New(USPara),
	["USParaMG_Sandbag"] = US_MG_Sandbag:New(USPara),
	["USParaBazooka"] = US_Bazooka:New(USPara),
	["USParatrooper"] = US_Paratrooper,
})
