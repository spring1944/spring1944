function gadget:GetInfo()
  return {
    name      = "Spring: 1944 Planes",
    desc      = "Allows structures to order aircraft sorties.",
    author    = "Evil4Zerggin",
    date      = "13 February 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -5,
    enabled   = true  --  loaded by default?
  }
end

if not gadgetHandler:IsSyncedCode() then return end

local sqrt = math.sqrt
local sin, cos, atan2 = math.sin, math.cos, math.atan2

local airfieldCapacity = 10

local CMD_PLANES = 34400
local PATROL_DISTANCE = 1000
local FORMATION_SEPARATION = 128
local DIAG_FORMATION_SEPARATION = FORMATION_SEPARATION * sqrt(2)
local RETREAT_TOLERANCE = 64 --retreating planes disappear when they reach this distance from the map edge
local CRUISE_SPEED = 0.75
local PLANE_STATE_ACTIVE = 0
local PLANE_STATE_RETREAT = 1
local DEPOSIT_AMOUNT = 0.65
local PENALTY_AMOUNT = 0.1

local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local SetUnitPosition = Spring.SetUnitPosition
local SetUnitRotation = Spring.SetUnitRotation
local SetUnitVelocity = Spring.SetUnitVelocity
local AddTeamResource = Spring.AddTeamResource
local UseTeamResource = Spring.UseTeamResource
local GetTeamResources = Spring.GetTeamResources
local GetTeamStartPosition = Spring.GetTeamStartPosition
local GetUnitCmdDescs = Spring.GetUnitCmdDescs
local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local UseUnitResource = Spring.UseUnitResource
local GetUnitFuel = Spring.GetUnitFuel
local GetUnitIsStunned = Spring.GetUnitIsStunned
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitHealth = Spring.GetUnitHealth
local GetGameFrame = Spring.GetGameFrame
local GetGroundHeight = Spring.GetGroundHeight
local SendMessageToTeam = Spring.SendMessageToTeam


local GetTeamRulesParam = Spring.GetTeamRulesParam
local SetTeamRulesParam = Spring.SetTeamRulesParam

local vNormalized = GG.Vector.Normalized
local vRotateY = GG.Vector.RotateY
local vClampToMapSize = GG.Vector.ClampToMapSize
local vNearestMapEdge = GG.Vector.NearestMapEdge
local vDistanceToMapEdge = GG.Vector.DistanceToMapEdge

local DelayCall = GG.Delay.DelayCall

local SetUnitNoSelect = Spring.SetUnitNoSelect
local GiveOrderToUnit = Spring.GiveOrderToUnit

local mapSizeX, mapSizeZ = Game.mapSizeX, Game.mapSizeZ

local CMDTYPE_ICON_MAP = CMDTYPE.ICON_MAP
local CMDTYPE_ICON_UNIT_OR_MAP = CMDTYPE.ICON_UNIT_OR_MAP
local CMD_IDLEMODE = CMD.IDLEMODE
local CMD_AUTOREPAIRLEVEL = CMD.AUTOREPAIRLEVEL
local CMD_MOVE = CMD.MOVE
local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_ATTACK = CMD.ATTACK
local CMD_OPT_SHIFT = CMD.OPT_SHIFT

----------------------------------------------------------------
--cmds
----------------------------------------------------------------
--sortieUnitName = info
local sortieInclude = VFS.Include("LuaRules/Configs/sortie_defs.lua")

--sortieUnitDefID = sortie
local sortieDefs = {}

--cmdID = sortie
--sortie = { unitDefID, unitDefID... name, units, delay, cmdDesc }
local sortieCmdIDs = {}

--build sortie info

local function GetDefaultTooltip(sortie, sortieUnitDef)
  local planeList = {}
  local duration = 0
  for i=1,#sortie do
    local unitDef = UnitDefNames[sortie[i]]
    local planeName = unitDef.humanName
    local fuel = unitDef.maxFuel
    if fuel > 0 and duration then
      if fuel > duration then
        duration = fuel
      end
    else
      duration = nil
    end
  end

  local result = "Call " .. sortieUnitDef.humanName .. " - " .. sortieUnitDef.tooltip .. "\n"
    .. "Delay " .. (sortie.delay or 0) .. "s\n"
    .. "Duration " .. (duration or "Permanent") .. "s"

  return result
