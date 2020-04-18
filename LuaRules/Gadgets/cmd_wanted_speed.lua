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

local function SetUnitWantedSpeed(unitID, unitDefID, wantedSpeed, forceUpdate)
    if (not forceUpdate) and (lastWantedSpeed[unitID] == wantedSpeed) then
        return
    end

    local ud = UnitDefs[unitDefID]
    if ud.isImmobile or ud.canFly or ud.isAirUnit then
        -- Not ground unit. Zero-K is also considering the case of hovercrafts,
        -- but I (Sanguinario_Joe) think we are not even interested on that
        return
    end

    lastWantedSpeed[unitID] = wantedSpeed
	-- try to catch the exception
	if not pcall(
	    function()
            Spring.MoveCtrl.SetGroundMoveTypeData(unitID, "maxWantedSpeed", (wantedSpeed or 2000))
		end
	) then
		Spring.Echo("unit " .. unitID .. " has incompatible movetype for SetGroundMoveTypeData. The unit is: " .. UnitDefs[unitDefID].name)
	end;
end

function GG.ForceUpdateWantedMaxSpeed(unitID, unitDefID)
    SetUnitWantedSpeed(unitID, unitDefID, lastWantedSpeed[unitID], true)
end

local function MaintainWantedSpeed(unitID, unitDefID)
    if not lastWantedSpeed[unitID] then
        return
    end
    
    Spring.MoveCtrl.SetGroundMoveTypeData(unitID, unitDefID, "maxWantedSpeed", lastWantedSpeed[unitID])
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- Command Handling

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
    if cmdID ~= CMD_SET_WANTED_MAX_SPEED then
        -- MaintainWantedSpeed(unitID, unitDefID)  -- Zero-K has this enabled for some reason
        return true
    end

    local wantedSpeed = cmdParams[1]
    if not wantedSpeed then
        return false
    end
    wantedSpeed = (wantedSpeed > 0) and wantedSpeed
    SetUnitWantedSpeed(unitID, unitDefID, wantedSpeed)

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
