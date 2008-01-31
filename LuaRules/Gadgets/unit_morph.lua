--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_morph.lua
--  brief:   Adds unit morphing command
--  author:  Dave Rodgers improved by jK
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "UnitMorph",
    desc      = "Adds unit morphing",
    author    = "trepan and jK and Licho",
    date      = "Apr 24, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Proposed Command ID Ranges:
--
--    all negative:  Engine (build commands)
--       0 -   999:  Engine
--    1000 -  9999:  Group AI
--   10000 - 19999:  LuaUI
--   20000 - 29999:  LuaCob
--   30000 - 39999:  LuaRules
--


local CMD_MORPH = 31213



--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
function GetTechLevel(UnitDefID)
  --return UnitDefs[UnitDefID].techLevel or 0
  local cats = UnitDefs[UnitDefID].modCategories
  if (cats) then
    -- bugfix, cuz lua don't remove uppercase :(
    if     (cats["LEVEL1"]) then return 1
    elseif (cats["LEVEL2"]) then return 2
    elseif (cats["LEVEL3"]) then return 3
      elseif (cats["level1"]) then return 1
      elseif (cats["level2"]) then return 2
      elseif (cats["level3"]) then return 3
    end
  end
  return 0
end


function isFactory(UnitDefID)
  return UnitDefs[UnitDefID].isFactory or false
end


function isFinished(UnitID)
  local _,_,_,_,buildProgress = Spring.GetUnitHealth(UnitID)
  return (buildProgress==nil)or(buildProgress>=1)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

-- 75b2 compability (removed it in the next release)
if (Spring.SetUnitLineage==nil) then
  Spring.SetUnitLineage = function() end
end
include("LuaRules/colors.h.lua")


local morphDefs = {}
local morphUnits = {} -- make it global in Initialize()

local stopPenalty  = 0.0
local morphPenalty = 1.0

local upgradingBuildSpeed = 250

local XpScale = 0.50

local devolution = true -- remove upgrade capabilities after factory destruction?
local stopMorphOnDevolution = true -- should morphing stop during devolution

-- per team techlevel table
local teamTechLevel = {}
local allyList = Spring.GetAllyTeamList()
for _,allyID in ipairs(allyList) do
  local teamList = Spring.GetTeamList(allyID)
  for _,teamID in ipairs(teamList) do
    teamTechLevel[teamID] = 0
  end
end

