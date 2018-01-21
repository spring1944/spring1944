-- $Id: unit_morph.lua 4651 2009-05-23 17:04:46Z carrepairer $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_morph.lua
--  brief:   Adds unit morphing command
--  author:  Dave Rodgers (improved by jK, Licho and aegis)
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
    author    = "trepan (improved by jK, Licho, aegis, CarRepairer, adapted to S44 by yuritch, Tobi, FLOZi, Nemo, ashdnazg)",
    date      = "Jan, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

-- Changes for "The Cursed"
--		CarRepairer: may add a customized texture in the morphdefs, otherwise uses original behavior (unit buildicon and the word Morph). Break changes made in CA.
--		aZaremoth: may add a customized text in the morphdefs


local MAX_MORPH = 0 --// will increase dynamically


--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------

--[[ // for use with any mod -_-
function GetTechLevel(udid)
  local ud = UnitDefs[udid];
  return (ud and ud.techLevel) or 0
end
]]--

-- // for use with mods like CA <_<
local function GetTechLevel(UnitDefID)
  --return UnitDefs[UnitDefID].techLevel or 0
  local cats = UnitDefs[UnitDefID].modCategories
  if (cats) then
    --// bugfix, cuz lua don't remove uppercase :(
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

local function isFactory(UnitDefID)
  return UnitDefs[UnitDefID].isFactory or false
end


local function isFinished(UnitID)
  local _,_,_,_,buildProgress = Spring.GetUnitHealth(UnitID)
  return (buildProgress==nil)or(buildProgress>=1)
end

local function HeadingToFacing(heading)
	--return math.floor((-heading - 24576) / 16384) % 4
	return math.floor(((heading + 8192) / 16384) % 4)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------

local CMD_MORPH = GG.CustomCommands.GetCmdID("CMD_MORPH")
local CMD_MORPH_STOP = GG.CustomCommands.GetCmdID("CMD_MORPH_STOP")
local CMD_FAKE_FIRE_STATE = GG.CustomCommands.GetCmdID("CMD_FAKE_FIRE_STATE")

include("LuaRules/colors.h.lua")

local stopPenalty  = 0.0
local morphPenalty = 1.0
local upgradingBuildSpeed = 250
local XpScale = 1

local XpMorphUnits = {}

local devolution = true            --// remove upgrade capabilities after factory destruction?
local stopMorphOnDevolution = true --// should morphing stop during devolution

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local isAMorphCmdID = {} --used to determine if a morph command was received


local morphDefs  = {} --// make it global in Initialize()
local extraUnitMorphDefs = {} -- stores mainly planetwars morphs
local morphUnits = {} --// make it global in Initialize()
local reqDefIDs  = {} --// all possible unitDefID's, which are used as a requirement for a morph
local morphToStart = {} -- morphes to start next frame
local postMorphSpawns = {} -- unitID => postMorphData, until https://springrts.com/mantis/view.php?id=5862 change anything

local upgradeDefs = {} -- mapping between the auto generated units and the morph defs.
local upgradeUnits = {} -- similar to morphUnits, all factories being upgraded at the moment. made global in Initialize()

--// per team techlevel and owned MorphReq. units table
local teamTechLevel = {}
local teamReqUnits  = {}
local teamList = Spring.GetTeamList()
for i=1,#teamList do
  local teamID = teamList[i]
  teamReqUnits[teamID]  = {}
  teamTechLevel[teamID] = 0
end

local morphCmdDesc = {
--  id     = CMD_MORPH, -- added by the calling function because there is now more than one option
  type   = CMDTYPE.ICON,
  name   = 'Deploy',
  --cursor = 'Deploy',  -- add with LuaUI?
  cursor = 'Fight',
  action = 'deploy',
}

--// will be replaced in Initialize()
local RankToXp    = function() return 0 end
local GetUnitRank = function() return 0 end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local getSideName = VFS.Include("LuaRules/Includes/sides.lua")

--// translate lowercase UnitNames to real unitname (with upper-/lowercases)
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


local function HideFakeUnits(unitID, morphDef)
    local UnitCmdDesc = Spring.FindUnitCmdDesc(unitID,-morphDef.upgradeUnit)
    Spring.EditUnitCmdDesc(unitID,UnitCmdDesc,{hidden=true})
end

local function BuildMorphDef(udSrc, morphData)
  local udDst = UnitDefNames[defNamesL[string.lower(morphData.into)] or -1]
  if (not udDst) then
    Spring.Log('morph gadget', 'error', 'Bad morph dst type: ' .. morphData.into)
    return
  else
    local unitDef = udDst
    local newData = {}
    newData.into = udDst.id
    newData.time = morphData.time or math.floor(unitDef.buildTime*7/upgradingBuildSpeed)
    newData.increment = (1 / (30 * newData.time))
    newData.metal  = morphData.metal  or DefCost('metalCost',  udSrc, udDst)
    newData.energy = morphData.energy or DefCost('energyCost', udSrc, udDst)
    newData.resTable = {
      m = (newData.increment * newData.metal),
      e = (newData.increment * newData.energy)
    }
    newData.tech = morphData.tech or 0
    newData.xp   = morphData.xp or 0
    newData.rank = morphData.rank or 0
    newData.facing = morphData.facing
    newData.directional = morphData.directional
	newData.name = morphData.name
    local require = -1
    if (morphData.require) then
      require = (UnitDefNames[defNamesL[string.lower(morphData.require)] or -1] or {}).id
      if (require) then
        reqDefIDs[require]=true
      else
        Spring.Log('morph gadget', 'error', 'Morph gadget: Bad morph requirement: ' .. morphData.require)
        require = -1
      end
    end
    newData.require = require

    --newData.cmd     = CMD_MORPH      + MAX_MORPH
	newData.cmd = GG.CustomCommands.GetCmdID("CMD_MORPH_" .. newData.into)
    if udSrc.isFactory then
		local tmpSide = getSideName(udSrc.name)
        newData.upgradeUnit = UnitDefNames[tmpSide .. "_morph_" .. udSrc.name .. "_" .. morphData.into].id
        upgradeDefs[newData.upgradeUnit] = newData
    end
	isAMorphCmdID[newData.cmd] = true
    --newData.stopCmd = CMD_MORPH_STOP + MAX_MORPH
	newData.stopCmd = GG.CustomCommands.GetCmdID("CMD_MORPH_STOP_" .. newData.into)
	isAMorphCmdID[newData.stopCmd] = true

    MAX_MORPH = MAX_MORPH + 1
    if (type(GG.MorphInfo)~="table") then GG.MorphInfo = {} end
    GG.MorphInfo["MAX_MORPH"] = MAX_MORPH * 2

	newData.texture = morphData.texture
	newData.text = morphData.text
    return newData
  end
end