end

local currCmdID = CMD_PLANES

for sortieUnitName, sortie in pairs(sortieInclude) do
  --Spring.Echo(sortieUnitName)
  local sortieUnitDef = UnitDefNames[sortieUnitName]
  if sortieUnitDef then
    local sortieUnitDefID = sortieUnitDef.id

    local cmdDesc = {
      id = currCmdID,
	  action = sortieUnitName,
      name = "0 Ready",
      disabled = true,
      cursor = sortie.cursor or "Attack",
      tooltip = sortie.tooltip or GetDefaultTooltip(sortie, sortieUnitDef),
      texture = sortie.texture or "unitpics/" .. sortieUnitDef.buildpicname,
    }

    if sortie.groundOnly then
      cmdDesc.type = CMDTYPE_ICON_MAP
    else
      cmdDesc.type = CMDTYPE_ICON_UNIT_OR_MAP
    end

    sortie.cmdDesc = cmdDesc
    sortie.name = sortieUnitDef.humanName
    sortie.weight = sortie.weight or 0
    sortieCmdIDs[currCmdID] = sortie
    sortieDefs[sortieUnitDefID] = sortie

    currCmdID = currCmdID + 1
  else
    Spring.Echo("<game_planes>: Warning: no UnitDef found for " .. sortieUnitName)
  end
end

--radioUnitID = { sortieCmdDesc, sortieCmdDesc, sortieCmdDesc ...}
local radioDefs = {}

