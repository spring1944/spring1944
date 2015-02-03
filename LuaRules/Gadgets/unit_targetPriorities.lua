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
local unitDefIDsPassed = {}

function gadget:AllowWeaponTargetCheck(attackerID, attackerWeaponNum, attackerWeaponDefID)
	return true
end

function gadget:AllowWeaponTarget(unitID, targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	if lusPriorityCache[unitID] then
		local newPriority = Spring.UnitScript.CallAsUnit(unitID, lusPriorityCache[unitID], targetID, attackerWeaponNum + 1, attackerWeaponDefID, defPriority)
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
			if not unitDefIDsPassed[unitDefID] then
				local weapons = UnitDefs[unitDefID].weapons
				local weaponsWithAmmo = UnitDefs[unitDefID].customParams.weaponswithammo or 0
				for i = 1, weaponsWithAmmo + 1 do
					local weapon = weapons[i]
					if weapon then
						Script.SetWatchWeapon(weapon.weaponDef, true)
					end
				end
				unitDefIDsPassed[unitDefID] = true
			end
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
