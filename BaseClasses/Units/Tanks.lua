-- Tanks ----
local Tank = Unit:New{ -- some overlap with Vehicle
	acceleration		= 0.051,
	brakeRate			= 0.15,
	canMove				= true,
	category			= "MINETRIGGER HARDVEH",
	explodeAs			= "Vehicle_Explosion_Med",
	footprintX			= 3,
	footprintZ			= 3,
	leaveTracks			= true,
	movementClass		= "TANK_Medium",
	noChaseCategory		= "FLAG AIR MINE",
	script				= "Vehicle.lua",
	seismicSignature	= 1,
	trackType			= "Stdtank",
	turnRate			= 75,
	
	customParams = {
		blockfear			= true,
		soundcategory		= "<SIDE>/Tank",
		hasturnbutton		= true,
		reversemult			= 0.5,
		weapontoggle		= "priorityAPHE",
		turretturnspeed		= 16,	-- default
		immobilizationresistance = 0.75,	-- rather high by default
		wiki_parser                 = "vehicle",  -- vehicles.md template
		wiki_subclass_comments      = "",      -- To be override by inf classes
		wiki_comments               = "",      -- To be override by each unit
	},
}


-- Light Tank
local LightTank = Tank:New{
	description 		= "Light Tank",
	iconType			= "lighttank",
	movementClass		= "TANK_Light",
	trackType			= "T60-70-SU76",
	turnRate			= 150,

	customParams = {
		damageGroup		= "lightTanks",
		turretturnspeed		= 36,	-- faster than default
		wiki_subclass_comments = [[This a light tank, that is, a fast armoured
vehicle with a good performance in close-quarters combat. This tank is not rival
for medium or heavy tanks, don't even try to engage them. However, its
velocity and relatively good weaponry make it an excellent unit to overrun and
surround the enemy lines, to rush over the enemy base, or even to apply a hit &
run strategy.]],
	},
}

-- Tankette
local Tankette = LightTank:New{
	description 		= "Tankette",
	explodeAs			= "Vehicle_Explosion_Sm",
	footprintX			= 2,
	footprintZ			= 2,
}

-- Medium Tank
local MediumTank = Tank:New{
	description 		= "Medium Tank",
	iconType			= "medtank",
	turnRate			= 125,

	customParams = {
		damageGroup		= "mediumTanks",
		wiki_subclass_comments = [[This is a medium tank, the king of the
battlefield. Medium tanks have a great compromise between cost and performance,
with a good armour to survive several hits, and a good gun to cause severe
damage.]],
	},
}

-- Heavy Tank
local HeavyTank = Tank:New{
	acceleration		= 0.043,
	brakeRate			= 0.105,
	description 		= "Heavy Tank",
	explodeAs			= "Vehicle_Explosion_Large",
	iconType			= "heavytank",
	movementClass		= "TANK_Heavy",
	turnRate			= 100,

	customParams = {
		damageGroup			= "heavyTanks",
		soundcategory		= "<SIDE>/Tank/Heavy",
		wiki_subclass_comments = [[This is a heavy tank, an extremelly armoured
tank that can be hardly penetrated by the biggest weapons of the game.]],
	}
}

-- Assault Gun
local AssaultGun = Def:New{ -- not a full class (role/mixin)
	description 		= "Self-Propelled Assault Gun",
	iconType			= "selfprop",
	turnRate			= 110,
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP",
		turretturnspeed		= 24,
		wiki_subclass_comments = [[This is an assault gun, a turret-less tank.
It's quite evident that the lack of a turret is a drawback of this tank, but it
is compensated by the large front armour. In a static front line, this weapons
may performs nice.]],
	}
}

-- Tank Destroyer
local TankDestroyer = AssaultGun:New{
	description 		= "Tank Destroyer",
	customParams = {
		soundcategory		= "<SIDE>/Tank/SP/TD",
		weapontoggle		= false,
		wiki_subclass_comments = [[This is a tank destroyer, a special kind of
tank specifically designed to hunt enemy vehicles, with its armour-piercing
weapon.]],
	}
}

-- SP Arty Tank
local SPArty = Def:New{ -- not a full class (role/mixin)
	description 		= "Self-Propelled Howitzer",
	iconType			= "sparty",
	turnRate			= 95,
	customParams = {
		canareaattack		= true,
		soundcategory		= "<SIDE>/Tank/SP",
		weapontoggle		= false,
		wiki_subclass_comments = [[This is a self-propelled artillery.
Self-prop. guns are much more expensive than towed ones, however the increase
of mobility can be quite convenient in some contexts, allowing it to run away
to avoid counter artillery fire, or even to get close to the enemy base to
maximize the accuracy.]],
	}
}

local OpenTopped = Def:New{ --not a full class (role/mixin)
	category			= "MINETRIGGER OPENVEH",
	customParams = {
		damageGroup		= "lightTanks",
	},
}

return {
	Tank = Tank,
	Tankette = Tankette,
	LightTank = LightTank,
	MediumTank = MediumTank,
	HeavyTank = HeavyTank,
	AssaultGun = AssaultGun,
	TankDestroyer = TankDestroyer,
	SPArty = SPArty,
	OpenTopped = OpenTopped,
}