local function ValidateMorphDefs(mds)
  local newDefs = {}
  for src,morphData in pairs(mds) do
    local udSrc = UnitDefNames[defNamesL[string.lower(src)] or -1]
    if (not udSrc) then
      Spring.Log('morph gadget', 'error', 'Bad morph src type: ' .. src)
    else
      newDefs[udSrc.id] = {}
      if (morphData.into) then
        local morphDef = BuildMorphDef(udSrc, morphData)
        if (morphDef) then 
          newDefs[udSrc.id][morphDef.cmd] = morphDef 
          newDefs[udSrc.id][morphDef.stopCmd] = morphDef 
        end
      else
        for _,morphData in pairs(morphData) do
          local morphDef = BuildMorphDef(udSrc, morphData)
          if (morphDef) then 
            newDefs[udSrc.id][morphDef.cmd] = morphDef 
            newDefs[udSrc.id][morphDef.stopCmd] = morphDef 
          end
        end
      end
    end
  end
  return newDefs
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function UnitReqCheck(teamID, reqUnit)
  if (reqUnit==-1) then return true end

  return ((teamReqUnits[teamID][reqUnit] or 0) > 0)
end

local function GetMorphToolTip(unitID, unitDefID, teamID, morphDef, teamTech, unitXP, unitRank, teamOwnsReqUnit)
  local ud = UnitDefs[morphDef.into]
  local tt = ''
  if (morphDef.text ~= nil) then
	tt = tt .. WhiteStr  .. morphDef.text .. '\n'
  else
  	--tt = tt .. WhiteStr  .. 'Deploy into a ' .. ud.humanName .. '\n'
  	tt = tt .. 'Deploy into a ' .. ud.humanName .. '\n'
  end
  if (morphDef.time > 0) then
  	tt = tt .. GreenStr  .. 'time: '   .. morphDef.time     .. '\n'
  end	
  if (morphDef.metal > 0) then
  	tt = tt .. CyanStr   .. 'metal: '  .. morphDef.metal    .. '\n'
  end
  if (morphDef.energy > 0) then
    tt = tt .. YellowStr .. 'energy: ' .. morphDef.energy   .. '\n'
  end
  if (morphDef.tech > teamTech) or
     (morphDef.xp > unitXP) or
     (morphDef.rank > unitRank) or
     (not teamOwnsReqUnit)
  then
    tt = tt .. RedStr .. 'needs'
    if (morphDef.tech>teamTech) then tt = tt .. ' level: ' .. morphDef.tech end
    if (morphDef.xp>unitXP)     then tt = tt .. ' xp: '    .. string.format('%.2f',morphDef.xp) end
    if (morphDef.rank>unitRank) then tt = tt .. ' rank: '  .. morphDef.rank .. ' (' .. string.format('%.2f',RankToXp(unitDefID,morphDef.rank)) .. 'xp)' end
    if (not teamOwnsReqUnit)	then tt = tt .. ' unit: '  .. UnitDefs[morphDef.require].humanName end
  end
  return tt
end

local function UpdateMorphReqs(teamID)
  local morphCmdDesc = {}

  local teamTech  = teamTechLevel[teamID] or 0
  local teamUnits = Spring.GetTeamUnits(teamID)
  for n=1,#teamUnits do
    local unitID   = teamUnits[n]
    local unitXP   = Spring.GetUnitExperience(unitID)
    local unitRank = GetUnitRank(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    local morphDefs = morphDefs[unitDefID] or {}

    for _,morphDef in pairs(morphDefs) do
      local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
      if (cmdDescID) then
        local teamOwnsReqUnit = UnitReqCheck(teamID,morphDef.require)
        morphCmdDesc.disabled = (morphDef.tech > teamTech)or(morphDef.rank > unitRank)or(morphDef.xp > unitXP)or(not teamOwnsReqUnit)
        morphCmdDesc.tooltip  = GetMorphToolTip(unitID, unitDefID, teamID, morphDef, teamTech, unitXP, unitRank, teamOwnsReqUnit)
        Spring.EditUnitCmdDesc(unitID, cmdDescID, morphCmdDesc)
      end
    end
  end
end

local function AddMorphCmdDesc(unitID, unitDefID, teamID, morphDef, teamTech)
  local unitXP   = Spring.GetUnitExperience(unitID)
  local unitRank = GetUnitRank(unitID)
  local teamOwnsReqUnit = UnitReqCheck(teamID,morphDef.require)
  morphCmdDesc.tooltip = GetMorphToolTip(unitID, unitDefID, teamID, morphDef, teamTech, unitXP, unitRank, teamOwnsReqUnit)
  morphCmdDesc.name = morphDef.name or "Deploy"
  if morphDef.texture then
	morphCmdDesc.texture = "LuaRules/Images/Morph/".. morphDef.texture
	morphCmdDesc.name = ''
  else
	morphCmdDesc.texture = "#" .. morphDef.into   --//only works with a patched layout.lua or the TweakedLayout widget!
  end
  
  
  morphCmdDesc.disabled= (morphDef.tech > teamTech)or(morphDef.rank > unitRank)or(morphDef.xp > unitXP)or(not teamOwnsReqUnit)
  if morphDef.directional then
    morphCmdDesc.type = CMDTYPE.ICON_MAP
  end

  morphCmdDesc.id = morphDef.cmd

  local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
  if (cmdDescID) then
    Spring.EditUnitCmdDesc(unitID, cmdDescID, morphCmdDesc)
  else
    Spring.InsertUnitCmdDesc(unitID, morphCmdDesc)
  end

  morphCmdDesc.tooltip = nil
  morphCmdDesc.texture = nil
  morphCmdDesc.text = nil
  morphCmdDesc.type = CMDTYPE.ICON
end


local function AddExtraUnitMorph(unitID, unitDef, teamID, morphDef)  -- adds extra unit morph (planetwars morphing)
	morphDef = BuildMorphDef(unitDef, morphDef)
	extraUnitMorphDefs[unitID] = morphDef
	AddMorphCmdDesc(unitID, unitDef.id, teamID, morphDef, 0)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function StartMorph(unitID, unitDefID, teamID, morphDef, cmdParams)
	--[[if (UnitDefs[unitDefID].transportCapacity > 0) then
		local unitid_x_coord, unitid_y_coord, unitid_z_coord = Spring.GetUnitPosition(unitID)
		Spring.GiveOrderToUnit(unitID, CMD.UNLOAD_UNITS, { unitid_x_coord, unitid_y_coord, unitid_z_coord, 50 }, {})
	end
	if (UnitDefs[unitDefID].transportCapacity == nil) or (UnitDefs[unitDefID].transportCapacity <= 0) then]]--

  if morphDef.directional and cmdParams then
    local tx, _, tz = cmdParams[1] or 0, cmdParams[2], cmdParams[3] or 0
    local ux, _, uz = Spring.GetUnitPosition(unitID)
    local dx, dz = tx - ux, tz - uz
    local rotation = math.atan2(dx, dz)
    Spring.SetUnitRotation(unitID, 0, -rotation, 0) --SetUnitRotation uses left-handed convention
  end
  -- do not allow morph for unfinsihed units
  if not isFinished(unitID) then return true end

  Spring.SetUnitHealth(unitID, { paralyze = 1.0e9 })    --// turns mexes and mm off (paralyze the unit)
  Spring.MoveCtrl.Enable(unitID)
  Spring.SetUnitRulesParam(unitID, "movectrl", 1)
  --Spring.SetUnitResourcing(unitID,"e",0)                --// turns solars off
  --Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 0 }, { "alt" }) --// turns radars/jammers off
  Spring.GiveOrderToUnit(unitID, CMD.STOP, {}, { "alt" })
  morphUnits[unitID] = {
    def = morphDef,
    progress = 0.0,
    increment = morphDef.increment,
    morphID = morphID,
    teamID = teamID,
  }

  local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
  if (cmdDescID) then
    Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=morphDef.stopCmd, name=RedStr.."Stop", type = CMDTYPE.ICON})
  end

  SendToUnsynced("unit_morph_start", unitID, unitDefID, morphDef.cmd)
