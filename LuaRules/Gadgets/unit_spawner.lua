--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:GetInfo()
  return {
    name      = "Chicken Spawner",
    desc      = "Spawns burrows and chicken",
    author    = "quantum",
    date      = "April 29, 2008",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if (not gadgetHandler:IsSyncedCode()) then
  return false  --  no unsynced code
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



gameMode = Spring.GetModOption("gamemode")
if (gameMode and string.sub(gameMode, 1, 7) ~= "chicken") then
  return false
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local Spring = Spring
local math = math
local Game = Game
local table = table
local coroutine = coroutine
local pi = math.pi
local cos = math.cos
local ipairs = ipairs
local pairs = pairs

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function SetToList(set)
  local list = {}
  for k in pairs(set) do
    table.insert(list, k)
  end
  return list
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


do -- load config file
  local CONFIG_FILE = "LuaRules/Configs/spawn_defs.lua"
  local VFSMODE = VFS.RAW_FIRST
  local s = assert(VFS.LoadFile(CONFIG_FILE, VFSMODE))
  local chunk = assert(loadstring(s, file))
  setfenv(chunk, gadget)
  chunk()
end


local function SetGlobals(difficulty)
  local g              = gadget[difficulty]
  chicken              = g.units
  alwaysVisible        = g.alwaysVisible
  burrowSpawnRate      = g.burrowSpawnRate
  firstSpawnSize       = g.firstSpawnSize
  spawnGrowthFactor    = g.spawnGrowthFactor
  spawnGrowthIncrease  = g.spawnGrowthIncrease
  chickenSpawnRate     = g.chickenSpawnRate
  techSpawnBonus       = g.techSpawnBonus
end


if (gameMode == "chickeneasy") then -- set difficulty
  SetGlobals("easy")
elseif (gameMode == "chickennormal") then
  SetGlobals("normal")
elseif (gameMode == "chickenhard") then
  SetGlobals("hard")
elseif (not gameMode) then
  SetGlobals(defaultDifficulty)
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local burrows          = {}
local commanders       = {}
local gaiaTeamID       = Spring.GetGaiaTeamID()
local techLevel        = 0
local maxTries         = 100
local computerTeams    = {}
local humanTeams       = {}
local lagging          = false
local cpuUsages        = {}
local chickenBirths    = {}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


if (not gameMode) then -- set human and computer teams
  humanTeams[0]    = true
  computerTeams[1] = true
else
  local teams = Spring.GetTeamList()
  for _, teamID in ipairs(teams) do
    humanTeams[teamID] = true
  end
end


computerTeams[gaiaTeamID] = true
humanTeams[gaiaTeamID]    = nil
humanTeamCount = 0
for _ in pairs(humanTeams) do
  humanTeamCount = humanTeamCount + 1
end


local malus = humanTeamCount + (humanTeamCount-1)*playerMalus


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


burrowSpawnRate = math.floor(burrowSpawnRate/malus)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function PreventLag()
  local n = Spring.GetGameFrame()
  local players = Spring.GetPlayerList()
  for _, playerID in ipairs(players) do
    local _, active, spectator, _, _, _, cpuUsage = Spring.GetPlayerInfo(playerID)
    if (cpuUsage > 0) then
      cpuUsages[playerID] = {cpuUsage=math.min(cpuUsage, 1.2), frame=n}
    end
  end
  if (n > 30*10) then
    local toRemove = {}
    for playerID, t in pairs(cpuUsages) do
      if (n-t.frame > 30*60) then
        table.insert(toRemove, playerID)
      end
      local _, active = Spring.GetPlayerInfo(playerID)
      if (not active) then
        table.insert(toRemove, playerID)
      end
    end
    for _, playerID in ipairs(toRemove) do
      cpuUsages[playerID] = nil
    end
    local cpuUsageCount = 0
    local cpuUsageSum   = 0
    for playerID, t in pairs(cpuUsages) do
      cpuUsageSum   = cpuUsageSum + t.cpuUsage
      cpuUsageCount = cpuUsageCount + 1
    end
    local averageCpu = cpuUsageSum/cpuUsageCount
    if (averageCpu > lagTrigger+triggerTolerance) then
      if (not lagging) then
        Spring.SendMessage("Lag prevention mode on")
      end
      lagging = true

    end
    if (averageCpu < lagTrigger-triggerTolerance) then
      if (lagging) then
        Spring.SendMessage("Lag prevention mode off")
      end
      lagging = false
    end
  end
end


local function KillAllChicken()
  local gaiaUnits = Spring.GetTeamUnits(gaiaTeamID)
  for _, unitID in ipairs(gaiaUnits) do
    if (UnitDefNames[borrowName].id ~= Spring.GetUnitDefID(unitID)) then
      Spring.DestroyUnit(unitID)
    end
  end
end


local function KillOldChicken()
  for unitID, birthDate in pairs(chickenBirths) do
    local age = Spring.GetGameSeconds() - birthDate
    if (age > maxAge) then
      Spring.DestroyUnit(unitID)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function ChooseChicken()
  choices = {}
  for chickenName, c in pairs(chicken) do
    if (c.tech <= techLevel) then
      local chance = math.floor(c.initialChance + (techLevel - c.tech) * c.chanceIncrease)
      for i=1, chance do
        table.insert(choices, chickenName)
      end
    end
  end
  return choices[math.random(#choices)]
end


local function ChooseTarget()
  
  if (targetComm) then
    local commanderList = SetToList(commanders)
    if (#commanderList == 0) then
      return nil
    else
      local commander = commanderList[math.random(#commanderList)]
      return Spring.GetUnitPosition(commander)
    end
    
  else
    local humanTeamList = SetToList(humanTeams)
    if (#humanTeamList == 0) then
      return
    end
    local teamID = humanTeamList[math.random(#humanTeamList)]
    local units  = Spring.GetTeamUnits(teamID)
    local unitID = units[math.random(#units)]
    return Spring.GetUnitPosition(unitID)
  end
  
end


local function SpawnChicken(burrowID, guard)
  if (Spring.GetTeamUnitCount(gaiaTeamID) > maxChicken or lagging) then
    return
  end
  local x, z
  local bx, by, bz  = Spring.GetUnitPosition(burrowID)
  local age         = Spring.GetGameSeconds() - burrows[burrowID].creation
  local tries       = 0
  local spawnNumber = math.floor(firstSpawnSize*(1+spawnGrowthFactor)^age +
                                 spawnGrowthIncrease*age + 
                                 techLevel*techSpawnBonus)
  local s           = spawnSquare
  
  for i=1, spawnNumber do
    repeat
      x = math.random(bx - s, bx + s)
      z = math.random(bz - s, bz + s)
      s = s + spawnSquareIncrement
      tries = tries + 1
    until (not Spring.GetGroundBlocked(x, z) or tries > spawnNumber + maxTries)
    
    local unitID = Spring.CreateUnit(ChooseChicken(), x, 0, z, "n", gaiaTeamID)
    
    if (guard) then
      Spring.GiveOrderToUnit(burrowID, CMD.GUARD, { factID }, {})
    else
      if (math.random(math.floor(1/guardianRatio)) == 1) then
        Spring.GiveOrderToUnit(burrowID, CMD.GUARD, { factID }, {})
      end
      local tx, ty, tz  = ChooseTarget()
      if (tx and ty and tz) then
        Spring.GiveOrderToUnit(unitID, CMD.FIGHT, {tx, ty, tz}, {})
      end
    end
    
    -- 
    
    if (alwaysVisible) then
      Spring.SetUnitAlwaysVisible(unitID, true)
    end
    
  end
  
end


local function SpawnBurrow()

  local x, z
  local tries = 0
  
  repeat
    x = math.random(0, Game.mapSizeX)
    z = math.random(0, Game.mapSizeZ)
    tries = tries + 1
  until ((not Spring.GetGroundBlocked(x, z)) or tries > maxTries)
  
  local unitID = Spring.CreateUnit(burrowName, x, 0, z, "n", gaiaTeamID)
  burrows[unitID] = {}
  burrows[unitID].creation  = Spring.GetGameSeconds() 
  burrows[unitID].lastSpawn = Spring.GetGameSeconds()
  Spring.SetUnitBlocking(unitID, true)
  
  if (alwaysVisible) then
    Spring.SetUnitAlwaysVisible(unitID, true)
  end
  
end


local function IncrementTechLevel(n)
  n = n or 1
  for i=1, n do
    techLevel = techLevel + 1/malus
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local function DisableUnit(unitID)
  Spring.SetUnitPosition(unitID, Game.mapSizeX+500, Game.mapSizeZ+500)
  Spring.SetUnitHealth(unitID, {paralyze=99999999})
  Spring.SetUnitCloak(unitID, 4)
  Spring.SetUnitStealth(unitID, true)
  Spring.SetUnitNoSelect(unitID, true)
  Spring.SetUnitBlocking(unitID, true)
  commanders[unitID] = nil
end


local function DisableComputerUnits()
  for teamID in pairs(computerTeams) do
    local teamUnits = Spring.GetTeamUnits(teamID)
    for _, unitID in ipairs(teamUnits) do
      DisableUnit(unitID)
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function gadget:UnitCreated(unitID, unitDefID, unitTeam)
  
  if (unitTeam  == gaiaTeamID and 
      unitDefID ~= UnitDefNames[burrowName].id) then
    chickenBirths[unitID] = Spring.GetGameSeconds()
  end
  
  if (unitDefID == UnitDefNames["gerhqbunker"].id or
    unitDefID == UnitDefNames["gbrhq"].id or
	unitDefID == UnitDefNames["ruscommander"].id or
     unitDefID == UnitDefNames["ushq"].id) then
    commanders[unitID] = true
  end
  
end


function gadget:GameFrame(n)
  
  if (n == 1) then
    Spring.SendMessage("Don't feed the chicken.")
    DisableComputerUnits()
  end
  
  if ((n+16) % 31 < 0.1) then
    for burrowID, t in pairs(burrows) do
      if (n/30 - t.lastSpawn > chickenSpawnRate) then
        t.lastSpawn = n/30
        SpawnChicken(burrowID)
      end
    end
    PreventLag()
    KillOldChicken()
  end
  
  if ((n+12) % (30 * techTime) < 0.1) then
    IncrementTechLevel()
  end
  
  if ((n+21) % (30 * burrowSpawnRate) < 0.1) then
    SpawnBurrow()
  end
  
end


function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
  chickenBirths[unitID] = nil
  commanders[unitID] = nil
  if (unitDefID == UnitDefNames[burrowName].id) then
    IncrementTechLevel()
    burrows[unitID] = nil
  end
end


function gadget:TeamDied(teamID)
  humanTeams[teamID] = nil
  computerTeams[teamID] = nil
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
