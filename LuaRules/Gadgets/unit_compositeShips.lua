function gadget:GetInfo()
  return {
	name      = "Composite Ships Helper",
	desc      = "Does stuffs for composite ships",
	author    = "FLOZi (C. Lawrence)",
	date      = "26 June 2014",
	license   = "GNU GPL v2",
	layer     = 0,
	enabled   = true  --  loaded by default?
  }
end

-- Unsynced Ctrl
local SetUnitNoDraw			= Spring.SetUnitNoDraw
-- Synced Read
local GetUnitDefID			= Spring.GetUnitDefID
local GetUnitPosition		= Spring.GetUnitPosition
local GetUnitTransporter	= Spring.GetUnitTransporter
local GetUnitsInCylinder	= Spring.GetUnitsInCylinder
-- Synced Ctrl
local GiveOrderToUnit		= Spring.GiveOrderToUnit
local AddUnitDamage			= Spring.AddUnitDamage
local TransferUnit			= Spring.TransferUnit


if (gadgetHandler:IsSyncedCode()) then -- SYNCED

-- Constants
local MIN_HEALTH = 1 -- No fewer HP than this
local HEALTH_RESTORE_LEVEL = 0.5 -- What % of maxHP to restore turret function

-- Variables
GG.boatMothers = {} -- unitID = {child1ID, child2ID ...}
local childCache = {} -- unitID = motherID
local deadChildren = {} -- unitID = true

-- Commands which should be passed from mother to all children
local passedCmds = {[CMD.ATTACK] = true, [CMD.FIRE_STATE] = true, [CMD.STOP] = true}

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp.mother then
		GG.boatMothers[unitID] = {}
		local toRemove = {CMD.LOAD_UNITS, CMD.UNLOAD_UNITS}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	elseif cp.child then
		childCache[unitID] = true
		local toRemove = {CMD.MOVE_STATE, CMD.MOVE}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	GG.boatMothers[unitID] = nil
	childCache[unitID] = nil
	deadChildren[unitID] = nil
end

function gadget:UnitGiven(unitID, unitDefID, newTeam, oldTeam)
	local children = GG.boatMothers[unitID]
	if children then
		for _, childID in pairs(children) do
			TransferUnit(childID, newTeam, true)
		end
	end
end

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	if childCache[unitID] then
		--Spring.Echo("CHILD LOADED", unitID, transportID)
		childCache[unitID] = transportID -- set value to unitID of mother
		table.insert(GG.boatMothers[transportID], unitID) -- insert into GG.boatMothers list
	end 
end

local function DisableChild(childID, disable)
	deadChildren[childID] = disable
	Spring.SetUnitNeutral(childID, disable)
	env = Spring.UnitScript.GetScriptEnv(childID)
	Spring.UnitScript.CallAsUnit(childID, env.Disabled, disable)
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if childCache[attackerID] == unitID then
		return 0
	end
	
	if not childCache[unitID] then return damage end
	-- unit is a child
	local health = Spring.GetUnitHealth(unitID)
	if health - damage < MIN_HEALTH then
		local newDamage = health - MIN_HEALTH
		DisableChild(unitID, true)
		-- if the component is toast, apply damage to the base unit (so they
		-- don't become shields)
		local passThroughDamage = damage - newDamage
		local mother = childCache[unitID]
		if mother and not Spring.GetUnitIsDead(mother) then
			local wd = WeaponDefs[weaponDefID]
			local smallarmsDamage = wd.customParams and wd.customParams.damagetype == 'smallarm'
			-- hulls (mothers) don't take smallarms damage
			if not smallarmsDamage then
				AddUnitDamage(mother, passThroughDamage, 0, attackerID)
			end
			-- if one turret happens to damage another (disabled) one on the same ship,
			-- don't try to target oneself
			if attackerID ~= mother then
				Spring.SetUnitTarget(attackerID, mother, false, true)
			end
		end
		return newDamage
	end
	return damage
end

function gadget:GameFrame(n)
	if n % (30 * 3) == 0 then -- check every 3 seconds, TODO: too slow? SlowUpdate (16f)?
		for childID in pairs(deadChildren) do
			local health, maxHealth = Spring.GetUnitHealth(childID)
			if health/maxHealth > HEALTH_RESTORE_LEVEL then
				DisableChild(childID, false)
			end
		end
	end
end

function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
	local motherChildren = GG.boatMothers[unitID]
	if motherChildren and passedCmds[cmdID] then
		GG.Delay.DelayCall(Spring.GiveOrderToUnitArray, {motherChildren, cmdID, cmdParams, cmdOptions}, 1)
	end
	return true
end

--[[function gadget:AllowWeaponTarget(attackerID, targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	if deadChildren[targetID] then
		Spring.SetUnitTarget(attackerID, childCache[targetID])
		return false, defPriority
	end
	return true, defPriority
end]]

else -- UNSYNCED

end


