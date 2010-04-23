-- $Id$
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Profiler",
    desc      = "",
    author    = "jK",
    date      = "Dec 19, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = math.huge,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local callinTimes       = {}
local callinTimesSYNCED = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local SCRIPT_DIR = Script.GetName() .. '/'

local Hook = function(g,name) return function(...) return g[name](...) end end --//place holder

if (gadgetHandler:IsSyncedCode()) then
  Hook = function (g,name)
    return function(...)
      SendToUnsynced("prf_started",g.ghInfo.name,name)
      local results = {g["_old" .. name](...)}
      SendToUnsynced("prf_finished",g.ghInfo.name,name)
      return unpack(results)
    end
  end
else
  Hook = function (g,name)
    return function(...)
      local t  = Spring.GetTimer()
      --local startTime = os.clock()
      local results = {g["_old" .. name](...)}
      local dt = Spring.DiffTimers(Spring.GetTimer(),t)
      --local dt = os.clock() - startTime
      if (not callinTimes[g.ghInfo.name]) then
        callinTimes[g.ghInfo.name] = {}
      end
      callinTimes[g.ghInfo.name][name] = (callinTimes[g.ghInfo.name][name] or 0) + dt
      --Spring.Echo(g.ghInfo.name,name,callinTimes[g.ghInfo.name][name])
      return unpack(results)
    end
  end
end

local function ArrayInsert(t, f, g)
  if (f) then
    local layer = g.ghInfo.layer
    local index = 1
    for i,v in ipairs(t) do
      if (v == g) then
        return -- already in the table
      end
      if (layer >= v.ghInfo.layer) then
        index = i + 1
      end
    end
    table.insert(t, index, g)
  end
end


local function ArrayRemove(t, g)
  for k,v in ipairs(t) do
    if (v == g) then
      table.remove(t, k)
      -- break
    end
  end
end

local hookset = false

local function StartHook()
  if (hookset) then return end
  hookset = true
  Spring.Echo("start profiling")

  VFS.Include(SCRIPT_DIR .. 'callins.lua', nil, VFS.ZIP_ONLY)
  local gh = gadgetHandler.gadgetHandler

  --// hook all existing callins
  for _,callin in ipairs(CallInsList) do
    local callinGadgets = gh[callin .. "List"]
    for _,g in ipairs(callinGadgets or {}) do
      g["_old" .. callin] = g[callin]
      g[callin] = Hook(g,callin)
    end
  end

  Spring.Echo("hooked all callins: OK")

  --// hook the UpdateCallin function
  gh.UpdateGadgetCallIn = function(self,name,g)
    local listName = name .. 'List'
    local ciList = self[listName]
    if (ciList) then
      local func = g[name]
      if (type(func) == 'function') then
        g["_old" .. name] = g[name]
        g[name] = Hook(g,name)
        ArrayInsert(ciList, func, g)
      else
        ArrayRemove(ciList, g)
      end
      self:UpdateCallIn(name)
    else
      print('UpdateGadgetCallIn: bad name: ' .. name)
    end
  end

  Spring.Echo("hooked UpdateCallin: OK")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (gadgetHandler:IsSyncedCode()) then

  function gadget:Initialize()
    gadgetHandler:AddChatAction('profile', StartHook,
      " : starts the gadget profiler (for debugging issues)"
    )
    --StartHook()
  end

  --function gadget:Shutdown()
  --end

  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
