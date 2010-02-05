function gadget:GetInfo()
	return {
		name      = "Turn Command",
		desc      = "Implements Turn command for vehicles",
		author    = "FLOZi",
		date      = "5/02/10",
		license   = "PD",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

-- SyncedCtrl
-- SyncedRead
-- Constants
local CMD_TURN = 35521 -- this should be changed, we really need some centralised 'commands.h.lua' file with our used command ids

local turnCmdDesc = {
	id = CMD_TURN,
	type = CMDTYPE.ICON_MAP,
	name = "Turn",
	tooltip = "Turn to face a given point",
	cursor = "Patrol",
}


if (gadgetHandler:IsSyncedCode()) then
-- SYNCED

function gadget:Initialize()
	gadgetHandler:RegisterCMDID(CMD_TURN)
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	local ud = UnitDefs[unitDefID]
	if ud.customParams.hasturnbutton then
		Spring.InsertUnitCmdDesc(unitID, 500, turnCmdDesc)
		Spring.CallCOBScript(unitID, "SetTurnSpeed", 1, ud.turnRate or 5*182)
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	local ud = UnitDefs[unitDefID]
	if cmdID == CMD_TURN and not ud.customParams.hasturnbutton then
		return false
	end
	return true
end

function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions)
	local ud = UnitDefs[unitDefID]
	if cmdID == CMD_TURN then
		Spring.Echo("CMD_TURN")
		local tx, _, tz = cmdParams[1], cmdParams[2], cmdParams[3]
		local ux, _, uz = Spring.GetUnitPosition(unitID)
		local dx, dz = tx - ux, tz - uz
		local rotation = math.atan2(dx, dz)
		-- convert to COB angular units
		local COBAngularConstant = 182
		rotation = rotation * 180 / math.pi * COBAngularConstant
		Spring.CallCOBScript(unitID, "RotateHere", 1, rotation)
		return true, true
	end
	return false
end

else
-- UNSYNCED
function gadget:Initialize()
	Spring.SetCustomCommandDrawData(CMD_TURN, "Patrol", {0,1,0,.8})
end

end
