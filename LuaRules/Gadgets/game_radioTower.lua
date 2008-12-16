--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Radio Tower Air Mission Caller",
    desc      = "Implements radio tower calls for air missions",
    author    = "FLOZi",
    date      = "Dec 15, 2008",
    license   = "CC attribution-noncommerical 3.0 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end
	
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

-- function localisations
-- Synced Read
local GetUnitPosition = Spring.GetUnitPosition

-- Synced Ctrl
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc

-- Constants
local CMD_EXECUTE_CALL = 33210
local CMD_CALL_FB = 34210
local MAP_SIZE_X = Game.mapSizeX
local MAP_SIZE_Z = Game.mapSizeZ
local PRINT	= false

-- Variables
local spawnPointX = {}
local spawnPointZ = {}

local executeCalled = {}

local executeCmdDesc = {
	id     = CMD_EXECUTE_CALL,
  type   = CMDTYPE.ICON,
  name   = 'Make it so!',
  cursor = 'execute',  -- add with LuaUI?
  action = 'Executes the radio call',
}

local fbCmdDesc = {
	id     = CMD_CALL_FB,
  type   = CMDTYPE.ICON_UNIT_OR_MAP,
  name   = 'Call FB',
  cursor = 'Attack',  -- add with LuaUI?
  action = 'Call',
	texture = 'unitpics/GERBf109.png',
}

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local ud = UnitDefs[unitDefID]
	if (ud.name == "gerflag") then
		Spring.Echo("Radio Tower Created!")
		InsertUnitCmdDesc(unitID, fbCmdDesc)
		InsertUnitCmdDesc(unitID, executeCmdDesc)
		getSpawnPoint(unitID, unitTeam)
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if (cmdID == CMD_CALL_FB) then
		if (PRINT) then
			Spring.Echo("CMD_CALL_FB Allow")
		end
	end
	if (cmdID == CMD_EXECUTE_CALL) then
		if (PRINT) then
			Spring.Echo("CMD_EXECUTE_CALL Allow")
		end
		--local shift
		--for i = 1, #cmdOptions do
		--	if (cmdOptions[i] == CMD.OPT_SHIFT) then
		--		shift = true
		--		break
		--	end
		--end
		--if (shift) then
			executeCalled[teamID] = true
			return true
		--else
			--Spring.GiveOrderToUnit(unitID, CMD_EXECUTE_CALL, cmdParams, {CMD.OPT_SHIFT})
		--	return false
		--end

	end
	return true
end

function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if (cmdID ~= CMD_CALL_FB) then
		return false
	end
	
	if (cmdID == CMD_CALL_FB) then
		if (PRINT) then
			Spring.Echo("CMD_CALL_FB Fallback!")
		end
		if (executeCalled[teamID]) then
			if (PRINT) then
				Spring.Echo("Executing radio call...")
			end
			newUnitID = Spring.CreateUnit('gerbf109', spawnPointX[teamID], 50000, spawnPointZ[teamID], 's', teamID)
			Spring.GiveOrderToUnit(newUnitID, CMD.ATTACK, cmdParams, cmdOptions)
			local cmdQ = Spring.GetCommandQueue(unitID)
			if (PRINT) then
				Spring.Echo("Command Queue is: " .. #cmdQ)
			end
			if (#cmdQ <= 2) then
				executeCalled[teamID] = false
			end
			return true, true
		else
			return true, false
		end
	end
end

function getSpawnPoint(unitID, teamID)
	local x,y,z = GetUnitPosition(unitID)
	if (x < MAP_SIZE_X / 2) then -- West
		spawnPointX[teamID] = -1000
	else -- East
		spawnPointX[teamID] = MAP_SIZE_X + 1000
	end
	if (z < MAP_SIZE_Z / 2) then -- North
		spawnPointZ[teamID] = -1000
	else -- South
		spawnPointZ[teamID] = MAP_SIZE_Z + 1000
	end
end

end
--[[
function gadget:CommandFallback(unitID, unitDefID, teamID,    -- keeps getting 
                                cmdID, cmdParams, cmdOptions) -- called until
  if (cmdID ~= CMD_JUMP)or(not jumpDefs[unitDefID]) then      -- you remove the
    return false  -- command was not used                     -- order
  end

  if (jumping[unitID]) then
    return true, false -- command was used but don't remove it
  end

  local x, y, z = spGetUnitBasePosition(unitID)
  local distSqr = GetDist2Sqr({x, y, z}, cmdParams)
  local jumpDef = jumpDefs[unitDefID]
  local range   = jumpDef.range
  local reload  = jumpDef.reload or 0
  local t       = spGetGameSeconds()

  if (distSqr < (range*range)) then
    local cmdTag = spGetCommandQueue(unitID,1)[1].tag
    if ((t - lastJump[unitID]) >= reload) then
      local coords = table.concat(cmdParams)
      if (not jumps[coords]) then
        if (not Jump(unitID, cmdParams, cmdTag)) then
          return true, true -- command was used, remove it 
        end
        jumps[coords] = 1
        return true, false -- command was used, remove it 
      else
        local r = landBoxSize*jumps[coords]^0.5/2
        local randpos = {
          cmdParams[1] + random(-r, r),
          cmdParams[2],
          cmdParams[3] + random(-r, r)}
        if (not Jump(unitID, randpos, cmdTag)) then
          return true, true -- command was used, remove it 
        end
        jumps[coords] = jumps[coords] + 1
        return true, false -- command was used, remove it 
      end
    end
  else
    Approach(unitID, cmdParams, range)
  end
  
  return true, false -- command was used but don't remove it
end
]]--