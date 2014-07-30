-- Author: Tobi Vollebregt
-- License: GNU General Public License v2

--[[
This class is implemented as a single function returning a table with public
interface methods.  Private data is stored in the function's closure.

Public interface:

local UnitLimitsMgr = CreateUnitLimitMgr(myTeamID)

function UnitLimitsMgr.AllowUnitCreation(unitDefID)
]]--

function CreateUnitLimitsMgr(myTeamID)

--speedups
local GetTeamUnitDefCount = Spring.GetTeamUnitDefCount

local UnitLimitsMgr = {}

-- Format: map unitDefID -> limit
local limits = gadget.unitLimits

--------------------------------------------------------------------------------
--
--  Game call-ins
--

function UnitLimitsMgr.AllowUnitCreation(unitDefID)
	if limits[unitDefID] then
		local count = GetTeamUnitDefCount(myTeamID, unitDefID)
		return (count or 0) < limits[unitDefID]
	end
	return true
end

--------------------------------------------------------------------------------
--
--  Initialization
--

return UnitLimitsMgr
end
