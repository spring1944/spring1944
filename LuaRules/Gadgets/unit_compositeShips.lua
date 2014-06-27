function gadget:GetInfo()
  return {
    name      = "Composite Ships Helper",
    desc      = "Does stuffs for composite ships",
    author    = "FLOZi",
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
local GetUnitPosition 		= Spring.GetUnitPosition
local GetUnitTransporter 	= Spring.GetUnitTransporter
local GetUnitsInCylinder 	= Spring.GetUnitsInCylinder
-- Synced Ctrl
local GiveOrderToUnit		= Spring.GiveOrderToUnit


if (gadgetHandler:IsSyncedCode()) then -- SYNCED

local DelayCall = GG.Delay.DelayCall

-- Constants
local MIN_HEALTH = 1
local HEALTH_RESTORE_LEVEL = 0.5

-- Variables
local motherCache = {} -- unitID = true
local childCache = {} -- unitID = motherID
local deadChildren = {} -- unitID = true


function gadget:UnitCreated(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp then
		motherCache[unitID] = cp.mother
		childCache[unitID] = cp.child
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	motherCache[unitID] = nil
	childCache[unitID] = nil
    deadChildren[unitID] = nil
end

function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
	if childCache[unitID] then
		Spring.Echo("CHILD LOADED", unitID, transportID)
		childCache[unitID] = transportID
	end -- set value to unitID of mother
end

local function DisableChild(childID, disable)
	deadChildren[childID] = disable
	Spring.SetUnitNeutral(childID, disable)
	env = Spring.UnitScript.GetScriptEnv(childID)
	Spring.UnitScript.CallAsUnit(childID, env.Disabled, disable)
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if not childCache[unitID] then return damage end
	-- unit is a child
	local health = Spring.GetUnitHealth(unitID)
	if health - damage < MIN_HEALTH then
		local newDamage = health - MIN_HEALTH
		DisableChild(unitID, true)
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
--[[function gadget:AllowWeaponTarget(attackerID, targetID, attackerWeaponNum, attackerWeaponDefID, defPriority)
	if deadChildren[targetID] then
		Spring.SetUnitTarget(attackerID, childCache[targetID])
		return false, defPriority
	end
	return true, defPriority
end]]

else -- UNSYNCED

end