end


local function StopMorph(unitID, morphData)
  morphUnits[unitID] = nil

  Spring.SetUnitHealth(unitID, { paralyze = -1})
  local scale = morphData.progress * stopPenalty
  local unitDefID = Spring.GetUnitDefID(unitID)

  Spring.SetUnitResourcing(unitID,"e", UnitDefs[unitDefID].energyMake)
  Spring.GiveOrderToUnit(unitID, CMD.ONOFF, { 1 }, { "alt" })
  local usedMetal  = morphData.def.metal  * scale
  Spring.AddUnitResource(unitID, 'metal',  usedMetal)
  --local usedEnergy = morphData.def.energy * scale
  --Spring.AddUnitResource(unitID, 'energy', usedEnergy)

  SendToUnsynced("unit_morph_stop", unitID)
  Spring.MoveCtrl.Disable(unitID)
  Spring.SetUnitRulesParam(unitID, "movectrl", 0)
  -- try to prevent unit flying away by giving a move order to the current position
  -- can the thing move?
  if (UnitDefs[unitDefID].speed or 0) > 0 then
    local unitid_x_coord, unitid_y_coord, unitid_z_coord = Spring.GetUnitPosition(unitID)
    Spring.GiveOrderToUnit(unitID, CMD.MOVE, { unitid_x_coord, unitid_y_coord, unitid_z_coord,  }, { "alt" })
  end

  local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphData.def.stopCmd)
  local newType
  if morphData.def.directional then
    newType = CMDTYPE.ICON_MAP
  end
  if (cmdDescID) then
    Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=morphData.def.cmd, name=(morphData.def.name or "Deploy"), type = newType })
  end
end

--[[
following function new logic:

* GET info1
* GET info2
* ...
* GET infoN

* UNLOAD units from transport

* DELETE unit
* pack all to new morphData

spawning moved away and works next way: 

* call CreateMorphedUnit(morphData) in next frame once unitID is unblocked by the engine
* CREATE "newUnitID" with same "unitID"

* SET info1
* SET info2
* ...
* SET infoN

]]--

