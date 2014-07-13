-- Our shared funcs
local function printTable (input)
	for k,v in pairs(input) do
		Spring.Echo(k, v)
		if type(v) == "table" then
			printTable(v)
		end
	end
end

local function inherit (c, p, concatNames)
	for k,v in pairs(p) do 
		if type(k) == "string" then
			k:lower() -- really we need to run lowerkeys() on both c and p
		end
		if type(v) == "table" then
			if c[k] == nil then c[k] = {} end
			inherit(c[k], v)
		else
			if concatNames and k == "name" then 
				c[k] = v .. " " .. (c[k] or "")
			else
				if c[k] == nil then c[k] = v end
			end
		end
	end
end

local Unit = {
	showNanoFrame		= false,
}
function Unit:New(newAttribs, concatName)
	local newClass = {}
	inherit(newClass, newAttribs)
	inherit(newClass, self, concatName)
	return newClass
end

local Weapon = {}
function Weapon:New(newAttribs, concatName)
	local newClass = {}
	inherit(newClass, newAttribs)
	inherit(newClass, self, concatName)
	return newClass
end
---------------------------------------------------------------------------------------------
-- Base Classes
---------------------------------------------------------------------------------------------

-- Boat Mother ----
local BoatMother = Unit:New{
	airSightDistance	= 1500,
	canMove				= true,
	category 			= "SHIP MINETRIGGER",
	collisionVolumeType	= "box",
	explodeAs			= "Vehicle_Explosion_Sm",
	floater				= true,
	footprintX			= 4,
	footprintZ 			= 4,
	iconType			= "gunboat",
	noChaseCategory		= "FLAG AIR MINE",
	script				= "BoatMother.lua",
	selfDestructAs		= "Vehicle_Explosion_Sm",
	sightDistance		= 840,
	turninplace			= false,
	usePieceCollisionVolumes	= true,
		
	-- Transport tags
	transportSize		= 1, -- assumes footprint of BoatChild == 1
	isFirePlatform 		= true,

	customparams = {
		dontCount			= 1,
		hasturnbutton		= 1,
		mother				= true,
	}
}

local BoatChild = Unit:New{
	airSightDistance	= 1500,
	canMove				= false,
	cantBeTransported	= false,
	canSelfDestruct 	= false,
	floater				= true, -- make them behave ala ships wrt sensors
	category 			= "SHIP MINETRIGGER TURRET DEPLOYED",
	footprintX			= 1,
	footprintZ 			= 1,
	iconType			= "turret",
	idleAutoHeal		= 1,
	mass				= 10,
	maxDamage			= 1000,
	maxVelocity			= 1,
	movementClass		= "KBOT_Infantry", -- needed!
	noChaseCategory		= "FLAG AIR MINE",
	script				= "BoatChild.lua",
	sightDistance		= 840,
	
	customparams = {
		child				= true,
		feartarget			= true,
		fearlimit			= 50, -- default to double inf, open mounts should be 25
	}
}

---------------------------------------------------------------------------------------------
-- This is where the magic happens
local sharedEnv = {
	Weapon = Weapon,
	Unit = Unit,
	BoatMother = BoatMother,
	BoatChild = BoatChild,
	printTable = printTable,
}
local sharedEnvMT = nil


-- override setmetatable to expose our shared functions to all def files
local setmetatable_orig = setmetatable
function setmetatable(t, mt)
	if type(mt.__index) == "table" then
		if (mt.__index.lowerkeys) then
			if (not sharedEnvMT) then
				sharedEnvMT = setmetatable_orig(sharedEnv, {
					__index     = mt.__index,
					__newindex  = function() error('Attempt to write to system') end,
					__metatable = function() error('Attempt to access system metatable') end
				})
				--Spring.Echo("foo", type(sharedEnv), type(sharedEnvMT))
			end
			local x = setmetatable_orig(t, { __index = sharedEnvMT })
			--Spring.Echo("bar", x.SharedDefFunc)
			return x
		end
	end
	return setmetatable_orig(t, mt)
end