local morphCmdDesc = {
  id     = CMD_MORPH,
  type   = CMDTYPE.ICON,
  name   = 'Morph',
  cursor = 'Morph',  -- add with LuaUI?
  action = 'morph',
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- translate lowercase UnitNames to real unitname (with upper-/lowercases)
local defNamesL = {}
for defName in pairs(UnitDefNames) do
  defNamesL[string.lower(defName)] = defName
end

local function DefCost(paramName, udSrc, udDst)
  local pSrc = udSrc[paramName]
  local pDst = udDst[paramName]
  if ((not pSrc) or (not pDst) or
      (type(pSrc) ~= 'number') or
      (type(pDst) ~= 'number')) then
    return 0
  end
  local cost = (pDst - pSrc) * morphPenalty
  if (cost < 0) then
    cost = 0
  end
  return math.floor(cost)
end


local function ValidateMorphDefs(mds)
  local newDefs = {}
  for src,morphData in pairs(mds) do
    local udSrc = UnitDefNames[defNamesL[string.lower(src)] or -1]
    local udDst = UnitDefNames[defNamesL[string.lower(morphData.into)] or -1]
    if (not udSrc) then
      Spring.Echo('Morph gadget: Bad morph src type: ' .. src)
    end
    if (not udDst) then
      Spring.Echo('Morph gadget: Bad morph dst type: ' .. morphData.into)
    end
    if (udSrc and udDst) then
      local unitDef = UnitDefs[udSrc.id]
      local newData = {}
      newData.into = udDst.id
      newData.time = morphData.time or math.floor(unitDef.buildTime*10/upgradingBuildSpeed)
      newData.increment = (1 / (30 * newData.time))
      newData.metal  = morphData.metal  or DefCost('metalCost',  udSrc, udDst)
      newData.energy = morphData.energy or DefCost('energyCost', udSrc, udDst)
      newData.resTable = {
        m = (newData.increment * newData.metal),
        e = (newData.increment * newData.energy)
      }
      newData.tech = morphData.tech or 0
      newData.xp   = morphData.xp or 0
      newDefs[udSrc.id] = newData
    end
  end
  return newDefs
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function GetMorphToolTip(unitID, morphDef,teamTech,unitXP)
  local ud = UnitDefs[morphDef.into]
  local tt = ''
  tt = tt .. WhiteStr  .. 'Deploy into ' .. ud.humanName .. '\n'
  tt = tt .. GreenStr  .. 'Time: '   .. morphDef.time     .. '\n'
  tt = tt .. CyanStr   .. 'Metal: '  .. morphDef.metal    .. '\n'
  tt = tt .. YellowStr .. 'Energy: ' .. morphDef.energy   .. '\n'
  if (morphDef.tech>teamTech) or (morphDef.xp>unitXP) then
    tt = tt .. RedStr .. 'needs'
    if (morphDef.tech>teamTech) then tt = tt .. ' level: ' .. morphDef.tech  end
    if (morphDef.xp>unitXP)     then tt = tt .. ' xp: ' .. string.format('%.2f',morphDef.xp) end
  end
  return tt
end


local function AddMorphCmdDesc(unitID, morphDef, teamTech)
  local unitXP = Spring.GetUnitExperience(unitID)

  morphCmdDesc.tooltip = GetMorphToolTip(unitID, morphDef,0,0)
  morphCmdDesc.texture = "#" .. morphDef.into --only works with a patched layout.lua! :(
  morphCmdDesc.disabled= (morphDef.tech > teamTech)or(morphDef.xp > unitXP)
  Spring.InsertUnitCmdDesc(unitID, morphCmdDesc)
  morphCmdDesc.tooltip = nil
  morphCmdDesc.texture = nil
end


local function UpdateMorphPossibilities(teamID)
  local teamTech = teamTechLevel[teamID] or 0

  local units = Spring.GetTeamUnitsSorted(teamID)
  for unitDefID,unitIDs in pairs(units) do
    local morphDef     = morphDefs[unitDefID]

    if (morphDef) then
      for _,unitID in ipairs(unitIDs) do
        local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH)
        if (cmdDescID) then

          local unitXP = Spring.GetUnitExperience(unitID)
          local morphCmdDesc = {}
          morphCmdDesc.disabled = (morphDef.tech > teamTech)or(morphDef.xp > unitXP)
          morphCmdDesc.tooltip  = GetMorphToolTip(unitID, morphDef, teamTech, unitXP)
          Spring.EditUnitCmdDesc(unitID, cmdDescID, morphCmdDesc)

        end
      end
    end
  end
end


--------------------------------------------------------------------------------

local function StartMorph(unitID, morphDef)
  -- paralyze the unit
  Spring.SetUnitHealth(unitID, { paralyze = 1.0e9 })    -- turns mexes and mm off
  Spring.SetUnitResourcing(unitID,"e",0)                -- turns solars off
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 0 }, { }) -- turns radars/jammers off

  morphUnits[unitID] = {
    def = morphDef,
    progress = 0.0,
    increment = morphDef.increment
   }
end


local function StopMorph(unitID, morphData)
  morphUnits[unitID] = nil

  Spring.SetUnitHealth(unitID, { paralyze = -1})
  local scale = morphData.progress * stopPenalty
  local unitDefID = Spring.GetUnitDefID(unitID)

  Spring.SetUnitResourcing(unitID,"e", UnitDefs[unitDefID].energyMake)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 1 }, { })
  local usedMetal  = morphData.def.metal  * scale
  Spring.AddUnitResource(unitID, 'metal',  usedMetal)
  --local usedEnergy = morphData.def.energy * scale
  --Spring.AddUnitResource(unitID, 'energy', usedEnergy)
end


