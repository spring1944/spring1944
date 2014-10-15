local luaType = gadget or widget

local versionNumber = "v1.0"

function luaType:GetInfo()
	return {
		name      = "Commands API",
		desc      = "Commands queue functions.",
		author    = "ashdnazg",
		date      = "29 May 2014",
		license   = "GNU GPL v2",
		layer     = -10000,
		enabled   = true  --  loaded by default?
	}
end

-- Unsynced Read
local GetUnitCommands = Spring.GetUnitCommands
local GetUnitPosition = Spring.GetUnitPosition
local GetModKeyState = Spring.GetModKeyState
local GetInvertQueueKey = Spring.GetInvertQueueKey


local function GetUnitPositionAtEndOfQueue(unitID)
	local queue = GetUnitCommands(unitID, -1)
	if queue then
		for i=#queue,1,-1 do
			local cmd = queue[i]
			if ((cmd.id == CMD.MOVE) or (cmd.id == CMD.FIGHT)) and (#cmd.params >= 3) then
				return unpack(cmd.params)
			end
		end
	end
	return GetUnitPosition(unitID)
end

-- Returns the position the unit will (probably) have when it would start
-- executing the command which is being given now. (Spring.GetActiveCommand)
local function GetUnitActiveCommandPosition(unitID)
	local _, _, _, shift = GetModKeyState()
	local invertQueueKey = GetInvertQueueKey()
	if (not invertQueueKey and shift) or (invertQueueKey and not shift) then
		return GetUnitPositionAtEndOfQueue(unitID)
	else
		return GetUnitPosition(unitID)
	end
end

local CmdQueue = {
	GetUnitPositionAtEndOfQueue = GetUnitPositionAtEndOfQueue,
	GetUnitActiveCommandPosition = GetUnitActiveCommandPosition,
}

if GG then
	GG.CmdQueue = CmdQueue
elseif WG then
	WG.CmdQueue = CmdQueue
end

