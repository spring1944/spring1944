-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

-- Misc config
FLAG_RADIUS = 230 --from S44 game_flagManager.lua
SQUAD_SIZE = 10

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

-- Converts UnitDefName array to UnitDefID array, raises an error if a name is
-- not valid.
local function NameArrayToIdArray(array)
	local newArray = {}
	for i,name in ipairs(array) do
		newArray[i] = NameToID(name)
	end
	return newArray
end

-- Converts UnitDefName array to UnitDefID map, raises an error if a name is
-- not valid.
local function NameArrayToIdSet(array)
	local newSet = {}
	for i,name in ipairs(array) do
		newSet[NameToID(name)] = true
	end
	return newSet
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

-- This lists all the units that should be considered flags.
gadget.flags = NameArrayToIdSet(UnitSet{
	"flag",
})

-- Number of units per side used to cap flags.
gadget.reservedFlagCappers = {
	gbr = 24,
	ger = 24,
	us  = 24,
	ita = 24,
	jpn = 24,
	rus = 2,
	swe = 24,
	hun = 24,
}

-- This lists all the units (of all sides) that may be used to cap flags.
-- NOTE: To be removed and automatically parsed
gadget.flagCappers = NameArrayToIdSet(UnitSet{
	"gbrrifle", "gbrsten",
	"gerrifle", "germp40",
	"itarifle", "itam38",
	"usrifle", "usthompson",
	"jpnrifle", "jpntype100smg",
	"ruscommissar", --no commander because it is needed for base building
	"swerifle",
	"hunrifle",
})

--------------------------------------------------------------------------------
--
--  Include configuration
--

local dir = "LuaRules/Configs/craig/s44/"

-- both SYNCED and UNSYNCED
include(dir .. "unitlimits.lua")
