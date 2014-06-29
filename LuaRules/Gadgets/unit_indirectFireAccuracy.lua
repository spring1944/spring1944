function gadget:GetInfo()
	return {
		name	  = "Indirect Fire Accuracy Manager",
		desc	  = "Changes the accuracy of weapons fire based on the LoS status of the target",
		author	  = "Ben Tyler (Nemo), Craig Lawrence (FLOZi)",
		date	  = "Feb 10th, 2009",
		license	  = "LGPL v2.1 or later",
		layer	  = 0,
		enabled	  = true  --  loaded by default?
	}
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

--CMDS
local CMD_ATTACK			= CMD.ATTACK
local CMD_AREA_ATTACK		= CMD.AREA_ATTACK
--synced read
local IsPosInLos			= Spring.IsPosInLos
local IsPosInRadar			= Spring.IsPosInRadar
local ValidUnitID			= Spring.ValidUnitID
local GetUnitPosition		= Spring.GetUnitPosition
local GetUnitAllyTeam		= Spring.GetUnitAllyTeam
local GetGameSeconds		= Spring.GetGameSeconds
--synced control
local SetUnitWeaponState	= Spring.SetUnitWeaponState
local SetUnitExperience		= Spring.SetUnitExperience
local SetUnitRulesParam		= Spring.SetUnitRulesParam

--constants
local LOS_ACCURACY_COEFF    = 0.25 --how much more accurate the weapon gets (lower accuracy number = more accurate, this is multiplied by the regular accuracy)
local ZERO_IN_DELAY			= 20 --# of seconds after LoS is established on attack location before the accuracy improvement kicks in
-- how much a targeted unit can move from the original positition without
-- resetting zero-in
local FUDGE_FACTOR          = 50
--vars
local visibleAreas			= {}
local guns					= {}

local function dist(x1, z1, x2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (z2 - z1) ^ 2)
end

local function updateUnit(allyTeam, unitID)
	local unitDefID = Spring.GetUnitDefID(unitID)
	local weapons = UnitDefs[unitDefID].weapons
	local newAccuracy
	if visibleAreas[allyTeam][unitID] ~= nil then
		if (visibleAreas[allyTeam][unitID].zeroed == true) then
			newAccuracy = WeaponDefs[weapons[1].weaponDef].accuracy * LOS_ACCURACY_COEFF
		else
			newAccuracy = WeaponDefs[weapons[1].weaponDef].accuracy
		end
	end
	if weapons ~= nil then
		for i=1, #weapons do
			SetUnitWeaponState(unitID, i, {accuracy = newAccuracy})
		end
	end
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams)
	local ud = UnitDefs[unitDefID]
		if ud.customParams.canareaattack == "1" then
			if cmdID == CMD_ATTACK or cmdID == CMD_AREA_ATTACK then
				local allyTeam = GetUnitAllyTeam(unitID)
				local targetX, targetY, targetZ
                local targetUnitID

				if ValidUnitID(cmdParams[1]) == true then --shooting at a unit
					targetX, targetY, targetZ = GetUnitPosition(cmdParams[1])
                    targetUnitID = cmdParams[1]
				else --shooting at the ground
					targetX, targetY, targetZ = cmdParams[1], cmdParams[2], cmdParams[3]
				end

				if visibleAreas[allyTeam] == nil then
					visibleAreas[allyTeam] = {}
				end
				if visibleAreas[allyTeam][unitID] == nil then
					visibleAreas[allyTeam][unitID] = {}
				end

				visibleAreas[allyTeam][unitID] = {
							targetTime = nil, --just until the next update calls
							zeroed = false,
							x = targetX,
							y = targetY,
							z = targetZ,
                            targetUnitID = targetUnitID,
						}
				if targetX ~= nil and targetY ~= nil and targetZ ~= nil then
					if IsPosInLos(targetX, targetY, targetZ, allyTeam) == true or IsPosInRadar(targetX, targetY, targetZ, allyTeam) == true then
						visibleAreas[allyTeam][unitID].targetTime = GetGameSeconds()
                        SetUnitRulesParam(unitID, "zeroed", 0)
					end
				end
			end
		end
	return true
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.canareaattack == "1" then
		guns[unitID] = true
	end
	local allyTeam = GetUnitAllyTeam(unitID)
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	local allyTeam = GetUnitAllyTeam(unitID)
	if guns[unitID] then
		guns[unitID] = nil
	end
	if visibleAreas[allyTeam] then
		visibleAreas[allyTeam][unitID] = nil
	end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
	-- Reset visibleAreas if unit is given to an enemy player
	local allyTeam = GetUnitAllyTeam(unitID)
	if not Spring.AreTeamsAllied (unitTeam, oldTeam) and visibleAreas[allyTeam] then
		visibleAreas[allyTeam][unitID] = nil
	end
end

function gadget:GameFrame(n)
	if (n % (2*30)) < 0.1 then --update every two seconds
		for allyID, units in pairs(visibleAreas) do
			for unitID, targetArea in pairs(units) do
				if ValidUnitID(unitID) and targetArea then
                    if targetArea.x ~= nil and targetArea.y ~= nil and targetArea.z ~= nil then
                        local targetUnitID = targetArea.targetUnitID

                        -- targeting a unit, need to make sure it didn't move
                        if targetUnitID and ValidUnitID(targetUnitID) then
                            local x, y, z = GetUnitPosition(targetUnitID)
                            local tx, ty, tz = targetArea.x, targetArea.y, targetArea.z

                            -- unit moved too much, clear out any potential
                            -- zero-ing
                            if dist(x, z, tx, tz) > FUDGE_FACTOR then
                                targetArea.targetTime = GetGameSeconds()
                                targetArea.zeroed = false
                                targetArea.x, targetArea.y, targetArea.z = x, y, z
                                SetUnitRulesParam(unitID, "zeroed", 0)
                            end
                        end

                        if IsPosInLos(targetArea.x, targetArea.y, targetArea.z, allyID) == true then
                            if targetArea.targetTime == nil then
                                targetArea.targetTime = GetGameSeconds()
                            end
                            if ((n/30) - targetArea.targetTime) > ZERO_IN_DELAY then
                                targetArea.zeroed = true
                                SetUnitRulesParam(unitID, "zeroed", 1)
                            end
                        else
                            targetArea.targetTime = GetGameSeconds()
                            targetArea.zeroed = false
                            SetUnitRulesParam(unitID, "zeroed", 0)
                        end

                        updateUnit(allyID, unitID)
                    end
				end
			end
		end
	end
end
