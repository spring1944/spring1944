VFS.Include('gamedata/VFSUtils.lua') -- for RecursiveFileSearch()
lowerkeys = VFS.Include('gamedata/system.lua').lowerkeys -- for lowerkeys()

-- Our shared funcs
local function printTable (input, indentLevel)
	local indentLevel = indentLevel or 0
	if input == nil then
		Spring.Log('OO Defs', 'warning', 'nil table passed to printTable')
	else
		if indentLevel == 0 then
			Spring.Echo(string.rep("=", 60))
		end
		-- shove into an array for sorting so prints are consistent
		local ordered = {}
		for k,v in pairs (input) do table.insert(ordered, { k, v }) end

		table.sort(ordered, function (a, b)
			return a[1] < b[1]
		end)

		for i, tuple in ipairs(ordered) do
			local k, v = tuple[1], tuple[2]
			local indent = string.rep("  ", indentLevel)
			local what = type(v)
			if what == "table" then
				Spring.Echo(indent .. k .. ": ")
				printTable(v, indentLevel + 1)
			else
				Spring.Echo(indent .. k .. ' = ' .. tostring(v))
			end
		end

		if indentLevel == 0 then
			Spring.Echo(string.rep("=", 60))
		end
	end
end

local function inherit (c, p, concatNames)
	lowerkeys(c)
	for k,v in pairs(p) do
		if type(k) == "string" and type(v) ~= "function" then
			k = k:lower() -- can't use lowerkeys() on parent, as breaks e.g. New() -> new
		end
		if type(v) == "table" then
			if c[k] == nil then c[k] = {} end
			inherit(c[k], v)
		else
			if concatNames and k == "name" then
				c[k] = v .. " " .. (c[k] or "")
			else
				if c[k] == nil then c[k] = v end
				--Spring.Echo(c.name, k, v, c[k])
			end
		end
	end
end

local function append (c, p)
	lowerkeys(c)
	for k,v in pairs(p) do
		if type(v) == "string" then
			c[k] = v .. " " .. (c[k] or "")
		else
			Spring.Log("OO Defs", "error", "Attempt to concatenate non-string value")
		end
	end
end

-- translate undef to nil so class consumers can explicitly drop parent
-- values
local function filterUndef (table)
	for k,v in pairs(table) do
		if type(v) == "table" then
			filterUndef(table[k])
		else
			if v and v == 'explicitly-undefined-in-child' then
				table[k] = nil
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
Def = {
}

function Def:New(newAttribs, concatName)
	local newClass = {}
    if newAttribs == nil then
        Spring.Log('OO Defs', 'error', 'Def:New called with nil child. check all children of ' .. self.name)
        newAttribs = {
            name = "ERROR: Invalid Child def. Check all instances that inherit from " .. self.name
        }
    end
	inherit(newClass, newAttribs)
	inherit(newClass, self, concatName)
	filterUndef(newClass)

	return newClass
end

function Def:Clone(name) -- name is passed to <NAME> in _post, it is the unitname of the unit to copy from
	local newClass = {}
	inherit(newClass, self)
	newClass.unitname = name:lower()
	filterUndef(newClass)

	return newClass
end

function Def:Append(newAttribs)
	local newClass = {}
    if newAttribs == nil then
        Spring.Log('OO Defs', 'error', 'Def:Append called with nil newAttributes. check all Append consumers of ' .. self.name)
        newAttribs = {
            name = "ERROR: Invalid Append def. Check all instances that append to " .. self.name
        }
    end
	inherit(newClass, self)
	append(newClass, newAttribs)
	filterUndef(newClass)

	return newClass
end

Unit = Def:New{
	showNanoFrame			= false,
	showNanoSpray			= false,
	objectName				= "<SIDE>/<NAME>.s3o",
	buildPic				= "<NAME>.png",
	script					= "<NAME>.cob",
	customParams			= {
		normaltex			= "",
	},
}

Weapon = Def:New{
	customParams = {
		-- this breaks AA, commenting it out. Why is it even there?
		--onlytargetcategory     = "BUILDING INFANTRY SOFTVEH OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		wiki_comments = "",      -- To be override by each unit
	},
}

---------------------------------------------------------------------------------------------

-- This is where the magic happens
local sharedEnv = {
	Sides = Sides,
	Def = Def,
	Unit = Unit,
	Weapon = Weapon,
	printTable = printTable,
	lowerkeys = lowerkeys,
}

-- Include Base Classes from BaseClasses/*

local baseClassTypes = {"units", "weapons", "features"}

for _, baseClassType in pairs(baseClassTypes) do
	local baseClasses = RecursiveFileSearch("baseclasses/" .. baseClassType, "*.lua", VFS.ZIP)
	for _, file in pairs(baseClasses) do
		newClasses = VFS.Include(file, VFS.ZIP)
		for className, class in pairs(newClasses) do
			sharedEnv[className] = class
			_G[className] = class
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
			end
			local x = setmetatable_orig(t, { __index = sharedEnvMT })
			return x
		end
	end
	return setmetatable_orig(t, mt)
end
