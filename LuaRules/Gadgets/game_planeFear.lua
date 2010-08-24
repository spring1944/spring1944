--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:GetInfo()
  return {
    name      = "Plane Fear",
    desc      = "Causes Planes under heavy AA fire to abort attack runs",
    author    = "B. Tyler",
    date      = "April 20th, 2009",
    license   = "LGPL v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--local Spring = Spring
--local gl = gl
local SetUnitRulesParam = Spring.SetUnitRulesParam
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
local SetUnitNoSelect = Spring.SetUnitNoSelect
local GiveOrderToUnit = Spring.GiveOrderToUnit

local fuelLossRate = 6 -- the amount of 'fuel' (sortie time) lost per second while the unit is scared.
local bugOutLevel = 4 --amount of fear where the plane bugs out back to HQ
local CMD_MOVE = CMD.MOVE
local planeScriptIDs = {}
local accuracyTable = {}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:Initialize()
	-- adjust bugOutLevel using the multiplier
	local fear_mult = tonumber(Spring.GetModOptions().air_fear_mult) or 1
	if (fear_mult ~= 1) then
		bugOutLevel = bugOutLevel * fear_mult
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


function gadget:UnitDestroyed(unitID)
  accuracyTable[unitID] = nil
  planeScriptIDs[unitID] = nil
end

--[[function gadget:UnitIdle(unitIDIdle)
	local unitDefID = Spring.GetUnitDefID(unitIDIdle)
	local ud = UnitDefs[unitDefID]
	if ud.canFly then
	for unitID, someThing in pairs(planeScriptIDs) do
		if Spring.GetUnitNoSelect == true then]]--


function gadget:GameFrame(n)
	if (n % (1*30) < 0.1) then
	  for unitID, funcID in pairs(planeScriptIDs) do
		local _, suppression = Spring.CallCOBScript(unitID, funcID, 1, 1)
		local fuel = Spring.GetUnitFuel(unitID)
		local teamID = Spring.GetUnitTeam(unitID)
		--Spring.Echo("Plane TeamID", teamID)
			if suppression > 1 then
				local newFuel = fuel - fuelLossRate
				local oldAccuracy = Spring.GetUnitWeaponState(unitID, 0, "accuracy")
				if oldAccuracy ~= nil then
					Spring.SetUnitWeaponState(unitID, 0, {accuracy = oldAccuracy*suppression})
					--Spring.Echo("unit's fear level: ", suppression)
					SetUnitRulesParam(unitID, "suppress", suppression)
					Spring.SetUnitFuel(unitID, newFuel)
					--Spring.Echo("unitID: ", unitID, "oldFuel:", fuel, "newFuel:", newFuel)
					if suppression > bugOutLevel then
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
				Spring.SetUnitWeaponState(unitID, 0, {accuracy = accuracyTable[unitID]})
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
