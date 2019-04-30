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
local unitDefIDsPassed = {}

-- function gadget:AllowWeaponTargetCheck(attackerID, attackerWeaponNum, attackerWeaponDefID)
	-- if lusPriorityCache[attackerID] and Spring.GetUnitStates(attackerID).firestate == 2 and
			-- not WeaponDefs[attackerWeaponDefID].noAutoTarget then -- verify we're on fire at will
		-- return true
	-- end
	-- return false
-- end

function ValidID(objectID)
	return Spring.ValidUnitID(objectID) or Spring.ValidFeatureID(objectID)
end

function gadget:AllowWeaponTarget(unitID, targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	-- Apparently, in spring-104 defPriority can be nil
	defPriority = defPriority or 0.0
	-- Apparently, in spring-104 the targetID can be an invalid ID
	if lusPriorityCache[unitID] and ValidID(targetID) then
		local newPriority = Spring.UnitScript.CallAsUnit(unitID, lusPriorityCache[unitID], targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
		return true, newPriority
	end
	return true, defPriority
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
	end
end

function gadget:UnitDestroyed(unitID, unitDefID)
	lusPriorityCache[unitID] = nil
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
