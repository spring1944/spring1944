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
local bugOutLevel = 3 --amount of fear where the plane bugs out back to HQ 
local CMD_MOVE = CMD.MOVE
local planeScriptIDs = {}
local hqIDs = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.canFly then
		local planeScriptID = Spring.GetCOBScriptID(unitID, "luaFunction")
  		if (planeScriptID) then 
			SetUnitRulesParam(unitID, "suppress", 0)
			planeScriptIDs[unitID] = planeScriptID
		end
	end
end


function gadget:UnitDestroyed(unitID)

  planeScriptIDs[unitID] = nil
end

--[[function gadget:UnitIdle(unitIDIdle)
	local unitDefID = Spring.GetUnitDefID(unitIDIdle)
	local ud = UnitDefs[unitDefID]
	if ud.canFly then
	for unitID, someThing in pairs(planeScriptIDs) do
		if Spring.GetUnitNoSelect == true then]]--
		

function gadget:GameFrame(n)
	if (n % (0.25*30) < 0.1) then
	  for unitID, funcID in pairs(planeScriptIDs) do
		local _, suppression = Spring.CallCOBScript(unitID, funcID, 1, 1)
		local teamID = Spring.GetUnitTeam(unitID)
		--Spring.Echo("Plane TeamID", teamID)
			if suppression > bugOutLevel then 
				SetUnitRulesParam(unitID, "suppress", suppression)
				local px, py, pz = Spring.GetTeamStartPosition(teamID)
				Spring.GiveOrderToUnit(unitID, CMD_MOVE, {px, py, pz}, {})
				--Spring.Echo("Move order issued,", "Fear level:", suppression)
				Spring.SetUnitNoSelect(unitID, true)
			else
				--Spring.Echo("No Fear, selectable:", suppression)
				Spring.SetUnitNoSelect(unitID, false)
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
