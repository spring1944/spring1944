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

-- Make sides available to all def files
local sideData = VFS.Include("gamedata/sidedata.lua", VFS.ZIP)
local Sides = {}
for sideNum, data in pairs(sideData) do
	if sideNum > 1 then -- ignore Random/GM
		Sides[sideNum] = data.name:lower()
	end
end

-- Root Classes

Unit = {
	showNanoFrame		= false,
	objectName				= "<SIDE>/<NAME>.s3o",
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
-- This is where the magic happens
local sharedEnv = {
	Sides = Sides,
	Weapon = Weapon,
	Unit = Unit,
	printTable = printTable,
}

-- Include Base Classes from BaseClasses/*
local unitBaseClasses = VFS.DirList("baseclasses/units")
local weaponBaseClasses = VFS.DirList("baseclasses/weapons")
local featureBaseClasses = VFS.DirList("baseclasses/features")

local allBaseClasses = {unitBaseClasses, weaponBaseClasses, featureBaseClasses}

for _, baseClasses in pairs(allBaseClasses) do
	for _, file in pairs(baseClasses) do
		newClasses = VFS.Include(file, VFS.ZIP)
		for className, class in pairs(newClasses) do
			sharedEnv[className] = class
		end
	end
end

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