local function FinishMorph(unitID, morphData)
  local unitDefAfterMorph = UnitDefs[morphData.def.into]
  local unitDefBeforeMorph = UnitDefs[Spring.GetUnitDefID(unitID)]
  local unitDefNameAfterMorph = unitDefAfterMorph.name
  local unitTeam = morphData.teamID
  local px, py, pz = Spring.GetUnitBasePosition(unitID)
  local h = Spring.GetUnitHeading(unitID)
  local unitDefIDBeforeMorph = Spring.GetUnitDefID(unitID)
  Spring.SetUnitBlocking(unitID, false)
  morphUnits[unitID] = nil
  upgradeUnits[unitID] = nil

  -- GET health
  local oldHealth, oldMaxHealth, paralyzeDamage, captureProgress, buildProgress = Spring.GetUnitHealth(unitID)
  local isBeingBuilt = false
  if buildProgress < 1 then
    isBeingBuilt = true
  end
  
  -- GET position, rotation, etc.
  local x, y, z, face, xsize, zsize  
  if unitDefAfterMorph.speed == 0 and unitDefAfterMorph.isBuilder or unitDefNameAfterMorph == "russtorage" then
  --if unitDefAfterMorph.isBuilding then
	x = math.floor(px/16)*16
	y = py
	z = math.floor(pz/16)*16
	face = HeadingToFacing(h)
	xsize = unitDefAfterMorph.xsize
	zsize =(unitDefAfterMorph.zsize or unitDefAfterMorph.ysize)
	
	if ((face == 1) or(face == 3)) then
	  xsize, zsize = zsize, xsize
	end	
	if xsize/4 ~= math.floor(xsize/4) then
	  x = x+8
	end
	if zsize/4 ~= math.floor(zsize/4) then
	  z = z+8
	end	
  end
  
  -- GET ammo and weapon state
  local ammoLevel
  if (unitDefAfterMorph.customParams.maxammo) then
	ammoLevel = Spring.GetUnitRulesParam(unitID, "ammo") or 0
  end
  
  -- GET experience and related morph stuff
  local newXp = Spring.GetUnitExperience(unitID)*XpScale
  local nextMorph = morphDefs[morphData.def.into]
  if nextMorph~= nil and nextMorph.into ~= nil then nextMorph = {morphDefs[morphData.def.into]} end
  if (nextMorph) then --//determine the lowest xp req. of all next possible morphs
    local maxXp = math.huge
	for _, nm in pairs(nextMorph) do
      local rankXpInto = RankToXp(nm.into,nm.rank)
      if (rankXpInto>0)and(rankXpInto<maxXp) then
        maxXp=rankXpInto
      end
      local xpInto     = nm.xp
      if (xpInto>0)and(xpInto<maxXp) then
        maxXp=xpInto
      end
    end
    newXp = math.min( newXp, maxXp*0.9)
  end
  
  -- GET states
  local states = Spring.GetUnitStates(unitID)  
  local fakeFireStateDescID = Spring.FindUnitCmdDesc(unitID, CMD_FAKE_FIRE_STATE)
  if fakeFireStateDescID then
    states.firestate = Spring.GetUnitCmdDescs(unitID, fakeFireStateDescID)[1].params[1]
  end
  
  -- GET command queue
  local cmds = Spring.GetUnitCommands(unitID, -1)
  
  -- GET build queue
  if unitDefAfterMorph.isFactory and unitDefBeforeMorph.isFactory then
	local buildQueue = Spring.GetFullBuildQueue(unitID)
  end 
  
  -- GET shield data
  local enabled, oldShieldState = Spring.GetUnitShieldState(unitID) 
  
  -- UNLOAD units so they don't die when the transport does
  local transportedUnits = Spring.GetUnitIsTransporting(unitID)
  if (transportedUnits and #transportedUnits > 0) then
    -- this is a quick hack for spawning them in a loose rectangle.
    -- we should really have some generalized API for 'spawn a bunch of units
    -- in some shape' that handles all the stuff about pathing/collision/etc.
    local spawnDistance = 15
    local spawnStart = -1 * (#transportedUnits / 2 * spawnDistance)
    for index, transportedUnitID in ipairs(transportedUnits) do
      local transportedDefID = Spring.GetUnitDefID(transportedUnitID)
      local transportedDef = UnitDefs[transportedDefID]
      local offsetSwitch = 1
      if index % 2 == 0 then
        offsetSwitch = -1
      end
      local zOffset = spawnStart + index * spawnDistance
      local xOffset = offsetSwitch * spawnDistance

      local absZ = math.abs(zOffset)
      if absZ >= 0 and absZ < (2 * spawnDistance) then
        xOffset = xOffset + (offsetSwitch * 2 * spawnDistance)
      end
	  
	  Spring.UnitDetach(transportedUnitID)
	  Spring.SetUnitPosition(px + xOffset, py, pz + zOffset)
    end
  end
  
  -- DESTROY UNIT
  Spring.DestroyUnit(unitID, false, true) -- selfd = false, reclaim = true
  
  -- passing data until https://springrts.com/mantis/view.php?id=5862 is fixed
  return {
    unitID = unitID,
    unitDefAfterMorph = unitDefAfterMorph,
    unitDefBeforeMorph = unitDefBeforeMorph,
    unitDefNameAfterMorph = unitDefNameAfterMorph,
    unitDefIDBeforeMorph = unitDefIDBeforeMorph,
    unitTeam = unitTeam,
	face = face,
    h = h,
    x = x,
    y = y,
    z = z,
    px = px,
    py = py,
    pz = pz,
    oldHealth = oldHealth,
    oldMaxHealth = oldMaxHealth,
    isBeingBuilt = isBeingBuilt,
    buildProgress = buildProgress,
    ammoLevel = ammoLevel,
    newXp = newXp,
    states = states,
    cmds = cmds,
    oldShieldState = oldShieldState,
  }
end

-- FIXME: MERGE functions once https://springrts.com/mantis/view.php?id=5862 is implemented
-- delayed function call of spawning part of the morphing to archive same unitIDs
-- can be merged with FinishMorph()
local function CreateMorphedUnit(postMorphData)
  local unitID = postMorphData.unitID
  local unitDefAfterMorph = postMorphData.unitDefAfterMorph
  local unitDefBeforeMorph = postMorphData.unitDefBeforeMorph
  local unitDefNameAfterMorph = postMorphData.unitDefNameAfterMorph
  local unitDefIDBeforeMorph = postMorphData.unitDefIDBeforeMorph
  local unitTeam = postMorphData.unitTeam
  local face = postMorphData.face
  local h = postMorphData.h  
  local x = postMorphData.x
  local y = postMorphData.y
  local z = postMorphData.z  
  local px = postMorphData.px
  local py = postMorphData.py
  local pz = postMorphData.pz
  local oldHealth = postMorphData.oldHealth
  local oldMaxHealth = postMorphData.oldMaxHealth
  local isBeingBuilt = postMorphData.isBeingBuilt
  local buildProgress = postMorphData.buildProgress
  local ammoLevel = postMorphData.ammoLevel
  local newXp = postMorphData.newXp
  local states = postMorphData.states
  local cmds = postMorphData.cmds
  local oldShieldState = postMorphData.oldShieldState
  
  -- NEW UNIT  
  local newUnitID
  
  -- SET position, rotation, etc. 
  if unitDefAfterMorph.speed == 0 and unitDefAfterMorph.isBuilder or unitDefNameAfterMorph == "russtorage" then
	newUnitID = Spring.CreateUnit(unitDefNameAfterMorph, x, y, z, face, unitTeam, isBeingBuilt, false, unitID)
	if newUnitID ~= nil then
	  Spring.SetUnitPosition(newUnitID, x, y, z)
	end
  else
	newUnitID = Spring.CreateUnit(unitDefNameAfterMorph, px, py, pz, HeadingToFacing(h), unitTeam, isBeingBuilt, false, unitID)
	if newUnitID ~= nil then
	  Spring.SetUnitRotation(newUnitID, 0, -h * math.pi / 32768, 0)
	  Spring.SetUnitPosition(newUnitID, px, py, pz)
	end
  end

  -- hit a unitLimit or something. bail out.
  -- PepeAmpere: I'm not aware of any reason why this should fail now but lets keep it here
  if newUnitID == nil then
    return
  end
  
  -- SO FROM NOW NEW UNIT ALREADY EXISTS
  
  -- disable physics
  Spring.SetUnitBlocking(newUnitID, false)  
  
  -- SET health
  local _, newMaxHealth = Spring.GetUnitHealth(newUnitID)
  local newHealth = (oldHealth / oldMaxHealth) * newMaxHealth
  local hpercent = newHealth/newMaxHealth
  if newHealth <= 1 then newHealth = 1 end

  -- prevent conflict with rezz gadget
  if hpercent > 0.045 and hpercent < 0.055 then
    newHealth = newMaxHealth * 0.056 + 1
  end

  Spring.SetUnitHealth(newUnitID, {health = newHealth, build = buildProgress})
  
  -- SET ammo and weapon state
  if (unitDefAfterMorph.customParams.maxammo) then
	Spring.SetUnitRulesParam(newUnitID, "ammo", ammoLevel)

	local weapon1 = UnitDefs[unitDefIDBeforeMorph].weapons[1]
	if (weapon1) then
		Spring.SetUnitRulesParam(newUnitID, "defRegen", tonumber(WeaponDefs[weapon1.weaponDef].reload))
	end
  end

  -- SET experience and related morph stuff
  Spring.SetUnitExperience(newUnitID, newXp)

  -- SET states
  Spring.GiveOrderArrayToUnitArray({newUnitID}, {
    {
		CMD.FIRE_STATE,
		{states.firestate}, 
		{}
	},
	{
		CMD_FAKE_FIRE_STATE, 
		{states.firestate}, 
		{}
	},
    {
		CMD.MOVE_STATE,
		{states.movestate},
		{}
	},
    {
		CMD.REPEAT,
		{states["repeat"] and 1 or 0},  
		{}
	},
    {
		CMD.CLOAK,
		{states.cloak and 1 or unitDefAfterMorph.initCloaked},
		{}
	},
    {
		CMD.ONOFF, 
		{1}, 
		{}
	},
    {
		CMD.TRAJECTORY,
		{states.trajectory and 1 or 0},
		{}
	},
  })

  -- SET command queue
  for i = 2, #cmds do -- skip the first command (CMD_MORPH)
    local cmd = cmds[i]
    Spring.GiveOrderToUnit(newUnitID, cmd.id, cmd.params, cmd.options.coded)
  end

  -- SET build queue
  if unitDefAfterMorph.isFactory and unitDefBeforeMorph.isFactory then
    local dstCanBuild = {}
    for _, unitDefID in ipairs(unitDefAfterMorph.buildOptions) do
      dstCanBuild[unitDefID] = true
    end  
  
    if buildQueue and dstCanBuild then
      for _,buildPair in ipairs(buildQueue) do
        local unitDefID, count = next(buildPair, nil)
        if dstCanBuild[unitDefID] then
          for i = 1, count do
            Spring.GiveOrderToUnit(newUnitID, CMD.INSERT, {-1,-unitDefID, 0}, {"ctrl", "alt"})
          end
        end
      end
    end
  end
  
  -- SET shield data
  if oldShieldState and Spring.GetUnitShieldState(newUnitID) then
    Spring.SetUnitShieldState(newUnitID, enabled, oldShieldState)
  end
  
  -- MISSING: re-attach loaded units - there are no morphing transports in s44

  -- INFORM unsynced
  SendToUnsynced("unit_morph_finished", unitID, newUnitID)
  
   -- enable physics
  Spring.SetUnitBlocking(newUnitID, true)
  
  return newUnitID
end

-- shared temporary API procedure for calls of FinishMorph from different places
local function FinishMorphGlobal(unitID, morphData)
  local postMorphData = FinishMorph(unitID, morphData)
  -- all below will be removed once https://springrts.com/mantis/view.php?id=5862 is implemented
  -- then FinishMorph and CreateMorphedUnit can be merged
  -- and FinishMorphGlobal can be removed at all
  postMorphSpawns[unitID] = {}
  for k,v in pairs(postMorphData) do
    postMorphSpawns[unitID][k] = v
  end
end

local function UpdateMorph(unitID, morphData)
  if Spring.GetUnitTransporter(unitID) then return true end
	
  if (Spring.UseUnitResource(unitID, morphData.def.resTable)) then
    morphData.progress = morphData.progress + morphData.increment
  end
  if (morphData.progress >= 1.0) then
	  FinishMorphGlobal(unitID, morphData)
	  return false -- remove from the list, all done
  end
  return true
end

-- all below will be removed once https://springrts.com/mantis/view.php?id=5862 is implemented
local function PostMorphCreate()
	local unitsMorphedSuccessfully = {}
	
	for unitID, postMorphData in pairs (postMorphSpawns) do
	  local newUnitID = CreateMorphedUnit(postMorphData)
      if (newUnitID ~= nil) then
	    unitsMorphedSuccessfully[#unitsMorphedSuccessfully + 1] = unitID
	  end
	end
	
	-- clear postmorhps for solved units
	for i=1, #unitsMorphedSuccessfully do
		postMorphSpawns[unitsMorphedSuccessfully[i]] = nil
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:Initialize()
  --// RankApi linking
  if (GG.rankHandler) then
    GetUnitRank = GG.rankHandler.GetUnitRank
    RankToXp    = GG.rankHandler.RankToXp
  end
  
  -- self linking for planetwars
  GG['morphHandler'] = {}
  GG['morphHandler'].AddExtraUnitMorph = AddExtraUnitMorph
  
  if (type(GG.UnitRanked)~="table") then GG.UnitRanked = {} end
  table.insert(GG.UnitRanked, UnitRanked)

  --// get the morphDefs
  morphDefs = include("LuaRules/Configs/morph_defs.lua")
  if (not morphDefs) then GG.RemoveGadget(self); return; end
  morphDefs = ValidateMorphDefs(morphDefs)

  --// make it global for unsynced access via SYNCED
  _G.morphUnits = morphUnits
  _G.upgradeUnits = upgradeUnits
  _G.morphDefs  = morphDefs
  _G.extraUnitMorphDefs  = extraUnitMorphDefs

  --// Register CmdIDs
  --done automatically by the customCmdHandler gadget
  --[[
  for number=0,MAX_MORPH-1 do
    gadgetHandler:RegisterCMDID(CMD_MORPH+number*2)
    gadgetHandler:RegisterCMDID(CMD_MORPH_STOP+number*2)
  end]]--


  --// check existing ReqUnits+TechLevel
  local allUnits = Spring.GetAllUnits()
  for i=1,#allUnits do
    local unitID    = allUnits[i]
    local unitDefID = Spring.GetUnitDefID(unitID)
    local teamID    = Spring.GetUnitTeam(unitID)
    if (reqDefIDs[unitDefID])and(isFinished(unitID)) then
      local teamReq = teamReqUnits[teamID]
      teamReq[unitDefID] = (teamReq[unitDefID] or 0) + 1
    end
    AddFactory(unitID, unitDefID, teamID)
  end

  --// add the Morph Menu Button to existing units
  for i=1,#allUnits do
    local unitID    = allUnits[i]
    local teamID    = Spring.GetUnitTeam(unitID)
    local unitDefID = Spring.GetUnitDefID(unitID)
    local morphDefSet  = morphDefs[unitDefID]
    if (morphDefSet) then
      local useXPMorph = false
      for _,morphDef in pairs(morphDefSet) do
        if (morphDef) then
          local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
          if (not cmdDescID) then
            AddMorphCmdDesc(unitID, unitDefID, teamID, morphDef, teamTechLevel[teamID])
          end
          if isFactory(unitDefID) then
            HideFakeUnits(unitID, morphDef)
          end
          useXPMorph = (morphDef.xp>0) or useXPMorph
        end
      end

      if (useXPMorph) then XpMorphUnits[#XpMorphUnits+1] = {id=unitID,defID=unitDefID,team=teamID} end
    end
  end

end


function gadget:Shutdown()
  for i,f in pairs(GG.UnitRanked or {}) do
    if (f==UnitRanked) then
      table.remove(GG.UnitRanked, i)
      break
    end
  end

  local allUnits = Spring.GetAllUnits()
  for i=1,#allUnits do
    local unitID    = allUnits[i]
    local morphData = morphUnits[unitID]
    if (morphData) then
      StopMorph(unitID, morphData)
    end
    for number=0,MAX_MORPH-1 do
      local cmdDescID = Spring.FindUnitCmdDesc(unitID, CMD_MORPH+number*2)
      if (cmdDescID) then
        Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
      end
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)
  local morphDefSet = morphDefs[unitDefID]
  if (morphDefSet) then
    local useXPMorph = false
    for _,morphDef in pairs(morphDefSet) do
      if (morphDef) then
    	AddMorphCmdDesc(unitID, unitDefID, teamID, morphDef, teamTechLevel[teamID])
        useXPMorph = (morphDef.xp>0) or useXPMorph
        if isFactory(unitDefID) then
            HideFakeUnits(unitID, morphDef)
        end
      end
    end
    if (useXPMorph) then XpMorphUnits[#XpMorphUnits+1] = {id=unitID,defID=unitDefID,team=teamID} end
  end
  
  local upgradeDef = upgradeDefs[unitDefID]
  if builderID and upgradeDef then
    local builderDefID = Spring.GetUnitDefID(builderID)
    FactoryStartUpgrade(builderID, builderDefID, teamID, upgradeDef, unitID)
    Spring.SetUnitNoSelect(unitID, true)
  end
end


function gadget:UnitFinished(unitID, unitDefID, teamID)
  local bfrTechLevel = teamTechLevel[teamID] or 0
  AddFactory(unitID, unitDefID, teamID)

  if (reqDefIDs[unitDefID]) then
    local teamReq = teamReqUnits[teamID]
    teamReq[unitDefID] = (teamReq[unitDefID] or 0) + 1
    if (teamReq[unitDefID]==1) then
      UpdateMorphReqs(teamID)
    end
  end

  if (bfrTechLevel~=teamTechLevel[teamID]) then
    UpdateMorphReqs(teamID)
  end
end

function gadget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders)
  if upgradeDefs[unitDefID] then
    FinishMorphGlobal(factID, upgradeUnits[factID])
    Spring.DestroyUnit(unitID, false, true)
  end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  if (morphUnits[unitID]) then
    StopMorph(unitID,morphUnits[unitID])
    morphUnits[unitID] = nil
  end
  if (upgradeUnits[unitID]) then
    FactoryStopUpgrade(unitID, upgradeUnits[unitID].def)
  end
  
  local bfrTechLevel = teamTechLevel[teamID] or 0

  RemoveFactory(unitID, unitDefID, teamID)

  local updateButtons = false
  if (reqDefIDs[unitDefID])and(isFinished(unitID)) then
    local teamReq = teamReqUnits[teamID]
    teamReq[unitDefID] = (teamReq[unitDefID] or 0) - 1
    if (teamReq[unitDefID]==0) then
      StopMorphsOnDevolution(teamID)
      updateButtons = true
    end
  end

  if (bfrTechLevel~=teamTechLevel[teamID]) then
    StopMorphsOnDevolution(teamID)
    updateButtons = true
  end

  if (updateButtons) then UpdateMorphReqs(teamID) end
end


function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
  self:UnitCreated(unitID, unitDefID, teamID)
  if (isFinished(unitID)) then
    self:UnitFinished(unitID, unitDefID, teamID)
  end
end


function gadget:UnitGiven(unitID, unitDefID, newTeamID, oldTeamID)
  self:UnitDestroyed(unitID, unitDefID, oldTeamID)
end


function UnitRanked(unitID,unitDefID,teamID,newRank,oldRank)
  local morphDefSet = morphDefs[unitDefID]

  if (morphDefSet) then
    local teamTech = teamTechLevel[teamID] or 0
    local unitXP   = Spring.GetUnitExperience(unitID)
    for _, morphDef in pairs(morphDefSet) do
      if (morphDef) then
        local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
        if (cmdDescID) then
          local morphCmdDesc = {}
          local teamOwnsReqUnit = UnitReqCheck(teamID,morphDef.require)
          morphCmdDesc.disabled = (morphDef.tech > teamTech)or(morphDef.rank > newRank)or(morphDef.xp > unitXP)or(not teamOwnsReqUnit)
          morphCmdDesc.tooltip  = GetMorphToolTip(unitID, unitDefID, teamID, morphDef, teamTech, unitXP, newRank, teamOwnsReqUnit)
          Spring.EditUnitCmdDesc(unitID, cmdDescID, morphCmdDesc)
        end
      end
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- FIXME: duplicated in LuaUI/Widgets/gui_s44_fieldoffire.lua

-- Returns the position the unit will (probably) have when it reached the end
-- of it's command queue.  Only supports MOVE and FIGHT commands.

function CheckMorphPlace(unitID, unitDefID, teamID, targetDef)
	-- check if morph destination unit can be built here
	-- if morph is called by an immobile unit, then the check should auto-succeed
	local callerMobile = UnitDefs[unitDefID].speed > 0
	if not callerMobile then
		return true
	end
	local destID = targetDef.into
	local unitX, unitY, unitZ = GG.CmdQueue.GetUnitPositionAtEndOfQueue(unitID)
	local result, feature = Spring.TestBuildOrder(destID, unitX, unitY, unitZ, 0)
	if result == 0 then
		Spring.SendMessageToTeam(teamID, UnitDefs[unitDefID].humanName .. ": Can't deploy here!")
	end
	return (result>0)
end

function AddFactory(unitID, unitDefID, teamID)
  if (isFactory(unitDefID)) then
    local unitTechLevel = GetTechLevel(unitDefID)
    if (unitTechLevel > teamTechLevel[teamID]) then
      teamTechLevel[teamID]=unitTechLevel
    end
  end
end


function RemoveFactory(unitID, unitDefID, teamID)
  if (devolution)and(isFactory(unitDefID))and(isFinished(unitID)) then

    --// check all factories and determine team level
    local level = 0
    local teamUnits = Spring.GetTeamUnits(teamID)
    for i=1,#teamUnits do
      local unitID2 = teamUnits[i]
      if (unitID2 ~= unitID) then
        local unitDefID2 = Spring.GetUnitDefID(unitID2)
        if (isFactory(unitDefID2) and isFinished(unitID2)) then
          local unitTechLevel = GetTechLevel(unitDefID2)
          if (unitTechLevel>level) then level = unitTechLevel end
        end
      end
    end

    if (level ~= teamTechLevel[teamID]) then
      teamTechLevel[teamID] = level
    end

  end
end

function StopMorphsOnDevolution(teamID)
  if (stopMorphOnDevolution) then
    for unitID, morphData in pairs(morphUnits) do
      local morphDef = morphData.def
      if (morphData.teamID == teamID)and
         (
           (morphDef.tech>teamTechLevel[teamID])or
           (not UnitReqCheck(teamID, morphDef.require))
         )
      then
        StopMorph(unitID, morphData)
      end
    end
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:GameFrame(n)

  -- start pending morphs
  for unitid, data in pairs(morphToStart) do
    StartMorph(unitid, unpack(data))
  end
  morphToStart = {}

  if ((n+24)%150<1) then
    local unitCount = #XpMorphUnits
    local i = 1

    while (i<=unitCount) do
      local unitdata    = XpMorphUnits[i]
      local unitID      = unitdata.id
      local unitDefID   = unitdata.defID

      local morphDefSet = morphDefs[unitDefID]
      if (morphDefSet) then
        local teamID   = unitdata.team
        local teamTech = teamTechLevel[teamID] or 0
        local unitXP   = Spring.GetUnitExperience(unitID)
        local unitRank = GetUnitRank(unitID)

        local xpMorphLeft = false
        for _,morphDef in pairs(morphDefSet) do
          if (morphDef) then
            local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
            if (cmdDescID) then
              local morphCmdDesc = {}
              local teamOwnsReqUnit = UnitReqCheck(teamID,morphDef.require)
              morphCmdDesc.disabled = (morphDef.tech > teamTech)or(morphDef.rank > unitRank)or(morphDef.xp > unitXP)or(not teamOwnsReqUnit)
              morphCmdDesc.tooltip  = GetMorphToolTip(unitID, unitDefID, teamID, morphDef, teamTech, unitXP, unitRank, teamOwnsReqUnit)
              Spring.EditUnitCmdDesc(unitID, cmdDescID, morphCmdDesc)

              xpMorphLeft = morphCmdDesc.disabled or xpMorphLeft
            end
          end
        end
        if (not xpMorphLeft) then
          --// remove unit in list (it fullfills all xp requirements)
          XpMorphUnits[i] = XpMorphUnits[unitCount]
          XpMorphUnits[unitCount] = nil
          unitCount = unitCount - 1
          i = i - 1
        end
      end
      i = i + 1

    end
  end

  for unitID, morphData in pairs(morphUnits) do
    if (not UpdateMorph(unitID, morphData)) then
      morphUnits[unitID] = nil
    end
  end
  for _, morphData in pairs(upgradeUnits) do
    _,_,_,_,morphData.progress = Spring.GetUnitHealth(morphData.fakeUnit)
  end
  
  PostMorphCreate() -- remove once https://springrts.com/mantis/view.php?id=5862 is implemented
end


function FactoryQueueUpgrade(unitID, morphDef)
    Spring.GiveOrderToUnit(unitID,CMD.INSERT,{-1,-morphDef.upgradeUnit,0},{"ctrl", "alt"})
    local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
    if (cmdDescID) then
        Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=morphDef.stopCmd, name=RedStr.."Stop", type = CMDTYPE.ICON})
    end
end

function FactoryStartUpgrade(unitID, unitDefID, teamID, morphDef, fakeUnitID)
    local upgradeData = {def = morphDef,
                         progress = 0.0,
                         teamID = teamID,
                         fakeUnit = fakeUnitID}
    local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.cmd)
    if (cmdDescID) then
        Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=morphDef.stopCmd, name=RedStr.."Stop", type = CMDTYPE.ICON})
    end
    SendToUnsynced("unit_morph_start", unitID, unitDefID, morphDef.cmd)
    upgradeUnits[unitID] = upgradeData
