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
		pronespheremovemult = 0.4,
		wiki_parser                 = "infantry",  -- infantry.md template
		wiki_subclass_comments      = "",      -- To be override by inf classes
		wiki_comments               = "",      -- To be override by each unit
	},
}

-- Infantry able to capture units
local CapInfantry = Infantry:New{ -- don't want a conflict with weapon Rifle
	builder				= true,
	isBuilder			= true,
	buildDistance		= 128,
	canRestore			= false,
	canRepair			= false,
	canReclaim			= false,
	canResurrect		= false,
	canCapture			= true,
	workerTime			= 15,
	repairSpeed			= 0,
	reclaimSpeed		= 0,
	resurrectSpeed		= 0,
	captureSpeed		= 15,
	terraformSpeed		= 0,
	canAssist			= false,
	canSelfRepair		= false,

	customParams = {
		canclearmines		= false,
		flagcaprate			= 1,
	},
}


-- Basic Types
local RifleInf = CapInfantry:New{ -- don't want a conflict with weapon Rifle
	description			= "Long-range Rifle Infantry",
	iconType			= "rifle",
	
	customParams = {
		wiki_subclass_comments = [[Close-Quarters Assault Infantry and
Long-range Rifle Infantry are the most basic infantry units, ideal to setup your
front line, providing a line of sight to other longer-range guns. Rifle weapon
can just be used to shoot against another infantry units, or eventually to cause
tiny damage to deployed guns. On the other hand, grenades can be used to kill
several infantry units by a single shot, damage deployed guns and structures,
or even slightly damage armoured vehicles. Unfortunately, grenade strikes can
be only carried out in a dramatically short range.]],
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

local SMGInf = CapInfantry:New{
	description			= "Close-Quarters Assault Infantry",
	iconType			= "assault",
	
	customParams = {
		wiki_subclass_comments = [[Close-Quarters Assault Infantry and
Long-range Rifle Infantry are the most basic infantry units, ideal to setup your
front line, providing a line of sight to other longer-range guns. Conversely
to Rifle Infantry, Assault infantry are trained to combat in a short range,
significantly damaging infantry, deployed guns or structures with its deadly
combination of a short range sub-machinegun and grenades.]],
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
local ObservInf = Infantry:New{
	name				= "Scout",
	description			= "Reconnaisance Infantry",
	iconType			= "officer",
	buildCostMetal		= 50, -- TODO: needed?
	fireState			= 1,
	cloakCost			= 0,
	cloakCostMoving		= 0,
	minCloakDistance	= 160,

	customParams = {
		wiki_subclass_comments = [[This unit is not intended to can directly
cause casualties, but to provide line of sight to another longer range weapons
which may inflict significant damage from a safe position. This unit may sneak
into enemy lines, since it cannot be detected until enemy comes close to him.
When a good observation point is reached, this unit may use the binoculars to
spot an specific area (use attack command to do that). Take care, while using
the binoculars this unit is not invisible anymore. Don't try to use the unit as
cloacked scout, because it has a very short sight range.]],
	},

	weapons = {
		[1] = { -- Binocs
			name				= "Binocs",
		},
	},
}

local CrewInf = Infantry:New{
	name				= "Crew",
	objectName			= "<SIDE>/<NAME>.dae",
	description			= "Crew member",
	iconType			= "pistol",
	buildCostMetal		= 50, -- TODO: needed?

	customParams = {
		wiki_subclass_comments = [[A crew member that has scaped from a
compromised situation. Crew members are equiped just with a hand gun, which
make them of very little use in combat, although they still can use grenades,
so they can be of some help during infantry assaults.]],
	},

	weapons = {
		[1] = { -- Pistol
			maxAngleDif			= 170,
		},
		[2] = { -- Grenade
			maxAngleDif			= 170,
		},
	},
}

local LMGInf = Infantry:New{
	description			= "Light Infantry Fire Support",
	iconType			= "lightmg",
	buildCostMetal		= 75, -- TODO: needed?
	
	customParams = {
		wiki_subclass_comments = [[Machineguns are meant to cause a significant
number of enemy infantry casualties. Also, the enemy soldiers under machinegun
fire will be
[suppressed](https://gitlab.com/Spring1944/spring1944/wikis/inffear).
On the other hand, this unit is not able to damage structures or vehicles]],
	},

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
		wiki_subclass_comments = [[Machineguns are meant to cause a significant
number of enemy infantry casualties. Also, the enemy soldiers under machinegun
fire will be
[suppressed](https://gitlab.com/Spring1944/spring1944/wikis/inffear).
On the other hand, this unit is not able to damage structures or vehicles]],
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
		wiki_subclass_comments = [[Snipers are the nightmare of the infantry.
They are experts at camouflage, such that they cannot be seen unless enemy come
quite close to them, or during a short lapse of time after shooting the rifle.
On top of that, they can open fire from a long distance with a deadly
precision... A casualty per bullet!
On the other hand, this unit is not able to damage structures or vehicles]],
	},

	weapons = {
		[1] = { -- Rifle
			maxAngleDif			= 60,
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
		wiki_subclass_comments = [[Mortars are a long-range indirect fire
weapon, very valuable to support infantry in battle. Due to the long range, and
the indirect fire, they can shoot from a safe position, and due to the explosion
range, they can inflict a number of casualties among enemy infantry by a
single shot. This unit is also effective against deployed guns and structures.
It's a quite exprensive unit, with a painfully low performance in close-quarters
combat. Hence, If you lost your front line then you should consider retreating
your mortars to a safer position.

Watch out, mortars are ammo hungry! They can eventually drain your storages...]],
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
		wiki_subclass_comments = [[Its limited fire range make this unit quite
useless in general operations. However, when strategically placed, this units
may inflict huge damage to enemy groups, deployed guns or even structures.
It's not strange finding a couple of this guys guarding a hill top, a good way
to protect the spot against enemy infantry raids.]],
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
	maxVelocity			= 1.5,

	customParams = {
		wiki_subclass_comments = [[Is the enemy rushing your base with tanks?
well, a couple of this guys may appropriately welcome them. Due to the low fire
range and rate, Anti-Tank Infantry has a very low performance fighting enemy
soldiers. However, Anti-Tank Infantry is an excellent unit to ambush unprotected
enemy tanks. When the enemy tanks realise on their presence, it will be too
late!]],
	},

	weapons = {
		[1] = { -- AT Launcher
			maxAngleDif			= 170,
		},
	},	
}

local ATGrenadeInf = ATLauncherInf:New{
	description			= "Short Range Heavy Anti-Tank",

	customParams = {
		wiki_subclass_comments = [[Is the enemy rushing your base with tanks?
well, a couple of this guys may appropriately welcome them. Due to the low fire
range and rate, Anti-Tank Infantry has a very low performance fighting enemy
soldiers. However, Anti-Tank Infantry is an excellent unit to ambush unprotected
enemy tanks. When the enemy tanks realise on their presence, it will be too
late!]],
	},

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

	customParams = {
		wiki_subclass_comments = [[Conversely to the short range anti-tank
weapons, the Anti-Tank rifle is not meant to destroy enemy vehicles by a single
shot, but to slightly damaging them while shooting from a safe distance.
Moreover, a successfull hit of this gun has a chance to turn a vehicle
inoperative to still moving for a short lapse of time.
This kind of weapons can be useful in some contexts, but you should not rely on
them at the time of setting up your anti-tank defenses.]],
	},

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
	isBuilder				= true,
	buildDistance		= 128,
	canRestore			= true,
	canRepair			= true,
	canReclaim			= true,
	canResurrect		= false,
	terraformSpeed		= 300,
	workerTime			= 15,
	reclaimSpeed 		= 30,

	customParams = {
		canclearmines			= true,
		scriptAnimation			= "engineer",
		wiki_subclass_comments = [[Engineers are the basic building staff of
your army. They are not prepared to combat the enemy at all, so keep them away
from the first line.]],
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
		pronespheremovemult = 0.2,
		scriptAnimation = "infantrygun_anim",
		wiki_subclass_comments = [[This gun, towed by infantry, is an efficient
way to provide infantry support, becoming relatively cheap, with a long enough
range and destructive capabilities. The main drawback of this unit is the
extremelly low speed. However, this gun can be eventually towed by a supply
truck, in order to quickly deploy it in the battlefield.

Even though this gun may damage some light armoured vehicles, don't expect a
great performance against them.]],
	},
	weapons = {
		[1] = { -- Cannon
			maxAngleDif			= 30,
		},
	},
}

return {
	Infantry = Infantry,
	CapInfantry = CapInfantry,
	-- Basic Types
	RifleInf = RifleInf,
	SMGInf = SMGInf,
	-- Support & Specialists
	ObservInf = ObservInf,
	CrewInf = CrewInf,
	LMGInf = LMGInf,
	HMGInf = HMGInf,
	SniperInf = SniperInf,
	LightMortarInf = LightMortarInf,
	MedMortarInf = MedMortarInf,
	FlameInf = FlameInf,
	-- Anti-Tank
	ATLauncherInf = ATLauncherInf,
	ATGrenadeInf = ATGrenadeInf,
	ATRifleInf = ATRifleInf,
	-- Engineers
	EngineerInf = EngineerInf,
	-- Infantry Guns
	InfantryGun = InfantryGun,
}
