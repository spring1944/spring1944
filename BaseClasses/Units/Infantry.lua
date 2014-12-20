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
	seismicDistance		= 1400,
	seismicSignature	= 0, -- required, not default
	sightDistance		= 650,
	stealth				= true,
	turnRate			= 1010,
	upright				= true,
	
	customParams = {
		feartarget			= true,
		soundcategory 		= "<SIDE>/Infantry",
	},
}

-- Basic Types
local RifleInf = Infantry:New{ -- don't want a conflict with weapon Rifle
	description			= "Long-range Rifle Infantry",
	iconType			= "rifle",
	script				= "GBRRifle.cob",
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:RIFLE_MUZZLEFLASH",
		},
	},
	customParams = {
		flagcaprate			= 1,
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
		},
		[2] = { -- Grenade
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
}

local SMGInf = Infantry:New{
	description			= "Close-Quarters Assault Infantry",
	iconType			= "assault",
	script				= "GBRSTEN.cob",
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:SMG_MUZZLEFLASH",
		},
	},
	customParams = {
		flagcaprate			= 1,
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
		},
		[2] = { -- Grenade
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
}

-- Support & Specialists
local LMGInf = Infantry:New{
	description			= "Light Infantry Fire Support",
	iconType			= "lightmg",
	buildCostMetal		= 200, -- TODO: needed?
	script				= "InfantryMG.cob",
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[7] = "custom:MG_SHELLCASINGS",
			[8] = "custom:SMG_MUZZLEFLASH",
		},
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
			onlyTargetCategory	= "INFANTRY SOFTVEH DEPLOYED",
		},
		[2] = { -- Tracer
			name				= "Small_Tracer",
		},
	},
}

local HMGInf = Infantry:New{
	description			= "Heavy Machinegun",
	acceleration		= 0.2,
	iconType			= "lightmg",
	buildCostMetal		= 700, -- TODO: needed?
	mass				= 75,
	maxVelocity			= 0.8,
	movementClass		= "KBOT_Gun", -- TODO: --KBOT
	turnRate			= 420,
}

local SniperInf = Infantry:New{
	description			= "Sniper",
	iconType			= "sniper",
	buildCostMetal		= 300, -- TODO: needed?
	
	cloakCost			= 0,
	cloakCostMoving		= 0,
	decloakOnFire		= true,
	minCloakDistance	= 220,
	
	script				= "GBRSniper.cob",
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:RIFLE_MUZZLEFLASH",
		},
	},
	
	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 170,
			onlyTargetCategory	= "INFANTRY DEPLOYED",
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
	script				= "GBRObserv.cob",
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:PISTOL_MUZZLEFLASH",
		},
	},
	
	weapons = {
		[1] = { -- Binocs
			name				= "Binocs",
			onlyTargetCategory	= "NONE",
		},
		[2] = { -- Pistol
			onlyTargetCategory	= "OPENVEH INFANTRY SOFTVEH DEPLOYED",
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
	script				= "GBR3InMortar.cob",
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:MORTAR_MUZZLEFLASH",
		},
	},
	customParams = {
		canareaattack		= true,
		canfiresmoke		= true,
		maxammo				= 10,
		weaponcost			= 15, -- TODO: make this a weapon tag
		weaponswithammo		= 2, -- TODO: then this can be auto-detected
	},
	weapons = {
		[1] = { -- Mortar HE
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[2] = { -- Mortar Smoke
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
}

local FlameInf = Infantry:New{
	description			= "Close Range Heavy Assault Infantry",
	iconType			= "flame",
	acceleration		= 0.2,
	buildCostMetal		= 300, -- TODO: needed?
	explodeAs			= "Small_Explosion",
	maxVelocity			= 1,
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:SMG_MUZZLEFLASH",
		},
	},
	customParams = {
		maxammo				= 5,
		weaponcost			= 4, -- TODO: make this a weapon tag
		weaponswithammo		= 1, -- TODO: then this can be auto-detected
	},
	weapons = {
		[1] = { -- Flamethrower
			maxAngleDif			= 170,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},	
}

-- Anti-Tank
local ATLauncherInf = Infantry:New{
	description			= "Anti-Tank Infantry",
	iconType			= "antitank",
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
		},
	},
	weapons = {
		[1] = { -- AT Launcher
			maxAngleDif			= 170,
			badTargetCategory	= "BUILDING FLAG INFANTRY SOFTVEH OPENVEH DEPLOYED",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},	
}

local ATGrenadeInf = ATLauncherInf:New{
	description			= "Short Range Heavy Anti-Tank",
}

local ATRifleInf = ATLauncherInf:New{
	description			= "Long Range Light Anti-Tank",
	icontype			= "rusptrd", -- TODO: atm italian solothurn has its own icon, consolidate
	script				= "RUSPTRD.cob",
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
	script				= "GBRHQEngineer.cob",
	
	customParams = {
		canclearmines			= true,
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
	script				= "GERLeiG18.cob",
	turnRate			= 120,
	
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[9] = "custom:MEDIUM_MUZZLEFLASH",
			[10] = "custom:MEDIUM_MUZZLEDUST",
			[11] = "custom:MuzzleBrakeSmoke",
		}
	},
	customParams = {
		hasturnbutton		= true,
		maxammo				= 4,
		weaponcost			= 12,
		weaponswithammo		= 1,
		infgun				= true,
	},
	weapons = {
		[1] = { -- Cannon
			maxAngleDif			= 30,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
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