function gadget:GetInfo()
  return {
    name      = "Cruise Missiles",
    desc      = "Handles cruise missle/glider movement.",
    author    = "Evil4Zerggin, FLOZi",
    date      = "13 August 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -5,
    enabled   = true  --  loaded by default?
  }
end

if not gadgetHandler:IsSyncedCode() then return end

--unitDefID = defInfo
local cruiseDefIDs = {}

--unitID = info
local cruiseIDs = {}

local terminalIDs = {}

local MIN_HEIGHT = 100
local HEIGHT_SMOOTHING = 0.05
local GRAVITY = Game.gravity
local CMD_ATTACK = CMD.ATTACK

local sin, cos = math.sin, math.cos
local atan2 = math.atan2
local sqrt = math.sqrt
local random = math.random
local PI = math.pi

local mcEnable = Spring.MoveCtrl.Enable
local mcDisable = Spring.MoveCtrl.Disable
local mcSetPosition = Spring.MoveCtrl.SetPosition
local mcSetGravity = Spring.MoveCtrl.SetGravity
local mcSetWindFactor = Spring.MoveCtrl.SetWindFactor
local mcSetDrag = Spring.MoveCtrl.SetDrag
local mcSetTrackGround = Spring.MoveCtrl.SetTrackGround
local mcSetCollideStop = Spring.MoveCtrl.SetCollideStop
local mcSetVelocity = Spring.MoveCtrl.SetVelocity
local mcSetRelativeVelocity = Spring.MoveCtrl.SetRelativeVelocity
local mcSetRotation = Spring.MoveCtrl.SetRotation

local vNormalized = GG.Vector.Normalized

local CallCOBScript = Spring.CallCOBScript
local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local GetUnitDirection = Spring.GetUnitDirection
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitVelocity = Spring.GetUnitVelocity
local GetGroundHeight = Spring.GetGroundHeight
local GetGameFrame = Spring.GetGameFrame
local GetUnitTeam = Spring.GetUnitTeam
local SetUnitNoSelect = Spring.SetUnitNoSelect
local SetUnitAlwaysVisible = Spring.SetUnitAlwaysVisible
local SetUnitVelocity = Spring.SetUnitVelocity

local DelayCall = GG.Delay.DelayCall

function gadget:Initialize()
  for unitDefID = 1, #UnitDefs do
    local unitDef = UnitDefs[unitDefID]
    local customParams = unitDef.customParams
    local accuracy = customParams.cruise_missile_accuracy

    if accuracy then
      local wantedHeight = unitDef.wantedHeight 
      local speed = unitDef.speed
      local gravity = unitDef.myGravity
    
      local dropTime = sqrt(2 * wantedHeight / (GRAVITY * gravity))
      local dropDist = speed * dropTime
      
      cruiseDefIDs[unitDefID] = {
        accuracy = accuracy,
        wantedHeight = wantedHeight,
        gravity = gravity,
        speed = speed,
        dropDist = dropDist,
      }
    end
  end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
  if cmdID ~= CMD_ATTACK then return true end

  if cruiseIDs[unitID] then return false end

  local defInfo = cruiseDefIDs[unitDefID]
  if not defInfo then return true end
  
  if #cmdParams ~= 3 then return false end
  
  local tx, tz = cmdParams[1], cmdParams[3]
  
  local randAngle = random() * 2 * PI
  local radius = sqrt(random()) * defInfo.accuracy
  tx = tx + cos(randAngle) * radius
  tz = tz + sin(randAngle) * radius
  
  local ty = GetGroundHeight(tx, tz)
  
  local ux, _, uz = GetUnitPosition(unitID)
  
  local wantedAlt = ty + defInfo.wantedHeight
  local uy = GetGroundHeight(ux, uz) + MIN_HEIGHT
  if uy < wantedAlt then
    uy = wantedAlt
  end
  
  local dx, dy, dz = tx - ux, ty - uy, tz - uz
  local sx, _, sz, s = vNormalized(dx, 0, dz)
  local vx, vz = sx * defInfo.speed / 30, sz * defInfo.speed / 30
  
  local angle = atan2(sx, sz)
  
  mcEnable(unitID)
  
  mcSetRotation(unitID, 0, angle, 0)
  mcSetVelocity(unitID, vx, 0, vz)
  
  SetUnitNoSelect(unitID, true)
  SetUnitAlwaysVisible(unitID, true)
  
  local dropDist = defInfo.dropDist
  local dropDelay = 30 * (s - dropDist) / defInfo.speed
  
  if dropDelay < 0 then
    ux, uz = tx - dropDist * sx, tz - dropDist * sz
    uy = GetGroundHeight(ux, uz) + MIN_HEIGHT
    if uy < wantedAlt then
      uy = wantedAlt
    end
    dropDelay = 0
  end
  
  mcSetPosition(unitID, ux, uy, uz)
  
  cruiseIDs[unitID] = {
    defInfo = defInfo,
    wantedAlt = wantedAlt,
    dropFrame = GetGameFrame() + dropDelay,
  }
  
  return false
end

function gadget:GameFrame(n)
  for unitID, info in pairs(cruiseIDs) do
    local defInfo = info.defInfo
    if n >= info.dropFrame then
      terminalIDs[unitID] = info
      cruiseIDs[unitID] = nil
      
      CallCOBScript(unitID, "Falling", 0, 0)
      mcSetTrackGround(unitID, true)
      mcSetCollideStop(unitID, true)
      mcSetGravity(unitID, defInfo.gravity)
    else
      local ux, uy, uz = GetUnitPosition(unitID)
      local diff = info.wantedAlt - uy
      local nextAlt = uy + diff * HEIGHT_SMOOTHING
      
      uy = GetGroundHeight(ux, uz) + MIN_HEIGHT
      if uy < nextAlt then
        uy = nextAlt
      end
      
      mcSetPosition(unitID, ux, uy, uz)
    end
  end
  
  for unitID, info in pairs(terminalIDs) do
    local vx, vy, vz = GetUnitVelocity(unitID)
    local sx, _, sz, s = vNormalized(vx, 0, vz)
    local angleY = atan2(vx, vz)
    local angleX = -atan2(vy, s)
    
    mcSetRotation(unitID, angleX, angleY, 0)
  end
end

function gadget:MoveCtrlNotify(unitID, unitDefID, unitTeam, data)
  if terminalIDs[unitID] then
		local x,y,z = GetUnitPosition(unitID)
		local vx, _, vz = GetUnitVelocity(unitID)
		--SetUnitVelocity(unitID, 0.4 * vx, 0, 0.4 * vz) -- this prevents excessive corpse travelling
		DestroyUnit(unitID)
		local ud = UnitDefs[unitDefID]
		local gliderSquad = ud.customParams.spawn_on_death or nil
		local spawnDelay = ud.customParams.deathspawn_delay or 70
		if gliderSquad then
			local delay = spawnDelay
			DelayCall(CreateUnit, {gliderSquad, x + vx * delay * 0.2, y, z + vz * delay * 0.2, 0, unitTeam}, delay)
			DelayCall(CreateUnit, {"gbrgliderresource", x + vx * delay * 0.15, y, z + vz * delay * 0.15, 0, unitTeam}, delay)
		end
    return true
  end
  
  return false
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
  cruiseIDs[unitID] = nil
  terminalIDs[unitID] = nil
end
