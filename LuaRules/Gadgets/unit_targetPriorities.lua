function gadget:GetInfo()
  return {
    name      = "Target Priorities for LUS vehicles",
    desc      = "Calls the LUS priority function",
    author    = "ashdnazg",
    date      = "February 2, 2015",
    license   = "GNU GPL, v2 or later",
    layer     = 1, -- after lus
    enabled   = true  --  loaded by default?
  }
end

if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

local lusPriorityCache = {}
local lusManualTargetCache = {}

function gadget:AllowWeaponTarget(unitID, targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	if lusPriorityCache[unitID] then
		local newPriority = Spring.UnitScript.CallAsUnit(unitID, lusPriorityCache[unitID], targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
		return true, newPriority
	else
		return true, defPriority
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if lusManualTargetCache[unitID] and cmdID == CMD.ATTACK then
		Spring.UnitScript.CallAsUnit(unitID, lusManualTargetCache[unitID], cmdParams)
	end
	return true
end

function gadget:UnitCreated(unitID, unitDefID)
	local env = Spring.UnitScript.GetScriptEnv(unitID)
	if env then
		if env.WeaponPriority then
			lusPriorityCache[unitID] = env.WeaponPriority
		end
		if env.ManualTarget then
			lusManualTargetCache[unitID] = env.ManualTarget
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID)
	lusPriorityCache[unitID] = nil
	lusManualTargetCache[unitID] = nil
end

function gadget:Initialize()
	for _,unitID in ipairs(Spring.GetAllUnits()) do
		local unitDefID = Spring.GetUnitDefID(unitID)
		gadget:UnitCreated(unitID, unitDefID)
	end
end

--------------------------------------------------------------------------------
--  END SYNCED
--------------------------------------------------------------------------------
end
