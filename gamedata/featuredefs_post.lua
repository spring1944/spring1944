-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    featuredefs_post.lua
--  brief:   featureDef post processing
--  author:  Dave Rodgers
--
--  Copyright (C) 2008.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Per-unitDef featureDefs
--

local function isbool(x)   return (type(x) == 'boolean') end
local function istable(x)  return (type(x) == 'table')   end
local function isnumber(x) return (type(x) == 'number')  end
local function isstring(x) return (type(x) == 'string')  end

-- order is priority
local CORPSE_SUFFIX = {"abandoned", "damaged", "burning", "destroyed", "dead", "wreck"}

--------------------------------------------------------------------------------

local function ProcessUnitDef(udName, ud)

	local fds = ud.featuredefs
	if (not istable(fds)) then
		return
	end

	-- add this unitDef's featureDefs
	for fdName, fd in pairs(fds) do
		if (isstring(fdName) and istable(fd)) then
			local fullName = udName .. '_' .. fdName
			FeatureDefs[fullName] = fd
			fd.filename = ud.filename
		end
	end

	-- FeatureDead name changes
	for fdName, fd in pairs(fds) do
		if (isstring(fdName) and istable(fd)) then
			if (isstring(fd.featuredead)) then
				local fullName = udName .. '_' .. fd.featuredead:lower()
				if (FeatureDefs[fullName]) then
					fd.featuredead = fullName
				end
			end
		end
	end

	-- convert the unit corpse name
	if (isstring(ud.corpse)) then
		local fullName = udName .. '_' .. ud.corpse:lower()
		local fd = FeatureDefs[fullName]
		if (fd) then
			ud.corpse = fullName
		end
	end
end


--------------------------------------------------------------------------------

-- Process the unitDefs

local UnitDefs = DEFS.unitDefs

for udName, ud in pairs(UnitDefs) do
	if (isstring(udName) and istable(ud)) then
		ProcessUnitDef(udName, ud)
		
		if not ud.corpse then
			for _, suffix in pairs(CORPSE_SUFFIX) do
				local fdName = udName .. '_' .. suffix
				if FeatureDefs[fdName] then
					ud.corpse = fdName
					break
				end
			end
		end
	end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local treeNames = {"tree", "fir", "pine", "oak", "maple", "birch", "palm"}
local bushNames = {"bush", "shrub", "grass"}

-- S44 code begins
for name, fd in pairs(FeatureDefs) do
	-- set tree feature colvols
	for _, treeName in pairs(treeNames) do
		if name:find(treeName) or fd.description:lower():find(treeName) then
			if (fd.collisionvolumetype or ""):lower() ~= "cyly" then
				fd.collisionvolumetype = "cyly"
				fd.collisionvolumetest = 1
				fd.collisionvolumescales = [[3 50 3]]
			end
		end
	end
	-- set bushes to non blocking
	for _, bushName in pairs(bushNames) do
		if name:find(bushName) or fd.description:lower():find(bushName) then
			fd.blocking = false
			fd.collisionvolumetype = "elli"
			fd.collisionvolumescales = [[10 10 10]]
			fd.collisionvolumeoffsets = [[0 -100 0]]
		end
	end
	-- add null normaltex
	if not fd.customparams then
		fd.customparams = {}
	end
	if not fd.customparams.normaltex then
		fd.customparams.normaltex = ""
	end
end