function gadget:GetInfo()
  return {
    name      = "Storage Dies Penalty",
    desc      = "Gives penalties for destruction of economy buildings and storage",
    author    = "TheFatController, Nemo, FLOZi",
    date      = "June 23, 2007. October 12, 2009",
    license   = "GNU GPL, v2 or later",
    layer     = -5,
    enabled   = true  --  loaded by default?
  }
end

local UseTeamResource = Spring.UseTeamResource
local GetTeamResources = Spring.GetTeamResources
local GetUnitHealth = Spring.GetUnitHealth

if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  local _, _, _, _, buildProgress = GetUnitHealth(unitID)
  if buildProgress == 1 then
    local eStore = UnitDefs[unitDefID].energyStorage
    if (eStore > 0) then
      local eCur, eMax = GetTeamResources(unitTeam, "energy")
      local stored = (eStore / eMax)
	  UseTeamResource(unitTeam, "e", (eCur * stored))
    end
  end
end

--------------------------------------------------------------------------------
--  END SYNCED
--------------------------------------------------------------------------------
end