local function FinishMorph(unitID, morphData)
  local udSrc = Spring.GetUnitDefID(unitID)
  local udDst = UnitDefs[morphData.def.into]
  local defName = udDst.name
  local unitTeam = Spring.GetUnitTeam(unitID)
  local px, py, pz = Spring.GetUnitBasePosition(unitID)
  Spring.SetUnitBlocking(unitID, false)
  morphUnits[unitID] = nil

  local newUnit = Spring.CreateUnit(defName, px, py, pz, 0, unitTeam)
  local h = Spring.GetUnitHeading(unitID)
  Spring.SetUnitRotation(newUnit, 0, -h * math.pi / 32768, 0)

  --copy experience
  local newXp = Spring.GetUnitExperience(unitID)*XpScale
  local nextMorph = morphDefs[morphData.def.into]
  if (nextMorph) then
    newXp = math.min( newXp, nextMorph.xp*0.9)
  end
  Spring.SetUnitExperience(newUnit, Spring.GetUnitExperience(unitID)*XpScale)

  --copy command queue
  local cmds = Spring.GetUnitCommands(unitID)
  for i = 2, cmds.n do  -- skip the first command (CMD_MORPH)
    local cmd = cmds[i]
    Spring.GiveOrderToUnit(newUnit, cmd.id, cmd.params, cmd.options.coded)
  end

  -- copy some state
  local states = Spring.GetUnitStates(unitID)
  Spring.GiveOrderArrayToUnitArray({ newUnit }, {
    { CMD.FIRE_STATE, { states.firestate },             {} },
    { CMD.MOVE_STATE, { states.movestate },             {} },
    { CMD.REPEAT,     { states['repeat']  and 1 or 0 }, {} },
    { CMD.CLOAK,      { states.cloak      and 1 or 0 }, {} },
    { CMD.ONOFF,      { 1 }, {} },
    { CMD.TRAJECTORY, { states.trajectory and 1 or 0 }, {} },
  })

--[[
  local oldHealth = Spring.GetUnitHealth(unitID)
  local newHealth = oldHealth * (udDst.maxHealth / udSrc.maxHealth)
  Spring.SetUnitHealth(newUnit, newHealth)
--]]

  local lineage = Spring.GetUnitLineage(unitID)
  Spring.SetUnitLineage(newUnit,lineage,true)

  -- FIXME: - re-attach to current transport?
  -- update selection
  SendToUnsynced("unit_morph", unitID, newUnit)

  Spring.SetUnitBlocking(newUnit, true)
  Spring.DestroyUnit(unitID, false, true) -- selfd = false, reclaim = true
end


local function UpdateMorph(unitID, morphData)
  if (Spring.UseUnitResource(unitID, morphData.def.resTable)) then
    morphData.progress = morphData.progress + morphData.increment
  end
  if (morphData.progress >= 1.0) then
    FinishMorph(unitID, morphData)
    return false -- remove from the list, all done
  end
  return true
end



--------------------------------------------------------------------------------

function gadget:Initialize()
  --[[
  if Spring.IsReplay() then
    gadgetHandler:RemoveGadget()
    return    
  end
  --]]

  _G.morphUnits = morphUnits  -- make it global for unsynced access via SYNCED
  -- get the morphDefs
  morphDefs = include("LuaRules/Configs/morph_defs.lua")
  if (not morphDefs) then
    gadgetHandler:RemoveGadget()
    return
  end
  gadgetHandler:RegisterCMDID(CMD_MORPH)

  morphDefs = ValidateMorphDefs(morphDefs)

  -- add the Morph command to existing units
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local teamID    = Spring.GetUnitTeam(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    local morphDef  = morphDefs[unitDefID]
    if (morphDef) then
      local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH)
      if (not cmdDescID) then
        AddMorphCmdDesc(unitID, morphDef, teamTechLevel[teamID])
      end
    end
  end
end


function gadget:Shutdown()
  for _,unitID in ipairs(Spring.GetAllUnits()) do
    local morphData = morphUnits[unitID]
    if (morphData) then
      StopMorph(unitID, morphData)
    end
    local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH)
    if (cmdDescID) then
      Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
    end
  end
end


function gadget:UnitCreated(unitID, unitDefID, teamID)
  local morphDef = morphDefs[unitDefID]
  if (morphDef) then
    AddMorphCmdDesc(unitID, morphDef, teamTechLevel[teamID])
  end 
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  morphUnits[unitID] = nil
  RemoveFactory(unitID, unitDefID, teamID)	
