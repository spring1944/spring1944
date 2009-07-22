function gadget:GetInfo()
  return {
    name      = "Prerequisites",
    desc      = "Prerequisites for building certain units.",
    author    = "Evil4Zerggin",
    date      = "21 July 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = -5,
    enables   = true  --  loaded by default?
  }
end

--synced only
if not gadgetHandler:IsSyncedCode() then return end
--[[
----------------------------------------------------------------
--speedups
----------------------------------------------------------------

local GetUnitCmdDescs = Spring.GetUnitCmdDescs
local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local GetUnitIsStunned = Spring.GetUnitIsStunned
local AreTeamsAllied = Spring.AreTeamsAllied
local GetUnitAllyTeam = Spring.GetUnitAllyTeam
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam

----------------------------------------------------------------
--locals
----------------------------------------------------------------
--unitDefID = { teamID = buildable, ... }
local buildables = {}

--unitDefID = { units enabled by unitDefID }
local enables = {}

local prereqDefs = VFS.Include("LuaRules/Configs/prereq_defs.lua")

for unitname, prereqs in pairs(prereqDefs) do
  local unitDefID = UnitDefNames[unitname].id
  buildables[unitDefID] = {}
  
  for i = 1, #prereqs do
    local prereqName = prereqs[i]
    local prereqID = UnitDefNames[prereqName].id
    local enable = enables[prereqID]
    if enable then
      enable[#enable+1] = unitDefID
    else
      enables[prereqID] = {
        unitDefID,
      }
    end
  end
end

local function EnableBuildoption(unitDefID, teamID)
  Spring.Echo("Enabled", UnitDefs[unitDefID].name, unitTeam)
end

local function DisableBuildoption(unitDefID, teamID)
  Spring.Echo("Disabled", UnitDefs[unitDefID].name, unitTeam)
end
]]
----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:Initialize()
  Spring.Echo("init_prereq")
  --[[
  local allUnits = Spring.GetAllUnits()
  
  for i = 1, #allUnits do
    local unitID = allUnits[i]
    local unitDefID = GetUnitDefID(unitID)
    local unitTeam = GetUnitTeam(unitID)
    Spring.Echo("unitinit")
    --gadget:UnitGiven(unitID, unitDefID, unitTeam)
  end
  ]]
end
--[[
function gadget:UnitFinished(unitID, unitDefID, unitTeam)
  Spring.Echo("finished")
  local enable = enables[unitDefID]
  if enable then
    for i = 1, #enable do
      local enableID = enable[i]
      local buildabilty = buildables[enableID]
      Spring.Echo("now")
      if buildabilty[unitTeam] then
        buildabilty[unitTeam] = buildabilty[unitTeam] + 1
      else
        buildabilty[unitTeam] = 1
        --enable
        EnableBuildoption(enableID, unitTeam)
      end
    end
  end
  
  --enable/disable for the unit just finished
  --FIXME
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  --update prereqs
  local enable = enables[unitDefID]
  if enable then
    for i = 1, #enable do
      local enableID = enable[i]
      local buildabilty = buildables[enableID]
      if (buildabilty[unitTeam] or 0) >= 1 then
        buildabilty[unitTeam] = buildabilty[unitTeam] - 1
        if buildabilty[unitTeam] == 0 then
          --disable
          DisableBuildoption(enableID, unitTeam)
        end
      else
        Spring.Echo("<prereqs>: Counting error", UnitDefs[enableID].name, buildabilty[unitTeam])
      end
    end
  end
end

function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
  Spring.Echo("given")
  local _, _, inBuild = GetUnitIsStunned(unitID)
  if not inBuild then
    gadget:UnitFinished(unitID, unitDefID, unitTeam)
  end
end

function gadget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
  local _, _, inBuild = GetUnitIsStunned(unitID)
  if not inBuild then
    gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  end
end
]]