end

function FactoryStopUpgrade(unitID, morphDef)
    local cmdDescID = Spring.FindUnitCmdDesc(unitID, morphDef.stopCmd)
    if (cmdDescID) then
      Spring.EditUnitCmdDesc(unitID, cmdDescID, {id=morphDef.cmd, name=morphDef.name, type = CMDTYPE.ICON})
    end
    
    Spring.GiveOrderToUnit(unitID, CMD.REMOVE,{-morphDef.upgradeUnit},{"ctrl", "alt"})
    
    upgradeUnits[unitID] = nil
    
    SendToUnsynced("unit_morph_stop", unitID)
end


function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  local morphData = morphUnits[unitID]
  if (morphData) then
    if (cmdID==morphData.def.stopCmd)or(cmdID == CMD.STOP) then
	  if not Spring.GetUnitTransporter(unitID) then
        StopMorph(unitID, morphData)
        morphUnits[unitID] = nil
        return false
	  end
    elseif (cmdID == CMD.ONOFF) then
      return false
	elseif cmdID == CMD.SELFD then
	  StopMorph(unitID, morphData)
      morphUnits[unitID] = nil
    --else --// disallow ANY command to units in morph
    --  return false
    end
  elseif isAMorphCmdID[cmdID] then
    local morphDef = (morphDefs[unitDefID] or {})[cmdID] or extraUnitMorphDefs[unitID]
    if ((morphDef)and
        (morphDef.tech<=teamTechLevel[teamID])and
        (morphDef.rank<=GetUnitRank(unitID))and
        (morphDef.xp<=Spring.GetUnitExperience(unitID))and
        (UnitReqCheck(teamID, morphDef.require)) and
		(CheckMorphPlace(unitID, unitDefID, teamID, morphDef)) )
    then
      if (isFactory(unitDefID)) then
        if cmdID == morphDef.stopCmd then
          FactoryStopUpgrade(unitID, morphDef)
        else
          FactoryQueueUpgrade(unitID, morphDef)
        end
        return false
      else
        return true
      end
    end
    return false
  end

  return true
