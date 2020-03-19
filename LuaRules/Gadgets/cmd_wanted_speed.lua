--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
    return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
    return {
        name      = "Wanted Speed",
        desc      = "Adds a command which sets maxWantedSpeed.",
        author    = "GoogleFrog",
        date      = "11 November 2018",
        license   = "GNU GPL, v2 or later",
        layer     = -math.huge + 1, -- Right after 0_api_customCmdHandler.lua
        enabled   = not CMD.SET_WANTED_MAX_SPEED
    }
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local CMD_SET_WANTED_MAX_SPEED = GG.CustomCommands.GetCmdID("CMD_SET_WANTED_MAX_SPEED")
local lastWantedSpeed = {}

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local function SetUnitWantedSpeed(unitID, wantedSpeed, forceUpdate)
    if (not forceUpdate) and (lastWantedSpeed[unitID] == wantedSpeed) then
        return
    end

    lastWantedSpeed[unitID] = wantedSpeed
    Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxWantedSpeed", (wantedSpeed or 2000))
end

function GG.ForceUpdateWantedMaxSpeed(unitID)
    SetUnitWantedSpeed(unitID, lastWantedSpeed[unitID], true)
end

local function MaintainWantedSpeed(unitID)
    if not lastWantedSpeed[unitID] then
        return
    end
    
    Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxWantedSpeed", lastWantedSpeed[unitID])
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- Command Handling

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    if cmdID ~= CMD_SET_WANTED_MAX_SPEED then
        -- MaintainWantedSpeed(unitID)  -- Zero-K has this enabled for some reason
        return true
    end

    local wantedSpeed = cmdParams[1]
    if not wantedSpeed then
        return false
    end
    wantedSpeed = (wantedSpeed > 0) and wantedSpeed
    SetUnitWantedSpeed(unitID, wantedSpeed)

    return false
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- Cleanup

function gadget:UnitDestroyed(unitID)
    lastWantedSpeed[unitID] = nil
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
