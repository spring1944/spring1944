--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Salvage",
    desc      = "Replaces 'Reclaim' Command with 'Salvage'",
    author    = "FLOZi",
    date      = "Jun 24, 2008",
    license   = "CC attribution-noncommerical 3.0 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end
	
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local FindUnitCmdDesc = Spring.FindUnitCmdDesc


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local ud = UnitDefs[unitDefID]
  if (ud.speed > 0 and ud.canReclaim) then
		local unitCmdDesc = FindUnitCmdDesc(unitID, CMD.RECLAIM)
		if (unitCmdDesc) then 
			EditUnitCmdDesc(unitID, unitCmdDesc, {name = "Salvage", tooltip = "Salvage: Salvage wrecks back into Command Points"}) 
		end
  end
end

end