end


function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  if (isAMorphCmdID[cmdID] == nil) then
    return false  --// command was not used
  end
  local morphDef = (morphDefs[unitDefID] or {})[cmdID] or extraUnitMorphDefs[unitID]
  if (not morphDef) then
    return true, true  --// command was used, remove it
  end
  local morphData = morphUnits[unitID]
  if (not morphData) then
    -- dont start directly to break recursion
    --StartMorph(unitID, unitDefID, teamID, morphDef, cmdParams)
    morphToStart[unitID] = {unitDefID, teamID, morphDef, cmdParams}
    return true, true
  end
  return true, false  --// command was used, do not remove it
end



--------------------------------------------------------------------------------
--  END SYNCED
--------------------------------------------------------------------------------
else
--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------

--// 75b2 compability (removed it in the next release)
if (Spring.GetTeamColor==nil) then
  Spring.GetTeamColor = function(teamID) local _,_,_,_,_,_,r,g,b = Spring.GetTeamInfo(teamID); return r,g,b end
end

--
-- speed-ups
--

local gameFrame;
local SYNCED = SYNCED
local CallAsTeam = CallAsTeam
local spairs = spairs
local snext = snext

local spGetUnitPosition = Spring.GetUnitPosition

local GetUnitTeam         = Spring.GetUnitTeam
local GetUnitHeading      = Spring.GetUnitHeading
local GetGameFrame        = Spring.GetGameFrame
local GetSpectatingState  = Spring.GetSpectatingState
local AddWorldIcon        = Spring.AddWorldIcon
local AddWorldText        = Spring.AddWorldText
local IsUnitVisible       = Spring.IsUnitVisible
local GetLocalTeamID      = Spring.GetLocalTeamID
local spAreTeamsAllied    = Spring.AreTeamsAllied

