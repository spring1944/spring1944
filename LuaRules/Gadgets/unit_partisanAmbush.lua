function gadget:GetInfo()
  return {
    name      = "Partisan Ambush Button",
    desc      = "Adds a toggle button to set partisan ambush mode",
    author    = "Nemo, using code from Yuritch",
    date      = "25 November 2012",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 100,
    enabled   = true --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

--synced READ
local FindUnitCmdDesc   = Spring.FindUnitCmdDesc

--synced CTRL
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local EditUnitCmdDesc   = Spring.EditUnitCmdDesc
local CallCOBScript     = Spring.CallCOBScript

local CMD_AMBUSH		= GG.CustomCommands.GetCmdID("CMD_AMBUSH")

--globals
local ambushCmdDesc = {
    id      = CMD_AMBUSH,
    type    = CMDTYPE.ICON_MODE,
	action  = "toggleambush",
	tooltip = 'Toggle between Ambush and Normal modes.',
	params  = {0, 'Normal', 'Ambush'},
}

--Callins
function gadget:UnitCreated(unitID, unitDefID, teamID)
    local name = UnitDefs[unitDefID].name
    if name == "ruspartisanrifle" then
        InsertUnitCmdDesc(unitID, ambushCmdDesc)
    end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_AMBUSH then
		local cmdDescID = FindUnitCmdDesc(unitID, CMD_AMBUSH)
		if not cmdDescID then return false end
		if cmdParams[1] == 1 then
			CallCOBScript(unitID, "SetAmbush", 0)
		else
			CallCOBScript(unitID, "CancelAmbush", 0)
		end
        --you can't edit a single value in the params table for
        --editUnitCmdDesc, so we generate a new table
        local updatedParams = {
             cmdParams[1],
             ambushCmdDesc.params[2],
             ambushCmdDesc.params[3]
        }
        EditUnitCmdDesc(unitID, cmdDescID, {params = updatedParams})
        return false
	end
	return true
end

--eof!