end

function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
  AddFactory(unitID, unitDefID, teamID)
  self:UnitCreated(unitID, unitDefID, teamID)
end

function gadget:UnitGiven(unitID, unitDefID, newTeamID, teamID)
  RemoveFactory(unitID, unitDefID, teamID)
end


function AddFactory(unitID, unitDefID, teamID)
  if (isFactory(unitDefID)) then
    local unitTechLevel = GetTechLevel(unitDefID)
    if (unitTechLevel > teamTechLevel[teamID]) then
      teamTechLevel[teamID]=unitTechLevel
      UpdateMorphPossibilities(teamID)
    end
  end
end

function RemoveFactory(unitID, unitDefID, teamID)
  if (devolution)and(isFactory(unitDefID)) then
    -- check all factories and determine team level
    local level = 0
    for _,unitID2 in ipairs(Spring.GetTeamUnits(teamID)) do
      local unitDefID2 = Spring.GetUnitDefID(unitID2)
      if (isFactory(unitDefID2) and isFinished(unitDefID2) and (unitID2 ~= unitID)) then 
        local unitTechLevel = GetTechLevel(unitDefID2)
        if (unitTechLevel>level) then level = unitTechLevel end
      end
    end

    if (level ~= teamTechLevel[teamID]) then
      teamTechLevel[teamID] = level
      UpdateMorphPossibilities(teamID)

      if (stopMorphOnDevolution) then 
        for morphID, data in pairs(morphUnits) do 
          if (data.def.tech > level and Spring.GetUnitTeam(morphID) == teamID) then 
            StopMorph(morphID, data)
          end
        end
      end
    end

  end
end


function gadget:UnitFinished(unitID, unitDefID, teamID)
  AddFactory(unitID, unitDefID, teamID)
end


function gadget:GameFrame(n)
  if ((n+28) % 64)<1 then
    local teamIDs = Spring.GetTeamList()
    for _,teamID in ipairs(teamIDs) do
      UpdateMorphPossibilities(teamID)
    end
  end

  if (next(morphUnits) == nil) then
    return  -- no morphing units
  end
  local killUnits = {}
  for unitID, morphData in pairs(morphUnits) do
    if (not UpdateMorph(unitID, morphData)) then
      killUnits[unitID] = true
    end
  end
  for unitID in pairs(killUnits) do
    morphUnits[unitID] = nil
  end
end


function gadget:AllowCommand(unitID, unitDefID, teamID,
                             cmdID, cmdParams, cmdOptions)
  --do return true end -- FIXME ?
--  do
  if (cmdID == CMD_MORPH) then
    local morphDef = morphDefs[unitDefID]
    if ((morphDef) and (morphDef.tech<=teamTechLevel[teamID]) and (morphDef.xp<=Spring.GetUnitExperience(unitID))) then
      return true
    end
    return false
  end
  --return true
--  end

  local morphData = morphUnits[unitID]
  if (morphData) then
    if (cmdID == CMD.STOP) then
      StopMorph(unitID, morphData)
      morphUnits[unitID] = nil
    elseif (cmdID == CMD.ONOFF) then
      return false
    else
      return false
    end
  end
  return true
end


function gadget:CommandFallback(unitID, unitDefID, teamID,
                                cmdID, cmdParams, cmdOptions)
  if (cmdID ~= CMD_MORPH) then
    return false  -- command was not used
  end
  local morphDef = morphDefs[unitDefID]
  if (not morphDef) then
    return true, true  -- command was used, remove it
  end
  local morphData = morphUnits[unitID]
  if (not morphData) then
		StartMorph(unitID, morphDef)
		return true, true
  end
  return true, false  -- command was used, do not remove it
end

--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
else
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------


-- 75b2 compability (removed it in the next release)
if (Spring.GetTeamColor==nil) then
  Spring.GetTeamColor = function(teamID) local _,_,_,_,_,_,r,g,b = Spring.GetTeamInfo(teamID); return r,g,b end
end


--
-- speed-ups
--

local gameFrame;
local SYNCED = SYNCED

