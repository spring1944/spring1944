--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "CustomFormations_Meta",
    desc      = "Allows you to draw your own formation line when meta key is pressed.",
    author    = "gunblob, original by jK",
    date      = "Oct 15, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 10000,
    enabled   = false  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local gl = gl
local Spring = Spring

local formationVertices = {}
local totaldxy = 0  -- moved mouse distance 

local dimmVertices = {}
local alphaDimm = 1

local invertQueueKey = Spring.GetConfigInt("InvertQueueKey", 0)

local active = false
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:MousePress(x, y, button)
  local a,c,m,s = Spring.GetModKeyState()
  if (a or c or (not m)) then
    return false
  end

  local selcnt = Spring.GetSelectedUnitsCount()
  if (selcnt>1) then
    local idoffset,id,type,str = Spring.GetDefaultCommand()

    if (id==CMD.MOVE) then
      local units = Spring.GetSelectedUnits()
      units.n = nil

      -- check if there are moveable units selected
      local moveableUnits = false
      for _,unitID in ipairs(units) do
        local unitDefID = Spring.GetUnitDefID(unitID)
        if (UnitDefs[unitDefID].canMove) then moveableUnits = true; break; end
      end

      if (moveableUnits) then
        local mx,my,lb,mb,rb = Spring.GetMouseState()

        if (rb) then
          local _,pos = Spring.TraceScreenRay(mx,my,true)
          if (pos) then
            widgetHandler:UpdateCallIn("DrawWorld")
            table.insert(formationVertices,pos)
            totaldxy = 0
          end
          active = true
          return true
        end
      end
    end
  end

  return false
end


function widget:MouseMove(x, y, dx, dy, button)
  if not active then
    return false
  end

  if (#formationVertices>0) then
    local mx,my,lb,mb,rb = Spring.GetMouseState()

    totaldxy = totaldxy+dx^2+dy^2
    if (totaldxy>40)and(rb) then
      local _,pos = Spring.TraceScreenRay(mx,my,true)
      if (pos) then
        table.insert(formationVertices,pos)
        totaldxy = 0
      end
      return true
    end
  end

  return false
end


function widget:MouseRelease(x, y, button)
  if not active then
    return false
  end

  active = false

  -- create modkeystate list
  local alt, ctrl, meta, shift = Spring.GetModKeyState()
  local keyState = {}
  if alt   then table.insert(keyState,"alt")   end
  if ctrl  then table.insert(keyState,"ctrl")  end
  if meta  then table.insert(keyState,"meta")  end
  if (not inverseQueueKey and shift)or(inverseQueueKey and not shift) then table.insert(keyState,"shift") end

  -- single click? (no line drawn)
  if (#formationVertices==1) then
    Spring.GiveOrder(CMD.MOVE, formationVertices[1], keyState)
    formationVertices = {}
    return -1
  end

  -- spread units out
  if (#formationVertices>0) then
    local units  = Spring.GetSelectedUnitsSorted()
    units.n = nil

    -- count moveable units
    local movunits = 0
    for unitDefID,unitIDs in pairs(units) do
      if (UnitDefs[unitDefID].canMove) then
        movunits = movunits + #unitIDs
      end
    end

    -- detect formation line length
    local formationLength = 0
    for i=2,#formationVertices do
      local lv = formationVertices[i-1]
      local v  = formationVertices[i]
      formationLength = formationLength + math.sqrt( (lv[1]-v[1])^2 + (lv[3]-v[3])^2 )
    end


    local unitdist = formationLength / (movunits-1)   -- movunits == 1 -> math.huge  , no segm ;)
    local idx,idxLength = 1,0

    -- send orders
    for unitDefID,unitIDs in pairs(units) do
      if (UnitDefs[unitDefID].canMove) then
        unitIDs.n = nil
        for _,unitID in ipairs(unitIDs) do
          local pos = formationVertices[idx]
          Spring.GiveOrderToUnit(unitID, CMD.MOVE, pos, keyState)

          -- determine next unit order pos
          for i=idx+1,#formationVertices+1 do
            if (i>#formationVertices) then
              idx = #formationVertices
              break
            end
            local lv = formationVertices[i-1]
            local v  = formationVertices[i]
            local bfr_idxLength = idxLength + math.sqrt( (lv[1]-v[1])^2 + (lv[3]-v[3])^2 )
            if (unitdist<bfr_idxLength) then
              local fracLength = unitdist - idxLength
              local d = math.sqrt( (lv[1]-v[1])^2 + (lv[3]-v[3])^2 )
              local frac = fracLength/d

              -- add an in-between vertex
              table.insert(formationVertices,i,{lv[1]+frac*(v[1]-lv[1]),lv[2]+frac*(v[2]-lv[2]),lv[3]+frac*(v[3]-lv[3])})

              idxLength = 0
              idx = i
              break
            end
            if (unitdist==idxLength) then
              idxLength = 0
              idx = i
              break
            end
            idxLength = bfr_idxLength
          end

        end
      end
    end

    dimmVertices = formationVertices
    alphaDimm = 1
    formationVertices = {}
  end
  
  return -1
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function widget:DrawWorld()
  if (#formationVertices<1)and(#dimmVertices<1) then
    widgetHandler:RemoveCallIn("DrawWorld")
  end

  -- draw the lines
  gl.LineStipple(2, 4095)
  gl.LineWidth(2.0)

  gl.Color(0.5,1,0.5)
  gl.BeginEnd(GL.LINE_STRIP, function(vertices)
    for _,v in ipairs(vertices) do
      gl.Vertex(v[1],v[2],v[3])
    end
  end, formationVertices)

  if (#dimmVertices>1) then
    gl.Color(0.5,1,0.5,alphaDimm)
    gl.BeginEnd(GL.LINE_STRIP, function(vertices)
      for _,v in ipairs(vertices) do
        gl.Vertex(v[1],v[2],v[3])
      end
    end, dimmVertices)
    alphaDimm = alphaDimm - 0.03
    if (alphaDimm<=0) then dimmVertices = {} end
  end

  gl.Color(1,1,1,1)
  gl.LineWidth(1.0)
  gl.LineStipple(false)
end
