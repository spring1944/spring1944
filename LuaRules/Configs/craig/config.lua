-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--------------------------------------------------------------------------------
--
--  Data structures (constructor syntax)
--

-- Converts UnitDefName to UnitDefID, raises an error if name is not valid.
local function NameToID(name)
	local unitDef = UnitDefNames[name]
	if unitDef then
		return unitDef.id
	else
		error("Bad unitname: " .. name)
	end
end

-- Converts an array of UnitDefNames to an array of UnitDefIDs.
function UnitArray(t)
	local newArray = {}
	for i,name in ipairs(t) do
		newArray[i] = NameToID(name)
	end
	return newArray
end

-- Converts an array of UnitDefNames to a set of UnitDefIDs.
function UnitSet(t)
	local newSet = {}
	for i,name in ipairs(t) do
		newSet[NameToID(name)] = true
	end
	return newSet
end

-- Converts a map with UnitDefNames as keys to a map with UnitDefIDs as keys.
function UnitBag(t)
	local newBag = {}
	for k,v in pairs(t) do
		newBag[NameToID(k)] = v
	end
	return newBag
end

--------------------------------------------------------------------------------
--
--  Include configuration
--

local dir = "LuaRules/Configs/craig/s44/"

if (gadgetHandler:IsSyncedCode()) then
	-- SYNCED
else
	-- UNSYNCED
	include(dir .. "buildorder.lua")
end

-- both SYNCED and UNSYNCED
include(dir .. "unitlimits.lua")