local glBillboard    = gl.Billboard
local glColor        = gl.Color
local glPushMatrix   = gl.PushMatrix
local glTranslate    = gl.Translate
local glRotate       = gl.Rotate
local glUnitShape    = gl.UnitShape
local glPopMatrix    = gl.PopMatrix
local glText         = gl.Text
local glCulling		 = gl.Culling
local glPushAttrib   = gl.PushAttrib
local glPopAttrib    = gl.PopAttrib
local glPolygonOffset= gl.PolygonOffset
local glBlendFunc     = gl.BlendFunc
local glDepthTest    = gl.DepthTest
local glUnit		 = gl.Unit

local GL_LEQUAL      = GL.LEQUAL
local GL_ONE         = GL.ONE
local GL_SRC_ALPHA   = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_COLOR_BUFFER_BIT = GL.COLOR_BUFFER_BIT

local headingToDegree = (360 / 65535)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local useLuaUI = false
local oldFrame = 0        --//used to save bandwidth between unsynced->LuaUI
local drawProgress = true --//a widget can do this job too (see healthbars)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--//synced -> unsynced actions

local function SelectSwap(cmd, oldID, newID)
  local selUnits = Spring.GetSelectedUnits()
  for i=1,#selUnits do
    local unitID = selUnits[i]
    if (unitID == oldID) then
      selUnits[i] = newID
      Spring.SelectUnitArray(selUnits)
      break
    end
  end


  if (Script.LuaUI('MorphFinished')) then
    if (useLuaUI) then
      local readTeam, spec, specFullView = nil,GetSpectatingState()
      if (specFullView)
        then readTeam = Script.ALL_ACCESS_TEAM
        else readTeam = GetLocalTeamID() end
      CallAsTeam({ ['read'] = readTeam }, function()
        if (IsUnitVisible(oldID)) then
          Script.LuaUI.MorphFinished(oldID,newID)
        end
      end)
    end
  end

  return true
end

local function StartMorph(cmd, unitID, unitDefID, morphID)
  if (Script.LuaUI('MorphStart')) then
    if (useLuaUI) then
      local readTeam, spec, specFullView = nil,GetSpectatingState()
      if (specFullView)
        then readTeam = Script.ALL_ACCESS_TEAM
        else readTeam = GetLocalTeamID() end
      CallAsTeam({ ['read'] = readTeam }, function()
        if (unitID)and(IsUnitVisible(unitID)) then
          Script.LuaUI.MorphStart(unitID, (SYNCED.morphDefs[unitDefID] or {})[morphID] or SYNCED.extraUnitMorphDefs[unitID])
        end
      end)
    end
  end
  return true
end

local function StopMorph(cmd, unitID)
  if (Script.LuaUI('MorphStop')) then
    if (useLuaUI) then
      local readTeam, spec, specFullView = nil,GetSpectatingState()
      if (specFullView)
        then readTeam = Script.ALL_ACCESS_TEAM
        else readTeam = GetLocalTeamID() end
      CallAsTeam({ ['read'] = readTeam }, function()
        if (unitID)and(IsUnitVisible(unitID)) then
          Script.LuaUI.MorphStop(unitID)
        end
      end)
    end
  end
  return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:Initialize()
  gadgetHandler:AddSyncAction("unit_morph_finished", SelectSwap)
  gadgetHandler:AddSyncAction("unit_morph_start", StartMorph)
  gadgetHandler:AddSyncAction("unit_morph_stop", StopMorph)