local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitHeading      = Spring.GetUnitHeading
local GetUnitBasePosition = Spring.GetUnitBasePosition
local GetGameFrame        = Spring.GetGameFrame
local GetSpectatingState  = Spring.GetSpectatingState
local AddWorldIcon        = Spring.AddWorldIcon
local AddWorldText        = Spring.AddWorldText
local IsUnitVisible       = Spring.IsUnitVisible
local GetLocalTeamID      = Spring.GetLocalTeamID

local glColor      = gl.Color
local glPushMatrix = gl.PushMatrix
local glTranslate  = gl.Translate
local glRotate     = gl.Rotate
local glUnitShape  = gl.UnitShape
local glPopMatrix  = gl.PopMatrix
local glBillboard  = gl.Billboard
local glText       = gl.Text
local glPushAttrib = gl.PushAttrib
local glPopAttrib  = gl.PopAttrib
local GL_COLOR_BUFFER_BIT = GL.COLOR_BUFFER_BIT

--------------------------------------------------------------------------------

local function SelectSwap(cmd, oldID, newID)
  local selUnits = Spring.GetSelectedUnits()
  for i, unitID in ipairs(selUnits) do
    if (unitID == oldID) then
      selUnits[i] = newID
      Spring.SelectUnitArray(selUnits)
      return true
    end
  end
  return true
end


function gadget:Initialize()
  gadgetHandler:AddSyncAction("unit_morph", SelectSwap)
end


function gadget:Shutdown()
  gadgetHandler:RemoveSyncAction("unit_morph")
end


local teamColors = {}
local function SetTeamColor(teamID,a)
  local color = teamColors[teamID]
  if (color) then
    color[4]=a
    glColor(color)
    return
  end
  local r, g, b = Spring.GetTeamColor(teamID)
  if (r and g and b) then
    color = { r, g, b }
    teamColors[teamID] = color
    glColor(color)
    return
  end
end



local function DrawMorphUnit(unitID, morphData, localTeamID)
  local h = GetUnitHeading(unitID)
  if (not h) then
    return  -- bonus, heading is only available when the unit is in LOS
  end
  local px,py,pz = GetUnitBasePosition(unitID)
  if (not px) then
    return
  end
  local unitTeam = GetUnitTeam(unitID)

  local frac = math.mod(gameFrame + unitID, 30) / 30
  local alpha = 2.0 * math.abs(0.5 - frac)
  --glColor(1.0, 1.0, 1.0, alpha*0.3)
  SetTeamColor(unitTeam,alpha)
  glPushMatrix()
  glTranslate(px, py, pz)
  glRotate(h * (360 / 65535), 0, 1, 0)
  glUnitShape(morphData.def.into, unitTeam)
  glPopMatrix()

  -- cheesy progress indicator
  if (localTeamID)and
     ((unitTeam==localTeamID)or(localTeamID==Script.ALL_ACCESS_TEAM))
  then
    glPushMatrix()
    glPushAttrib(GL_COLOR_BUFFER_BIT)
    glTranslate(px, py-20, pz)
    glBillboard()
    local progStr = string.format("%.1f%%", 100 * morphData.progress)
    gl.Text(progStr, 0, 0, 9, "oc")
    glPopAttrib()
    glPopMatrix()
  end
end




function gadget:DrawWorld()
  local morphUnits = SYNCED.morphUnits
  if ((not morphUnits) or (snext(morphUnits) == nil)) then
    return -- no morphs to draw
  end

  gameFrame = GetGameFrame()

  gl.Blending(GL.SRC_ALPHA, GL.ONE)
  gl.DepthTest(GL.LEQUAL)

  local spec, specFullView = GetSpectatingState()
  local readTeam
  if (specFullView) then
    readTeam = Script.ALL_ACCESS_TEAM
  else
    readTeam = GetLocalTeamID()
  end

  CallAsTeam({ ['read'] = readTeam }, function()
    for unitID, morphData in spairs(morphUnits) do
      if (unitID and morphData)and(IsUnitVisible(unitID)) then  -- FIXME: huh?
        DrawMorphUnit(unitID, morphData,readTeam)
      end
    end
  end)
  gl.DepthTest(false)
  gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
end



--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------
