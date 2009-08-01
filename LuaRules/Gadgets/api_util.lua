function gadget:GetInfo()
  return {
    name      = "Util API",
    desc      = "General-purpose functions.",
    author    = "Evil4Zerggin",
    date      = "1 August 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -10000,
    enabled   = true  --  loaded by default?
  }
end

local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit

local GetUnitTeam = Spring.GetUnitTeam
local GetUnitPosition = Spring.GetUnitPosition
local SetUnitPosition = Spring.SetUnitPosition
local GetUnitHealth = Spring.GetUnitHealth
local SetUnitHealth = Spring.SetUnitHealth
local GetUnitExperience = Spring.GetUnitExperience
local SetUnitExperience = Spring.SetUnitExperience
local GetUnitStates = Spring.GetUnitStates
local GetCommandQueue = Spring.GetCommandQueue
local GiveOrderToUnit = Spring.GiveOrderToUnit

local CMD_FIRE_STATE = CMD.FIRE_STATE
local CMD_MOVE_STATE = CMD.MOVE_STATE

local function ReplaceUnit(unitID, newUnitDef, teamID)
  if not teamID then 
    teamID = GetUnitTeam(unitID)
  end
  --stats
  local health, maxHealth, paralyzeDamage = GetUnitHealth(unitID)
  local healthProportion = health / maxHealth
  local paralyzeProportion = paralyzeDamage / maxHealth
  local dx, dy, dz = GetUnitPosition(unitID)
  local xp = GetUnitExperience(unitID)
  
  local newUnitID = CreateUnit(newUnitDef, dx, dy, dz, 0, teamID)
  
  local newHealth, newMaxHealth = GetUnitHealth(newUnitID)
  local healthTable = {
    health = healthProportion * newMaxHealth,
    paralyze = paralyzeProportion * newMaxHealth,
  }
  SetUnitHealth(newUnitID, healthTable)
  SetUnitExperience(newUnitID, xp)
  
  --orders
  local states = GetUnitStates(unitID)
  GiveOrderToUnit(newUnitID, CMD_FIRE_STATE, { states.firestate }, 0)
  GiveOrderToUnit(newUnitID, CMD_MOVE_STATE, { states.movestate }, 0)
  
  local commandQueue = GetCommandQueue(unitID)
  for i = 1, #commandQueue do
    local command = commandQueue[i]
    local commandOptions = command.options

    if not commandOptions.internal then
      local orderOptions = {}
      if commandOptions.alt then orderOptions[1] = "alt" end
      if commandOptions.ctrl then orderOptions[#orderOptions+1] = "ctrl" end
      if commandOptions.shift then orderOptions[#orderOptions+1] = "shift" end
      if commandOptions.right then orderOptions[#orderOptions+1] = "right" end
      
      GiveOrderToUnit(newUnitID, command.id, command.params, orderOptions)
    end
    
  end
  
  DestroyUnit(unitID, false, true)
end

GG.Util = {
  ReplaceUnit = ReplaceUnit,
}
