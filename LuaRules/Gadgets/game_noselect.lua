-- TODO: remove this gadget after the noselect exploit has been fixed engine side

function gadget:GetInfo()
	return {
		name      = "NoSelect fix",
		desc      = "Blocks orders for noSelect units",
		author    = "Tobi Vollebregt",
		date      = "April 20th, 2009",
		license   = "LGPL v2.1 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end


if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
local SetUnitNoSelect = Spring.SetUnitNoSelect
local GiveOrderToUnit = Spring.GiveOrderToUnit
local noSelect = {}
local allowAll = false


-- use this from other gadgets instead of Spring.SetUnitNoSelect
function GG.SetUnitNoSelect(unitID, enabled)
	SetUnitNoSelect(unitID, enabled)
	noSelect[unitID] = enabled or nil
end


-- use this from other gadgets instead of Spring.GiveOrderToUnit,
-- if it is desired the order is allowed even for NoSelect units.
function GG.GiveOrderToUnitDisregardingNoSelect(unitID, cmdID, cmdParams, cmdOptions)
	allowAll = true
	GiveOrderToUnit(unitID, cmdID, cmdParams, cmdOptions)
	allowAll = false
end


function gadgetHandler:UnitDestroyed(unitID)
	noSelect[unitID] = nil
end


function gadgetHandler:AllowCommand(unitID)
	return not noSelect[unitID] or allowAll
end

end