else
  --------------------------------------------------------------------------------
  --------------------------------------------------------------------------------

  local startTimer
  local startTimerSYNCED
  local profile_unsynced = false
  local profile_synced = false

  local timers = {}
  function SyncedCallinStarted(_,gname,cname)
    local t  = Spring.GetTimer()
    timers[#timers+1] = t
  end

  local function UpdateDrawCallin()
    gadget.DrawScreen = DrawScreen_
    gadgetHandler:UpdateCallIn("DrawScreen")
  end

  local function Start()
    if (not profile_unsynced) then
      UpdateDrawCallin()
      UpdateDrawCallin()
      startTimer = Spring.GetTimer()
      StartHook()
      profile_unsynced = true
    end
  end
  local function StartSYNCED()
    if (not profile_synced) then
      startTimerSYNCED = Spring.GetTimer()
      profile_synced = true
      UpdateDrawCallin()
      UpdateDrawCallin()
    end
  end

  function SyncedCallinFinished(_,gname,cname)
    local dt = Spring.DiffTimers(Spring.GetTimer(),timers[#timers])
    timers[#timers]=nil
    if (not callinTimesSYNCED[gname]) then
      callinTimesSYNCED[gname] = {}
    end
    callinTimesSYNCED[gname][cname] = (callinTimesSYNCED[gname][cname] or 0) + dt
  end

  function gadget:Initialize()
    gadgetHandler:AddSyncAction("prf_started",SyncedCallinStarted) 
    gadgetHandler:AddSyncAction("prf_finished",SyncedCallinFinished) 

    gadgetHandler:AddChatAction('uprofile', Start,
      " : starts the gadget profiler (for debugging issues)"
    )
    gadgetHandler:AddChatAction('profile', StartSYNCED,"")
    --StartHook()
  end

  function gadget:DrawScreen_(vsx, vsy)
    local maximum = 0

    local totalTimes  = {}
    local allOverTime = 0
    local runTime     = 0
    if (profile_unsynced) then
      runTime = Spring.DiffTimers(Spring.GetTimer(),startTimer)
      for gname,callins in pairs(callinTimes) do
        if (gname~="Profiler") then
          local total = 0
          local cmax,cmaxname  = 0,""
          for cname,time in pairs(callins) do
            total = total + time
            if (time>cmax) then
              cmax = time
              cmaxname  = cname
            end
          end
          --totalTimes[gname] = total
          totalTimes[cmaxname..'('..gname..')'] = cmax
          allOverTime = allOverTime + total
          if (maximum<total) then maximum=total end
        end
      end
    end

    local allOverTimeSYNCED = 0
    local totalTimesSYNCED  = {}
    local runTimeSYNCED     = 0
    if (profile_synced) then
      runTimeSYNCED = Spring.DiffTimers(Spring.GetTimer(),startTimerSYNCED)
      for gname,callins in pairs(callinTimesSYNCED) do
        if (gname~="Profiler") then
          local total = 0
          local cmax,cmaxname  = 0,""
          for cname,time in pairs(callins) do
            total = total + time
            if (time>cmax) then
              cmax = time
              cmaxname  = cname
            end
          end
          --totalTimes[gname] = total
          totalTimesSYNCED[cmaxname..'('..gname..')'] = cmax
          allOverTimeSYNCED = allOverTimeSYNCED + total
          if (maximum<total) then maximum=total end
        end
      end
    end

    local x,y = vsx-300, vsy-40
    local i = 0

    if (profile_unsynced) then
      for gname,tTime in pairs(totalTimes) do
        if (gname~="Profiler") then
          if maximum > 0 then
            gl.Rect(x+100-tTime/maximum*100, y+1-(12)*i, x+100, y+9-(12)*i)
          end
          gl.Text(gname, x+150, y-1-(12)*i, 10)
          --gl.Text(string.format('%.4f',tTime).."s", x+105, y-1-(12)*i, 10)
          gl.Text(string.format('%.3f%%',(tTime/runTime)*100), x+105, y-1-(12)*i, 10)
          i = i+1
        end
      end

      gl.Text("total FPS cost", x+150, y-1-(12)*i, 10, 'n')
      gl.Text(string.format('%.1f%%',(allOverTime/runTime)*100), x+105, y-1-(12)*i, 10, 'n')
      gl.Color(1,1,1)
      i = i+1
    end


    if (profile_synced) then
      gl.Rect(x, y+5-(12)*i, x+230, y+4-(12)*i)
      gl.Color(1,0,0)   
      gl.Text("SYNCED", x+115, y-3-(12)*i, 12, "nOc")
      i=i+1

      gl.Color(1,1,1)
      for gname,tTime in pairs(totalTimesSYNCED) do
        if (gname~="Profiler") then
          if maximum > 0 then
            gl.Rect(x+100-tTime/maximum*100, y-(12)*i, x+100, y+8-(12)*i)
          end
          gl.Text(gname, x+150, y-3-(12)*i, 10)
          --gl.Text(string.format('%.4f',tTime).."s", x+105, y-2-(12)*i, 10)
          gl.Text(string.format('%.3f%%',(tTime/runTimeSYNCED)*100), x+105, y-1-(12)*i, 10)
          i = i+1
        end
      end

      gl.Text("total FPS cost", x+150, y-1-(12)*i, 10, 'n')
      gl.Text(string.format('%.1f%%',(allOverTimeSYNCED/runTimeSYNCED)*100), x+105, y-1-(12)*i, 10, 'n')
      gl.Color(1,1,1)
    end

  end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------