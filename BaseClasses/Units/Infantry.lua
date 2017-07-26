-- Infantry ----
local Infantry = Unit:New{
	airSightDistance	= 2000,
	acceleration		= 0.375,
	brakeRate			= 0.9,
	buildCostMetal		= 65, -- used only for power XP calcs
	canMove				= true,
	category			= "INFANTRY MINETRIGGER",
	corpse				= "<SIDE>soldier_dead",
	damageModifier		= 0.265,
	flankingBonusMax	= 1.5,
	flankingBonusMin	= 0.675,
	flankingBonusMobilityAdd	= 0.01,
	flankingBonusMode	= 1,
	footprintX			= 1,
	footprintZ			= 1,
	mass				= 50,
	maxDamage			= 100, -- default only, <SIDE>Infantry.lua should overwrite
	maxVelocity			= 1.6,
	movementClass		= "KBOT_Infantry", -- TODO: --KBOT
	noChaseCategory		= "FLAG AIR MINE",
	radardistance		= 650,
	repairable			= false,
	script				= "Infantry.lua",
	seismicDistance		= 1400,
	seismicSignature	= 0, -- required, not default
	sightDistance		= 650,
	stealth				= true,
	turnRate			= 1010,
	upright				= true,
	
	customParams = {
		damageGroup			= "infantry",
		feartarget			= true,
		soundcategory 		= "<SIDE>/Infantry",
	},
}

-- Basic Types
local RifleInf = Infantry:New{ -- don't want a conflict with weapon Rifle
	description			= "Long-range Rifle Infantry",
	iconType			= "rifle",
	
	customParams = {
		flagcaprate			= 1,
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
		},
		[2] = { -- Grenade
			maxAngleDif			= 170,
		},
	},
}

local SMGInf = Infantry:New{
	description			= "Close-Quarters Assault Infantry",
	iconType			= "assault",
	
	customParams = {
		flagcaprate			= 1,
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
		},
		[2] = { -- Grenade
			maxAngleDif			= 170,
		},
	},
}

-- Support & Specialists
local LMGInf = Infantry:New{
	description			= "Light Infantry Fire Support",
	iconType			= "lightmg",
	buildCostMetal		= 75, -- TODO: needed?
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
		},
	},
}

local HMGInf = Infantry:New{
	description			= "Heavy Machinegun",
	acceleration		= 0.2,
	iconType			= "lightmg",
	buildCostMetal		= 150, -- TODO: needed?
	mass				= 75,
	maxVelocity			= 0.8,
	movementClass		= "KBOT_Gun", -- TODO: --KBOT
	turnRate			= 420,
	customparams = {
		scriptanimation		= "mg",
	},
}

local SniperInf = Infantry:New{
	description			= "Sniper",
	iconType			= "sniper",
	buildCostMetal		= 300, -- TODO: needed?
	
	cloakCost			= 0,
	cloakCostMoving		= 0,
	decloakOnFire		= true,
	minCloakDistance	= 220,
	
	customParams = {
		soundcategory 		= "<SIDE>/Infantry/Sniper",
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 60,
		},
	},
}

local ObservInf = Infantry:New{
	name				= "Scout",
	description			= "Reconnaisance Infantry",
	iconType			= "officer",
	buildCostMetal		= 50, -- TODO: needed?
	fireState			= 1,
	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 160,
	weapons = {
		[1] = { -- Binocs
			name				= "Binocs",
		},
	},
}


local MedMortarInf = Infantry:New{
	description			= "Heavy Infantry Fire Support",
	highTrajectory		= 1,
	iconType			= "mortar",
	acceleration		= 0.2,
	buildCostMetal		= 300, -- TODO: needed?
	maxDamage			= 200, -- default to be overwritten
	maxVelocity			= 1.25,

	customParams = {
		canareaattack		= true,
		maxammo				= 10,
		weapontoggle 		= "smoke",
	},
}

local LightMortarInf = MedMortarInf:New{
	description			= "Light Infantry Mortar",
	hightrajectory		= false,
	maxVelocity			= 1.45,
}
	
local FlameInf = Infantry:New{
	description			= "Close Range Heavy Assault Infantry",
	iconType			= "flame",
	acceleration		= 0.2,
	buildCostMetal		= 60, -- TODO: needed?
	explodeAs			= "Small_Explosion",
	maxVelocity			= 1,

	customParams = {
		maxammo				= 5,
	},

	weapons = {
		[1] = { -- Flamethrower
			maxAngleDif			= 170,
		},
	},	
}

-- Anti-Tank
local ATLauncherInf = Infantry:New{
	description			= "Anti-Tank Infantry",
	iconType			= "antitank",
	weapons = {
		[1] = { -- AT Launcher
			maxAngleDif			= 170,
		},
	},	
}

local ATGrenadeInf = ATLauncherInf:New{
	description			= "Short Range Heavy Anti-Tank",
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
		},
		[2] = { -- AT Launcher
			maxAngleDif			= 270,
		},
	},
}

local ATRifleInf = Infantry:New{
	description			= "Long Range Light Anti-Tank",
	icontype			= "rusptrd", -- TODO: atm italian solothurn has its own icon, consolidate
	
	weapons = {
		[1] = { -- AT Launcher
			maxAngleDif			= 170,
		},
	},	
}

-- Engineers --
local EngineerInf = Infantry:New{
	description			= "Basic Engineer",
	buildCostMetal		= 260,
	category			= "INFANTRY", -- no MINETRIGGER
	iconType			= "engineer",
	builder				= true,
	buildDistance		= 128,
	terraformSpeed		= 300,
	workerTime			= 15,
	reclaimSpeed 		= 30,
	
	customParams = {
		canclearmines			= true,
		scriptAnimation			= "engineer",
	},
}

-- Infantry Guns --
local InfantryGun = Infantry:New{
	description			= "Infantry Support Cannon",
	acceleration		= 0.2,
	brakeRate			= 0.6,
	corpse				= "<NAME>_Destroyed",
	explodeAs			= "Tiny_Explosion",
	iconType			= "artillery",
	idleAutoHeal		= 2,
	idleTime			= 2000,
	mass				= 100,
	maxDamage			= 300,
	maxVelocity			= 0.75,
	movementClass		= "KBOT_Gun", -- TODO: --KBOT
	script				= "InfantryGun.lua",
	turnRate			= 120,
	
	customParams = {
		hasturnbutton		= true,
		maxammo				= 4,
		infgun				= true,
		scriptAnimation = "infantrygun_anim",
	},
	weapons = {
		[1] = { -- Cannon
			maxAngleDif			= 30,
		},
	},
}

return {
	Infantry = Infantry,
	-- Basic Types
	RifleInf = RifleInf,
	SMGInf = SMGInf,
	-- Support & Specialists
	LMGInf = LMGInf,
	HMGInf = HMGInf,
	SniperInf = SniperInf,
	LightMortarInf = LightMortarInf,
	MedMortarInf = MedMortarInf,
	FlameInf = FlameInf,
	ObservInf = ObservInf,
	-- Anti-Tank
	ATLauncherInf = ATLauncherInf,
	ATGrenadeInf = ATGrenadeInf,
	ATRifleInf = ATRifleInf,
	-- Engineers
	EngineerInf = EngineerInf,
	-- Infantry Guns
	InfantryGun = InfantryGun,
}
