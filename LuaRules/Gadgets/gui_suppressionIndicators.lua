--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:GetInfo()
  return {
    name      = "Supression Indicators",
    desc      = "Visually indicates supression levels",
    author    = "quantum",
    date      = "June 29, 2007",
    license   = "GNU GPL, v2 or later",
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


local scriptIDs = {}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:UnitCreated(unitID)
	local scriptID = Spring.GetCOBScriptID(unitID, "luaFunction")
  --scriptIDs[unitID] = Spring.GetCOBScriptID(unitID, "luaFunction")
	if (scriptID) then 
		SetUnitRulesParam(unitID, "suppress", 0)
		scriptIDs[unitID] = scriptID
	end
end


function gadget:UnitDestroyed(unitID)
  scriptIDs[unitID] = nil
end


function gadget:GameFrame(n)
	if (n % (1.5*30) < 0.1) then
	  for unitID, funcID in pairs(scriptIDs) do
		local _, suppression = Spring.CallCOBScript(unitID, funcID, 1, 1)
		--SendToUnsynced("supressed", unitID, supression)
			SetUnitRulesParam(unitID, "suppress", suppression)
	  end
	end
end

--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
else
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
--[[local WhiteStr   = "\255\255\255\255"
local RedStr     = "\255\255\001\001"


local pinnedThreshold = 15
local fontSize = 20

local units = {}
local remove = {}
function gadget:DrawScreen(dt)
  local readTeam
  local spec, specFullView = Spring.GetSpectatingState()
  if (specFullView) then
    readTeam = Script.ALL_ACCESS_TEAM
  else
    readTeam = Spring.GetLocalTeamID()
  end
  CallAsTeam({ ['read'] = readTeam }, function()
      local n = Spring.GetGameFrame()
      for unitID, supression in pairs(units) do
        -- if (not Spring.GetUnitViewPosition(unitID)) then
          -- break
        -- end
        local wx, wy, wz = Spring.GetUnitPosition(unitID)
        if (not wx) then
          remove[unitID] = true
          break
        end
        local sx, sy, sz = Spring.WorldToScreenCoords(wx, wy, wz)
        if (supression >= pinnedThreshold) then
          gl.Text(RedStr..supression, sx, sy, 20, "c")
        elseif (supression ~= 0) then
          gl.Text(WhiteStr..supression, sx, sy, 10, "c")
        -- else
          -- gl.Text(WhiteStr.."x", sx, sy, 10, "c")
        end
      end
    end
  )
  for unitID in pairs(remove) do
    units[unitID] = nil
  end
end

function RecvFromSynced(...)
  if (arg[2] == 'supressed') then
    units[arg[3] ] = arg[4]
  end
end]]
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

