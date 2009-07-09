function gadget:GetInfo()
  return {
    name      = "Factory Clearer",
    desc      = "Gives units inside factories a gentle nudge toward the outside.",
    author    = "Evil4Zerggin",
    date      = "8 May 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--synced only

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

----------------------------------------------------------------
--locals
----------------------------------------------------------------

--format: unitID = xmin, zmin, xmax, zmax, facing
local infos = {}

local PUSH_SPEED = 0.5
local PUSH_THRESHOLD = 0.25 * PUSH_SPEED * PUSH_SPEED

----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local GetUnitBuildFacing = Spring.GetUnitBuildFacing
local GetUnitIsStunned = Spring.GetUnitIsStunned
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitBasePosition = Spring.GetUnitBasePosition
local SetUnitPosition = Spring.SetUnitPosition
local GetUnitsInRectangle = Spring.GetUnitsInRectangle
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitVelocity = Spring.GetUnitVelocity

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
  local allUnits = Spring.GetAllUnits()
  for i = 1, #allUnits do
    local unitID = allUnits[i]
    gadget:UnitCreated(unitID, GetUnitDefID(unitID))
  end
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
  local unitDef = UnitDefs[unitDefID]
  if #unitDef.buildOptions > 0 and unitDef.speed == 0 then
    local xsize = unitDef.xsize * 4
    local zsize = unitDef.zsize * 4
    local ux, uy, uz = GetUnitBasePosition(unitID)
    local facing = GetUnitBuildFacing(unitID)
    
    local xmin, zmin, xmax, zmax
    if facing % 2 > 0 then
      xmin, xmax = ux - zsize, ux + zsize
      zmin, zmax = uz - xsize, uz + xsize
    else
      xmin, xmax = ux - xsize, ux + xsize
      zmin, zmax = uz - zsize, uz + zsize
    end
    
    infos[unitID] = {xmin, zmin, xmax, zmax, facing}
  end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
  infos[unitID] = nil
end

function gadget:GameFrame(n)
  for unitID, info in pairs(infos) do
    local unitsToMove = GetUnitsInRectangle(info[1], info[2], info[3], info[4])
    local pushX, pushZ = 0, 0
    local facing = info[5]
    if facing == 0 then pushZ = PUSH_SPEED
    elseif facing == 1 then pushX = PUSH_SPEED
    elseif facing == 2 then pushZ = -PUSH_SPEED
    else pushX = -PUSH_SPEED
    end
    for i=1, #unitsToMove do
      local unitToMove = unitsToMove[i]
      local unitDefID = GetUnitDefID(unitToMove)
      local unitDef = UnitDefs[unitDefID]
      if not GetUnitIsStunned(unitToMove) and unitDef.speed > 0 then
        local vx, vy, vz = GetUnitVelocity(unitToMove)
        local vss = vx * vx + vz * vz
        if vss < PUSH_THRESHOLD then
          local ux, uy, uz = GetUnitPosition(unitToMove)
          SetUnitPosition(unitToMove, ux + pushX, uz + pushZ)
        end
      end
    end
  end
end