for unitDefID=1, #UnitDefs do
  local unitDef = UnitDefs[unitDefID]
  local buildOptions = unitDef.buildOptions

  local sortieCmdDescs = {}

  for i=1, #buildOptions do
    local buildDefID = buildOptions[i]
    local sortie = sortieDefs[buildDefID]
    if sortie then
      sortieCmdDescs[#sortieCmdDescs+1] = sortie.cmdDesc
    end
  end

  if #sortieCmdDescs > 0 then
    radioDefs[unitDefID] = sortieCmdDescs
  end
end

--unitID = state
local planeStates = {}

--teamID = { unitID = true, unitID = true, unitID = true... }
local radios = {}

----------------------------------------------------------------
--spawning
----------------------------------------------------------------

local function SpawnPlane(teamID, unitname, sx, sy, sz, cmdParams, dx, dy, dz, rotation, waypoint, numInFlight, alwaysAttack)
  if #cmdParams == 3 then
    cmdParams[1], cmdParams[2], cmdParams[3] = vClampToMapSize(cmdParams[1], cmdParams[2], cmdParams[3])
  end

  local unitDef = UnitDefNames[unitname]
  --local speed = unitDef.speed / 30
  local drag = unitDef.drag
  local speed = 20 -- unitDef.maxAcc * (1 - drag) / drag * CRUISE_SPEED
  local altitude = unitDef.wantedHeight
  sy = sy + altitude
  local unitID = CreateUnit(unitname, sx, sy, sz, 0, teamID)
	if unitID ~= nil then
	  SetUnitPosition(unitID, sx, sy, sz)
	  SetUnitVelocity(unitID, dx * speed, dy * speed, dz * speed)
	  SetUnitRotation(unitID, 0, -rotation, 0) --SetUnitRotation uses left-handed convention
	  GiveOrderToUnit(unitID, CMD_IDLEMODE, {0}, {}) --no land
	  if alwaysAttack then
		GiveOrderToUnit(unitID, CMD_ATTACK, cmdParams, {"shift"})
		if waypoint then
		  GiveOrderToUnit(unitID, CMD_PATROL, waypoint, {"shift"})
		end
	  else
		if #cmdParams == 1 then --specific target: attack it, then patrol to waypoint
		  GiveOrderToUnit(unitID, CMD_ATTACK, cmdParams, {"shift"})
		  if waypoint then
			GiveOrderToUnit(unitID, CMD_PATROL, waypoint, {"shift"})
		  end
		else --location: fight to waypoint, then patrol to target
		  if waypoint then
			GiveOrderToUnit(unitID, CMD_FIGHT, waypoint, {"shift"})
		  end
		  GiveOrderToUnit(unitID, CMD_PATROL, cmdParams, {"shift"})
		end
	  end
	  planeStates[unitID] = PLANE_STATE_ACTIVE
	  -- make the plane say something if it's the first in its group
	  if numInFlight==1 then
		if unitDef.customParams.planevoice=="1" then
		  Spring.CallCOBScript(unitID, "PlaneVoice", 1, 1)
		end
	  end
		-- remove fly/land and land at x buttons
		local toRemove = {CMD_IDLEMODE, CMD_AUTOREPAIRLEVEL}
		for _, cmdID in pairs(toRemove) do
			local cmdDescID = Spring.FindUnitCmdDesc(unitID, cmdID)
			Spring.RemoveUnitCmdDesc(unitID, cmdDescID)
		end
	end
end

local function GetFormationOffsets(numUnits, rotation)
  local result = {}
  if numUnits == 1 then
    result[1] = {0, 0, 0}
  elseif numUnits == 2 then
    result[1] = {vRotateY(-FORMATION_SEPARATION, 0, 0, rotation)}
    result[2] = {vRotateY(FORMATION_SEPARATION, 0, 0, rotation)}
  else
    local i = 1
    local pairNum = 0
    while true do
      result[i] = {vRotateY(-DIAG_FORMATION_SEPARATION * pairNum, 0, -DIAG_FORMATION_SEPARATION * pairNum, rotation)}
      i = i + 1
      pairNum = pairNum + 1
      if i > numUnits then break end

      result[i] = {vRotateY(DIAG_FORMATION_SEPARATION * pairNum, 0, -DIAG_FORMATION_SEPARATION * pairNum, rotation)}
      i = i + 1
      if i > numUnits then break end
    end
  end

  return result
end

local function SpawnFlight(teamID, sortie, sx, sy, sz, cmdParams)
  local tx, ty, tz
  if #cmdParams == 1 then
    tx, ty, tz = GetUnitPosition(cmdParams[1])
    if not tx then
      tx, ty, tz = GetTeamStartPosition(teamID)
      cmdParams = {tx, ty, tz}
    end
  else
    tx, ty, tz = cmdParams[1], cmdParams[2], cmdParams[3]
  end

  local dx, dy, dz, dist = vNormalized(tx - sx, 0, tz - sz)
  local rotation = atan2(dx, dz)

  local offsets = GetFormationOffsets(#sortie, rotation)
  if dist >= PATROL_DISTANCE then
    local wbx, wbz = sx + (dist - PATROL_DISTANCE) * dx, sz + (dist - PATROL_DISTANCE) * dz
    for i=1, #sortie do
      local offset = offsets[i]
      local waypoint = {}
      waypoint[1], waypoint[2], waypoint[3] = offset[1] + wbx, 0, offset[3] + wbz
      local ux, uz = offset[1] + sx, offset[3] + sz
      local uy = GetGroundHeight(ux, uz)
      local unitname = sortie[i]
      SpawnPlane(teamID, unitname, ux, uy, uz, cmdParams, dx, dy, dz, rotation, waypoint, i, sortie.alwaysAttack)
    end
  else
    for i=1, #sortie do
      local offset = offsets[i]
      local ux, uz = offset[1] + sx, offset[3] + sz
      local uy = GetGroundHeight(ux, uz)
      local unitname = sortie[i]
      SpawnPlane(teamID, unitname, ux, uy, uz, cmdParams, dx, dy, dz, rotation, waypoint, i, sortie.alwaysAttack)
    end
  end

  SendMessageToTeam(teamID, sortie.name .. " arrived.")
end

local function GetSpawnPoint(teamID, numPlanes)
  local margin = FORMATION_SEPARATION * 0.5 * (numPlanes or 0)
  local sx, sy, sz = GetTeamStartPosition(teamID)
  local rx, ry, rz = vNearestMapEdge(sx, sy, sz, margin)
  return rx, ry, rz
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------
local function GetStockpile(teamID, sortie)
  local cmdID = sortie.cmdDesc.id
  local rulesParamName = "game_planes.stockpile" .. cmdID
  return GetTeamRulesParam(teamID, rulesParamName) or 0
end

local function ModifyWeight(teamID, sortie, amount)
  local rulesParamName = "game_planes.weight"
  local weight = GetTeamRulesParam(teamID, rulesParamName) or 0
  weight = weight + amount * sortie.weight
  SetTeamRulesParam(teamID, "game_planes.weight", weight)
end

local function ModifyStockpile(teamID, sortie, amount)
  local cmdID = sortie.cmdDesc.id
  local rulesParamName = "game_planes.stockpile" .. cmdID
  local stockpile = GetTeamRulesParam(teamID, rulesParamName) or 0
  stockpile = stockpile + amount
  SetTeamRulesParam(teamID, rulesParamName, stockpile)

  ModifyWeight(teamID, sortie, amount)

  local disabled = (stockpile <= 0)

  local editTable = {
    name = stockpile .. " Ready",
    disabled = disabled,
  }

  for unitID, _ in pairs(radios[teamID]) do
    local cmdDescs = GetUnitCmdDescs(unitID)
    for i = 1, #cmdDescs do
      local cmdDesc = cmdDescs[i]
      if cmdDesc.id == cmdID then
        EditUnitCmdDesc(unitID, i, editTable)
      end
    end
  end
end

function gadget:Initialize()
  local allTeams = Spring.GetTeamList()
  for i=1, #allTeams do
    radios[allTeams[i]] = {}
  end

  local allUnits = Spring.GetAllUnits()
  for i=1, #allUnits do
    local unitID = allUnits[i]
    local unitDefID = GetUnitDefID(unitID)
    local teamID = GetUnitTeam(unitID)
    --Spring.Echo(unitID, unitDefID, unitTeam)
    gadget:UnitCreated(unitID, unitDefID, teamID)
  end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
  local sortie = sortieDefs[unitDefID]
  if sortie then
    ModifyWeight(teamID, sortie, 1)
    return
  end
  local sortieCmdDescs = radioDefs[unitDefID]

  if not sortieCmdDescs then return end

  radios[teamID][unitID] = true

  for i=1,#sortieCmdDescs do
		local sortieCmdDesc = sortieCmdDescs[i]
		local stockpile = GetTeamRulesParam(teamID, "game_planes.stockpile" .. sortieCmdDesc.id) or 0
		sortieCmdDesc.name = stockpile .. " Ready"
		sortieCmdDesc.disabled = not (stockpile > 0)
    InsertUnitCmdDesc(unitID, sortieCmdDesc)
  end
end

function gadget:UnitFinished(unitID, unitDefID, teamID)
  local sortie = sortieDefs[unitDefID]
  if not sortie then return end

  ModifyStockpile(teamID, sortie, 1)
  DestroyUnit(unitID, false, true)
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  --planes
  local planeState = planeStates[unitID]
  if planeState == PLANE_STATE_RETREAT or (planeState and cmdID == CMD_IDLEMODE) then
    return false
  end

  -- check if command is a sortie
  local sortie = sortieCmdIDs[cmdID]
  if not sortie then
    return true
  end

  -- check if unit is a radio
  if not radios[teamID][unitID] then
    return true
  end
  
  local _, _, inBuild = GetUnitIsStunned(unitID)

  if inBuild then
    -- can't order
  else
    local stockpile = GetStockpile(teamID, sortie)

    if stockpile > 0 then
      ModifyStockpile(teamID, sortie, -1)
      local sx, sy, sz = GetSpawnPoint(teamID, #sortie)
      DelayCall(SpawnFlight, {teamID, sortie, sx, sy, sz, cmdParams}, sortie.delay * 30)
      SendMessageToTeam(teamID, sortie.name .. " ordered. ETE " .. (sortie.delay or 0) .. "s.")
      local _, _, _, _, _, allyTeam = Spring.GetTeamInfo(teamID)
      for _, alliance in ipairs(Spring.GetAllyTeamList()) do
        if alliance ~= allyTeam and sortie.weight > 0 and not sortie.silent then
          Spring.SendMessageToAllyTeam(alliance, "Incoming enemy aircraft spotted, arriving in 15-45 seconds")
        end
      end
    else
      SendMessageToTeam(teamID, "Sortie not available.")
    end
  end

  return false
end

function gadget:GameFrame(n)
  for unitID, state in pairs(planeStates) do
    local unitDefID = GetUnitDefID(unitID)
    local unitDef = UnitDefs[unitDefID]
    local teamID = GetUnitTeam(unitID)
    if state == PLANE_STATE_ACTIVE then
      if GetUnitFuel(unitID) < 1 and unitDef.maxFuel > 0 then
        SetUnitNoSelect(unitID, true)
        local ex, ey, ez = GetSpawnPoint(teamID)
        GiveOrderToUnit(unitID, CMD_MOVE, {ex, ey, ez}, {})
        planeStates[unitID] = PLANE_STATE_RETREAT
        -- make it say something
        if unitDef.customParams.planevoice=="1" then
          Spring.CallCOBScript(unitID, "PlaneVoice", 1, 3)
        end
      end
    elseif state == PLANE_STATE_RETREAT then
      local ux, uy, uz = GetUnitPosition(unitID)
      if vDistanceToMapEdge(ux, uy, uz) <= RETREAT_TOLERANCE then
	    local hpLeft, totalHp = GetUnitHealth(unitID)
		local deposit = (unitDef.customParams.deposit or DEPOSIT_AMOUNT) * unitDef.metalCost
		local depositReturn = (hpLeft / totalHp) * deposit
        DestroyUnit(unitID, false, true)
		AddTeamResource(teamID, "m", depositReturn)
		--Spring.Echo("Plane safe! " .. depositReturn .. " Command returned!")
      end
    end
  end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  local sortie = sortieDefs[unitDefID]
  if sortie then
    ModifyWeight(teamID, sortie, -1)
    return
  end
  if planeStates[unitID] then
    local unitDef = UnitDefs[unitDefID]
	local curCommand = GetTeamResources(teamID, "metal")
    local penalty = math.min((unitDef.customParams.penalty or PENALTY_AMOUNT) * unitDef.metalCost, curCommand)
    UseTeamResource(teamID, "m", penalty)
	--Spring.Echo("Plane destroyed! " .. penalty .. " additional Command lost!")
  end
  planeStates[unitID] = nil
  radios[teamID][unitID] = nil
end

function gadget:AllowUnitBuildStep(builderID, builderTeam, unitID, unitDefID, part)
  local sortie = sortieDefs[unitDefID]

  if not sortie or sortie.weight <= 0 then return true end

  local rulesParamName = "game_planes.weight"
  local weight = GetTeamRulesParam(builderTeam, rulesParamName) or 0

  if weight > airfieldCapacity then
    return false
  end

  return true
end

function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
  local sortie = sortieDefs[unitDefID]
  if sortie then
    ModifyWeight(unitTeam, sortie, -1)
    return
  end

  radios[unitTeam][unitID] = nil
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
  local _, _, inBuild = GetUnitIsStunned(unitID)
  if inBuild then
    gadget:UnitCreated(unitID, unitDefID, unitTeam)
  else
	  local sortieCmdDescs = radioDefs[unitDefID]
			if sortieCmdDescs then
				radios[unitTeam][unitID] = true
			end
    gadget:UnitFinished(unitID, unitDefID, unitTeam)
  end
end
