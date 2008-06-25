--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Button Manipulator",
    desc      = "Replaces 'Reclaim' Command with 'Salvage', hides Cloak and On/Off",
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
local RemoveUnitCmdDesc = Spring.RemoveUnitCmdDesc

local CMD_RECLAIM = CMD.RECLAIM
local CMD_CLOAK		= CMD.CLOAK
local CMD_ONOFF		= CMD.ONOFF


function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local ud = UnitDefs[unitDefID]
  if (ud.speed > 0 and ud.canReclaim) then
		local unitReclaimCmdDesc = FindUnitCmdDesc(unitID, CMD_RECLAIM)
		if (unitReclaimCmdDesc) then 
			EditUnitCmdDesc(unitID, unitReclaimCmdDesc, {name = "Salvage", tooltip = "Salvage: Salvage wrecks back into Command Points"}) 
		end
	elseif (ud.speed > 0 and ud.canCloak) then
		local unitCloakCmdDesc = FindUnitCmdDesc(unitID, CMD_CLOAK)
		if (unitCloakCmdDesc) then
			RemoveUnitCmdDesc(unitID, unitCloakCmdDesc)
		end
	elseif (ud.jammerRadius) then
		local unitOnOffCmdDesc = FindUnitCmdDesc(unitID, CMD_ONOFF)
		if (unitOnOffCmdDesc) then
			RemoveUnitCmdDesc(unitID, unitOnOffCmdDesc)
		end
	end
end

end
