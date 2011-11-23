function gadget:GetInfo()
  return {
    name      = "Plane Fear",
    desc      = "Causes Planes under heavy AA fire to abort attack runs",
    author    = "Nemo (B. Tyler), FLOZi (C. Lawrence)",
    date      = "April 20th, 2009",
    license   = "GPL v2",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

-- function localisations
local SetUnitRulesParam 	= Spring.SetUnitRulesParam
local mcDisable				= Spring.MoveCtrl.Disable
-- Synced Read
local GetUnitFuel 			= Spring.GetUnitFuel
local GetUnitHealth			= Spring.GetUnitHealth
local GetUnitTeam			= Spring.GetUnitTeam
-- Synced Ctrl
local CallCOBScript			= Spring.CallCOBScript
local SetUnitCOBValue		= Spring.SetUnitCOBValue
local SetUnitFuel 			= Spring.SetUnitFuel
local SetUnitWeaponState	= Spring.SetUnitWeaponState
-- Unsynced Ctrl
local GiveOrderToUnit		= Spring.GiveOrderToUnit
local SetUnitNoSelect		= Spring.SetUnitNoSelect

-- constants
local CMD_MOVE				= CMD.MOVE

local FUEL_LOSS_RATE = 2 -- the amount of 'fuel' (sortie time) lost per second while the unit is scared.
local BUGOUT_LEVEL = 2 --amount of fear where the plane bugs out back to HQ

-- variables
local planeScriptIDs = {}
local accuracyTable = {}


function gadget:Initialize()
	-- adjust BUGOUT_LEVEL using the multiplier
	local fear_mult = tonumber(Spring.GetModOptions().air_fear_mult) or 1
	if (fear_mult ~= 1) then
		BUGOUT_LEVEL = BUGOUT_LEVEL * fear_mult
	end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.canFly then
		local planeScriptID = Spring.GetCOBScriptID(unitID, "luaFunction")
  		if (planeScriptID) then
			local properAccuracy = Spring.GetUnitWeaponState(unitID, 0, "accuracy")
			SetUnitRulesParam(unitID, "suppress", 0)
			planeScriptIDs[unitID] = planeScriptID
			accuracyTable[unitID] = properAccuracy
		end
	end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage)
	local ud = UnitDefs[unitDefID]
	if ud.canFly and ud.name ~= "usparatrooper" then
		--Spring.Echo("AIRCRAFT DAMAGED")
		local health = GetUnitHealth(unitID)
		if damage > health then
			--Spring.Echo("DAMAGE", damage, "HEALTH", health)
			SetUnitCOBValue(unitID, COB.CRASHING, 1)
			mcDisable(unitID) -- disable movectrl for V1 / glider
			return 0
		end
	end
	return damage
end

function gadget:UnitDestroyed(unitID)
	accuracyTable[unitID] = nil
	planeScriptIDs[unitID] = nil
end


function gadget:GameFrame(n)
	if (n % 15 == 0) then -- every 15 frames
		for unitID, funcID in pairs(planeScriptIDs) do
			local _, suppression = CallCOBScript(unitID, funcID, 1, 1)
			local fuel = GetUnitFuel(unitID)
			local teamID = GetUnitTeam(unitID)
			--Spring.Echo("Plane TeamID", teamID, "Fuel", fuel, "Suppress", suppression)
			if suppression > 0 then
				local newFuel = fuel - FUEL_LOSS_RATE
				local oldAccuracy = Spring.GetUnitWeaponState(unitID, 0, "accuracy")
				if oldAccuracy ~= nil then
					SetUnitWeaponState(unitID, 0, {accuracy = oldAccuracy*suppression})
					--Spring.Echo("unit's fear level: ", suppression)
					SetUnitRulesParam(unitID, "suppress", suppression)
					SetUnitFuel(unitID, newFuel)
					--Spring.Echo("unitID: ", unitID, "oldFuel:", fuel, "newFuel:", newFuel)
					if suppression > BUGOUT_LEVEL then
						local px, py, pz = Spring.GetTeamStartPosition(teamID)
						GiveOrderToUnit(unitID, CMD_MOVE, {px, py, pz}, {})
						--Spring.Echo("Move order issued,", "Fear level:", suppression)
						SetUnitNoSelect(unitID, true)
					else
						--Spring.Echo("No Fear, selectable:", suppression)
						SetUnitNoSelect(unitID, false)
					end
				end
			else
				SetUnitWeaponState(unitID, 0, {accuracy = accuracyTable[unitID]})
			end
		end
	end
end

--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
else
--  UNSYNCED
--------------------------------------------------------------------------------
end