end


function gadget:Shutdown()
  gadgetHandler:RemoveSyncAction("unit_morph_finished")
  gadgetHandler:RemoveSyncAction("unit_morph_start")
  gadgetHandler:RemoveSyncAction("unit_morph_stop")
end

function gadget:Update()
  local frame = GetGameFrame()
  if (frame>oldFrame) then
    oldFrame = frame
    local morphUnitsSynced = SYNCED.morphUnits
    if snext(morphUnitsSynced) then
      local useLuaUI_ = Script.LuaUI('MorphUpdate')
      if (useLuaUI_~=useLuaUI) then --//Update Callins on change
        drawProgress = not Script.LuaUI('MorphDrawProgress')
        useLuaUI     = useLuaUI_
      end

      if (useLuaUI) then
        local morphTable = {}
        local readTeam, spec, specFullView = nil,GetSpectatingState()
        if (specFullView)
          then readTeam = Script.ALL_ACCESS_TEAM
          else readTeam = GetLocalTeamID() end
        CallAsTeam({ ['read'] = readTeam }, function()
          for unitID, morphData in spairs(morphUnitsSynced) do
            if (unitID and morphData)and(IsUnitVisible(unitID)) then
              morphTable[unitID] = {progress=morphData.progress, into=morphData.def.into, combatMorph = morphData.combatMorph}
            end
          end
        end)
        Script.LuaUI.MorphUpdate(morphTable)
      end

    end
  end
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


--//patchs an annoying popup the first time you morph a unittype(+team)
local alreadyInit = {}
local function InitializeUnitShape(unitDefID,unitTeam)
  local iTeam = alreadyInit[unitTeam]
  if (iTeam)and(iTeam[unitDefID]) then return end

  glPushMatrix()
  gl.ColorMask(false)
  glUnitShape(unitDefID, unitTeam)
  gl.ColorMask(true)
  glPopMatrix()
  if (alreadyInit[unitTeam]==nil) then alreadyInit[unitTeam] = {} end
  alreadyInit[unitTeam][unitDefID] = true
end


local function DrawMorphUnit(unitID, morphData, localTeamID)
  local h = GetUnitHeading(unitID)
  if (h==nil) then
    return  --// bonus, heading is only available when the unit is in LOS
  end
  local px,py,pz = spGetUnitPosition(unitID)
  if (px==nil) then
    return
  end
  local unitTeam = morphData.teamID

  InitializeUnitShape(morphData.def.into,unitTeam) --BUGFIX

  local frac = ((gameFrame + unitID) % 30) / 30
  local alpha = 2.0 * math.abs(0.5 - frac)
  local angle
  if morphData.def.facing then
	angle = math.floor(HeadingToFacing(h)) * 90
  else
    angle = h * headingToDegree
  end

  SetTeamColor(unitTeam,alpha)
  glPushMatrix()
  glTranslate(px, py, pz)
  glRotate(angle, 0, 1, 0)
  glUnitShape(morphData.def.into, unitTeam)
  glPopMatrix()

  --// cheesy progress indicator
  if (drawProgress)and(localTeamID)and
     ( (spAreTeamsAllied(unitTeam,localTeamID)) or (localTeamID==Script.ALL_ACCESS_TEAM) )
  then
    glPushMatrix()
    glPushAttrib(GL_COLOR_BUFFER_BIT)
    glTranslate(px, py+14, pz)
    glBillboard()
    local progStr = string.format("%.1f%%", 100 * morphData.progress)
    gl.Text(progStr, 0, -20, 9, "oc")
    glPopAttrib()
    glPopMatrix()
  end
end

local phase = 0
local function DrawCombatMorphUnit(unitID, morphData, localTeamID)
	local c1=math.sin(phase)*.2 + .2
	local c2=math.sin(phase+ math.pi)*.2 + .2
	local mult = 2

	glBlendFunc(GL_ONE, GL_ONE)
	glDepthTest(GL_LEQUAL)
	--glLighting(true)
	glPolygonOffset(-10, -10)
	glCulling(GL.BACK)
	glColor(c1*mult,0,c2*mult,1)
	glUnit(unitID, true)
	
	glColor(1,1,1,1)
	--glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
	--glPolygonOffset(false)
	--glCulling(false)
	--glDepthTest(false)
end

function gadget:DrawWorld()
  local morphUnits = SYNCED.morphUnits

  if (not snext(morphUnits)) then
    return --//no morphs to draw
  end

  gameFrame = GetGameFrame()

  glBlendFunc(GL_SRC_ALPHA, GL_ONE)
  glDepthTest(GL_LEQUAL)

  local spec, specFullView = GetSpectatingState()
  local readTeam
  if (specFullView) then
    readTeam = Script.ALL_ACCESS_TEAM
  else
    readTeam = GetLocalTeamID()
  end

  CallAsTeam({ ['read'] = readTeam }, function()
    for unitID, morphData in spairs(morphUnits) do
      if (unitID and morphData)and(IsUnitVisible(unitID)) then
		if morphData.combatMorph then
		  DrawCombatMorphUnit(unitID, morphData,readTeam)	
		else
          DrawMorphUnit(unitID, morphData,readTeam)
		end
      end
    end
  end)
  glDepthTest(false)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  phase = phase + .06
end

local function split(msg,sep)
  local s=sep or '|'
  local t={}
  for e in string.gmatch(msg..s,'([^%'..s..']+)%'..s) do
    t[#t+1] = e
  end
  return t
end


-- Exemple of AI messages:
-- "aiShortName|morph|762" -- morph the unit of unitId 762
-- "aiShortName|morph|861|12" -- morph the unit of unitId 861 into an unit of unitDefId 12
--
-- Does not work because apparently Spring.GiveOrderToUnit from unsynced gadgets are ignored.
--
function gadget:AICallIn(data)
  if type(data)=="string" then
    local message = split(data)
    if message[1] == "Shard" or true then-- Because other AI shall be allowed to send such morph command without having to pretend to be Shard
      if message[2] == "morph" and message[3] then
        local unitID = tonumber(message[3])
        if unitID and Spring.ValidUnitID(unitID) then
          if message[4] then
            local destDefId=tonumber(message[4])
            Spring.GiveOrderToUnit(unitID,CMD_MORPH,{destDefId},{})
          else
            Spring.GiveOrderToUnit(unitID,CMD_MORPH,{},{})
          end
        else
          Spring.Log('morph gadget', 'error', "Not a valid unitID in AICallIn morph request: \""..data.."\"")
        end
      end
    end
  end
end

-- Just something to test the above AICallIn
--function gadget:KeyPress(key)
--  if key==32 then--space key
--    gadget:AICallIn("asn|morph|762")
--  end
--end

--------------------------------------------------------------------------------
--  UNSYNCED
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------
--  COMMON
--------------------------------------------------------------------------------